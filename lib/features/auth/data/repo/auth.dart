import '../../../../core/constants/app_strings.dart';
import '../../../../core/helpers/shared_pref_helper.dart';
import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/api_service.dart';
import '../model/forget_password_request_body.dart';
import '../model/forget_password_response.dart';
import '../model/login_request_body.dart';
import '../model/login_response.dart';
import '../model/logout_request_body.dart';
import '../model/logout_response.dart';
import '../model/pharmacy_register_request_body.dart';
import '../model/pharmacy_register_response.dart';
import '../model/resend_verification_request_body.dart';
import '../model/resend_verification_response.dart';
import '../model/reset_password_request_body.dart';
import '../model/reset_password_response.dart';
import '../model/sign_up_request_body.dart';
import '../model/sign_up_response.dart';
import '../model/user.model.dart';
import '../model/verify_email_request_body.dart';
import '../model/verify_email_response.dart';
import 'auth.repo.dart';

class Authentication implements AuthRepo {
  final ApiService _apiService;

  Authentication(this._apiService);

  @override
  Future<ApiResult<ForgetPasswordResponse>> forgotPassword(
      ForgetPasswordRequestBody forgetPasswordRequestBody) async {
    try {
      final response =
          await _apiService.forgetPassword(forgetPasswordRequestBody);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    try {
      final token =
          await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
      if (token.isNotEmpty) {
        return AppUser(
          id: 'current_user_id',
          email: 'user@example.com',
          name: 'Current User',
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<ApiResult<LoginResponse>> loginWithEmailPassword(
      LoginRequestBody body) async {
    try {
      final response = await _apiService.login(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<LogoutResponse>> logout(LogoutRequestBody body) async {
    try {
      final response = await _apiService.logout(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<SignupResponse>> registerWithEmailPassword(
      SignupRequestBody body) async {
    try {
      final response = await _apiService.register(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<PharmacyRegisterResponse>> registerPharmacy(
      PharmacyRegisterRequestBody body) async {
    try {
      final response = await _apiService.pharmacyRegister(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<AppUser?> signInWithGoogle() {
    return Future.value(null);
  }

  @override
  Future<ApiResult<VerifyEmailResponse>> verifyEmail(
      VerifyEmailRequestBody body) async {
    try {
      final response = await _apiService.verifyEmail(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<ResendVerificationResponse>> resendVerificationCode(
      ResendVerificationRequestBody body) async {
    try {
      final response = await _apiService.resendVerificationCode(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }

  @override
  Future<ApiResult<ResetPasswordResponse>> resetPassword(
      ResetPasswordRequestBody body) async {
    try {
      final response = await _apiService.resetPassword(body);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ErrorHandler.handle(e));
    }
  }
}
