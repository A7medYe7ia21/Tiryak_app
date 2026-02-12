import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/helpers/app_regex.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/networking/dio_factory.dart';
import '../data/model/resend_verification_request_body.dart';
import '../data/model/reset_password_request_body.dart';
import '../data/model/sign_up_request_body.dart';
import '../data/model/login_request_body.dart';
import '../data/model/logout_request_body.dart';
import '../data/model/forget_password_request_body.dart';
import '../data/model/pharmacy_register_request_body.dart';
import '../data/model/user.model.dart';

import '../data/model/verify_email_request_body.dart';
import '../data/repo/auth.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Authentication auth;

  bool registerPasswordObsecure = true;

  bool registerPasswordConfirmationObsecure = true;

  bool loginPasswordObsecure = true;

  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;

  AppUser? _currentUser;

  AuthCubit({required this.auth}) : super(AuthState.initial()) {
    listenToPasswordChanges();
  }

  AppUser? get currentUser => _currentUser;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  // Pharmacy specific controllers
  TextEditingController pharmacyNameController = TextEditingController();
  TextEditingController pharmacyAddressController = TextEditingController();
  TextEditingController pharmacyLatitudeController = TextEditingController();
  TextEditingController pharmacyLongitudeController = TextEditingController();

  /// Convert API error messages to user-friendly messages
  String _getFriendlyErrorMessage(String? apiError, String operation) {
    if (apiError == null || apiError.isEmpty) {
      return _getDefaultErrorMessage(operation);
    }

    final errorLower = apiError.toLowerCase();

    // Login specific errors
    if (operation == 'login') {
      if (errorLower.contains('invalid credentials') ||
          errorLower.contains('wrong password') ||
          errorLower.contains('incorrect password') ||
          errorLower.contains('authentication failed')) {
        return 'Invalid email or password. Please check your credentials and try again.';
      }
      if (errorLower.contains('user not found') ||
          errorLower.contains('account not found')) {
        return 'No account found with this email address. Please check your email or sign up.';
      }
      if (errorLower.contains('account disabled') ||
          errorLower.contains('account suspended')) {
        return 'Your account has been disabled. Please contact support for assistance.';
      }
      if (errorLower.contains('too many attempts') ||
          errorLower.contains('rate limit')) {
        return 'Too many login attempts. Please wait a few minutes before trying again.';
      }
    }

    // Registration specific errors
    if (operation == 'register' || operation == 'pharmacy_register') {
      if (errorLower.contains('email already exists') ||
          errorLower.contains('email taken') ||
          errorLower.contains('user already exists')) {
        return 'An account with this email already exists. Please try logging in or use a different email.';
      }
      if (errorLower.contains('phone number already exists') ||
          errorLower.contains('phone taken')) {
        return 'This phone number is already registered. Please use a different phone number.';
      }
      if (errorLower.contains('invalid email') ||
          errorLower.contains('email format')) {
        return 'Please enter a valid email address.';
      }
      if (errorLower.contains('password too weak') ||
          errorLower.contains('password requirements')) {
        return 'Password does not meet security requirements. Please ensure it has uppercase, lowercase, numbers, and special characters.';
      }
      if (errorLower.contains('invalid phone') ||
          errorLower.contains('phone format')) {
        return 'Please enter a valid phone number.';
      }
      if (operation == 'pharmacy_register') {
        if (errorLower.contains('invalid coordinates') ||
            errorLower.contains('invalid location')) {
          return 'Invalid pharmacy location. Please check the coordinates and try again.';
        }
        if (errorLower.contains('pharmacy name required')) {
          return 'Please enter a pharmacy name.';
        }
        if (errorLower.contains('address required')) {
          return 'Please enter the pharmacy address.';
        }
        if (errorLower.contains('email already exists') ||
            errorLower.contains('email taken')) {
          return 'This email is already registered. Please use a different email or contact support if you need to convert your account to a pharmacy.';
        }
      }
    }

    // Email verification specific errors
    if (operation == 'verify') {
      if (errorLower.contains('invalid code') ||
          errorLower.contains('wrong code') ||
          errorLower.contains('incorrect code')) {
        return 'Invalid verification code. Please check the code and try again.';
      }
      if (errorLower.contains('expired') ||
          errorLower.contains('code expired')) {
        return 'Verification code has expired. Please request a new code.';
      }
      if (errorLower.contains('already verified')) {
        return 'Your email is already verified. You can now log in to your account.';
      }
    }

    // Password reset specific errors
    if (operation == 'reset') {
      if (errorLower.contains('user not found') ||
          errorLower.contains('email not found')) {
        return 'No account found with this email address. Please check your email or sign up.';
      }
      if (errorLower.contains('rate limit') ||
          errorLower.contains('too many requests')) {
        return 'Too many reset requests. Please wait before requesting another reset email.';
      }
    }

    // Network and server errors
    if (errorLower.contains('network') ||
        errorLower.contains('connection') ||
        errorLower.contains('timeout')) {
      return 'Network connection error. Please check your internet connection and try again.';
    }

    if (errorLower.contains('server error') ||
        errorLower.contains('internal error') ||
        errorLower.contains('500')) {
      return 'Server error occurred. Please try again later or contact support if the problem persists.';
    }

    // Generic validation errors
    if (errorLower.contains('validation') ||
        errorLower.contains('invalid input')) {
      return 'Please check your input and ensure all fields are filled correctly.';
    }

    // Return the original message if no pattern matches, but make it more user-friendly
    return apiError.length > 100
        ? _getDefaultErrorMessage(operation)
        : apiError;
  }

  String _getDefaultErrorMessage(String operation) {
    switch (operation) {
      case 'login':
        return 'Login failed. Please check your credentials and try again.';
      case 'register':
        return 'Registration failed. Please check your information and try again.';
      case 'verify':
        return 'Email verification failed. Please try again or request a new code.';
      case 'reset':
        return 'Password reset failed. Please try again later.';
      default:
        return 'Something went wrong. Please try again later.';
    }
  }

  void toggleRegisterPasswordObsecure() {
    registerPasswordObsecure = !registerPasswordObsecure;
    emit(registerPasswordObsecure
        ? AuthState.registerPasswordObsecure()
        : AuthState.registerPasswordNotObsecure());
  }

  void toggleRegisterPasswordConfirmationObsecure() {
    registerPasswordConfirmationObsecure =
        !registerPasswordConfirmationObsecure;
    emit(registerPasswordConfirmationObsecure
        ? AuthState.registerPasswordConfirmationObsecure()
        : AuthState.registerPasswordConfirmationNotObsecure());
  }

  void toggleLoginPasswordObsecure() {
    loginPasswordObsecure = !loginPasswordObsecure;
    emit(loginPasswordObsecure
        ? AuthState.loginPasswordObsecure()
        : AuthState.loginPasswordNotObsecure());
  }

  void listenToPasswordChanges() {
    passwordController.addListener(_onPasswordChanged);
  }

  void _onPasswordChanged() {
    final text = passwordController.text;
    hasLowercase = AppRegex.hasLowerCase(text);
    hasUppercase = AppRegex.hasUpperCase(text);
    hasSpecialCharacters = AppRegex.hasSpecialCharacter(text);
    hasNumber = AppRegex.hasNumber(text);
    hasMinLength = AppRegex.hasMinLength(text);

    emit(AuthState.passwordValidations(
      hasLowercase: hasLowercase,
      hasUppercase: hasUppercase,
      hasSpecialCharacters: hasSpecialCharacters,
      hasNumber: hasNumber,
      hasMinLength: hasMinLength,
    ));
  }

  void checkAuth() async {
    emit(AuthState.loading());
    try {
      final AppUser? user = await auth.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.unauthenticated());
      }
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> saveUserToken(String token) async {
    await SharedPrefHelper.setSecuredString(SharedPrefKeys.userToken, token);
    DioFactory.setTokenIntoHeaderAfterLogin(token);
  }

  Future<void> login(LoginRequestBody body) async {
    try {
      emit(AuthState.loading());
      final result = await auth.loginWithEmailPassword(body);
      result.when(
        success: (loginResponse) async {
          if (loginResponse.user != null) {
            final user = AppUser(
              id: loginResponse.user!.id ?? '',
              name: loginResponse.user!.username ?? '',
              email: loginResponse.user!.email ?? '',
              phoneNumber: loginResponse.user!.phoneNumber,
              role: loginResponse.user!.role,
              isEmailVerified: loginResponse.user!.isEmailVerified,
              token: loginResponse.token,
            );
            _currentUser = user;

            // Save token
            await saveUserToken(loginResponse.token ?? '');

            // Clear all fields after successful login
            clearAllFields();

            emit(AuthState.authenticated(user));
          } else {
            emit(AuthState.unauthenticated());
          }
        },
        failure: (error) {
          // Check if email verification is pending
          if (error.apiErrorModel.needsVerification == true &&
              error.apiErrorModel.email != null) {
            emit(
                AuthState.emailVerificationPending(error.apiErrorModel.email!));
          } else {
            final friendlyMessage =
                _getFriendlyErrorMessage(error.apiErrorModel.message, 'login');
            emit(AuthState.error(friendlyMessage));
            emit(AuthState.unauthenticated());
          }
        },
      );
    } catch (e) {
      final friendlyMessage = _getFriendlyErrorMessage(e.toString(), 'login');
      emit(AuthState.error(friendlyMessage));
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> register(SignupRequestBody requestBody) async {
    try {
      emit(AuthState.loading());
      final result = await auth.registerWithEmailPassword(requestBody);
      result.when(
        success: (signupResponse) {
          if (signupResponse.user != null) {
            // Registration successful - emit email verification pending state
            _pendingVerificationEmail = requestBody.email;

            // Clear all fields after successful registration
            clearAllFields();

            emit(AuthState.emailVerificationPending(requestBody.email));
          } else {
            emit(AuthState.unauthenticated());
          }
        },
        failure: (error) {
          final friendlyMessage =
              _getFriendlyErrorMessage(error.apiErrorModel.message, 'register');
          emit(AuthState.error(friendlyMessage));
          emit(AuthState.unauthenticated());
        },
      );
    } catch (e) {
      final friendlyMessage =
          _getFriendlyErrorMessage(e.toString(), 'register');
      emit(AuthState.error(friendlyMessage));
      emit(AuthState.unauthenticated());
    }
  }

  Future<void> registerPharmacy(PharmacyRegisterRequestBody requestBody) async {
    try {
      emit(AuthState.loading());
      final result = await auth.registerPharmacy(requestBody);
      result.when(
        success: (pharmacyResponse) {
          // Pharmacy registration successful - same flow as patient: verify email
          _pendingVerificationEmail = requestBody.email;
          clearPharmacyFields();
          emit(AuthState.emailVerificationPending(requestBody.email));
        },
        failure: (error) {
          final friendlyMessage = _getFriendlyErrorMessage(
              error.apiErrorModel.message, 'pharmacy_register');
          emit(AuthState.error(friendlyMessage));
          emit(AuthState.unauthenticated());
        },
      );
    } catch (e) {
      final friendlyMessage =
          _getFriendlyErrorMessage(e.toString(), 'pharmacy_register');
      emit(AuthState.error(friendlyMessage));
      emit(AuthState.unauthenticated());
    }
  }

  String? _pendingVerificationEmail;
  String? get pendingVerificationEmail => _pendingVerificationEmail;

  Future<void> logout(LogoutRequestBody body) async {
    emit(AuthState.loading());
    await auth.logout(body);
    _currentUser = null;
    await SharedPrefHelper.clearAllSecuredData();

    // Clear all fields when logging out
    clearAllFields();

    emit(AuthState.unauthenticated());
  }

  Future<bool> verifyEmail(String email, String otp) async {
    try {
      emit(AuthState.loading());

      final result = await auth
          .verifyEmail(VerifyEmailRequestBody(email: email, code: otp));

      return result.when(
        success: (verifyResponse) {
          // Email verification successful - create user and authenticate
          if (verifyResponse.user != null) {
            final user = AppUser(
              id: verifyResponse.user!.id ?? '',
              name: verifyResponse.user!.username ?? '',
              email: verifyResponse.user!.email ?? '',
              phoneNumber: verifyResponse.user!.phoneNumber,
              role: verifyResponse.user!.role,
              isEmailVerified: true,
              token: verifyResponse.token,
            );
            _currentUser = user;

            // Save token if provided
            if (verifyResponse.token != null) {
              saveUserToken(verifyResponse.token!);
            }

            // Clear pending verification email
            _pendingVerificationEmail = null;

            emit(AuthState.authenticated(user));
            return true;
          } else {
            final friendlyMessage =
                _getFriendlyErrorMessage('Verification failed', 'verify');
            emit(AuthState.error(friendlyMessage));
            return false;
          }
        },
        failure: (error) {
          final friendlyMessage =
              _getFriendlyErrorMessage(error.apiErrorModel.message, 'verify');
          emit(AuthState.error(friendlyMessage));
          return false;
        },
      );
    } catch (e) {
      final friendlyMessage = _getFriendlyErrorMessage(e.toString(), 'verify');
      emit(AuthState.error(friendlyMessage));
      return false;
    }
  }

  Future<String> forgotPassword(ForgetPasswordRequestBody body) async {
    try {
      final result = await auth.forgotPassword(body);
      return result.when(
        success: (response) =>
            response.message ??
            'Password reset email sent successfully. Please check your inbox.',
        failure: (error) =>
            _getFriendlyErrorMessage(error.apiErrorModel.message, 'reset'),
      );
    } catch (e) {
      return _getFriendlyErrorMessage(e.toString(), 'reset');
    }
  }

  Future<String> resetPassword(ResetPasswordRequestBody body) async {
    try {
      emit(AuthState.loading());
      final result = await auth.resetPassword(body);
      return result.when(
        success: (response) {
          emit(AuthState.initial());
          return response.message ??
              'Password reset successfully. You can now log in with your new password.';
        },
        failure: (error) {
          final friendlyMessage =
              _getFriendlyErrorMessage(error.apiErrorModel.message, 'reset');
          emit(AuthState.error(friendlyMessage));
          return friendlyMessage;
        },
      );
    } catch (e) {
      final friendlyMessage = _getFriendlyErrorMessage(e.toString(), 'reset');
      emit(AuthState.error(friendlyMessage));
      return friendlyMessage;
    }
  }

  Future<bool> resendVerificationCode(
      ResendVerificationRequestBody body) async {
    try {
      final result = await auth.resendVerificationCode(body);
      return result.when(
        success: (response) => true,
        failure: (error) {
          final friendlyMessage =
              _getFriendlyErrorMessage(error.apiErrorModel.message, 'verify');
          emit(AuthState.error(friendlyMessage));
          return false;
        },
      );
    } catch (e) {
      final friendlyMessage = _getFriendlyErrorMessage(e.toString(), 'verify');
      emit(AuthState.error(friendlyMessage));
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthState.loading());
      final user = await auth.signInWithGoogle();
      if (user != null) {
        _currentUser = user;

        // Clear all fields after successful Google sign-in
        clearAllFields();

        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.unauthenticated());
      }
    } catch (e) {
      final friendlyMessage = _getFriendlyErrorMessage(e.toString(), 'login');
      emit(AuthState.error(friendlyMessage));
      emit(AuthState.unauthenticated());
    }
  }

  /// Clear all form controllers for login
  void clearLoginFields() {
    emailController.clear();
    passwordController.clear();
  }

  /// Clear all form controllers for registration
  void clearRegisterFields() {
    nameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    // Reset password validation flags
    hasLowercase = false;
    hasUppercase = false;
    hasSpecialCharacters = false;
    hasNumber = false;
    hasMinLength = false;
  }

  /// Clear all form controllers
  void clearAllFields() {
    nameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    // Reset password validation flags
    hasLowercase = false;
    hasUppercase = false;
    hasSpecialCharacters = false;
    hasNumber = false;
    hasMinLength = false;
  }

  /// Reset to unauthenticated (e.g. after pharmacy register success)
  void resetToUnauthenticated() {
    emit(AuthState.unauthenticated());
  }

  /// Clear pharmacy form controllers
  void clearPharmacyFields() {
    nameController.clear();
    emailController.clear();
    phoneNumberController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    pharmacyNameController.clear();
    pharmacyAddressController.clear();
    pharmacyLatitudeController.clear();
    pharmacyLongitudeController.clear();
    // Reset password validation flags
    hasLowercase = false;
    hasUppercase = false;
    hasSpecialCharacters = false;
    hasNumber = false;
    hasMinLength = false;
  }
}
