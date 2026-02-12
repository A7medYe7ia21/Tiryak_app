import 'package:freezed_annotation/freezed_annotation.dart';

import '../data/model/user.model.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated(AppUser user) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;
  const factory AuthState.emailVerificationPending(String email) =
      EmailVerificationPending;
  const factory AuthState.pharmacyRegisterSuccess(String message) =
      PharmacyRegisterSuccess;
  const factory AuthState.error(String message) = AuthError;

  const factory AuthState.registerPasswordObsecure() = RegisterPasswordObsecure;
  const factory AuthState.registerPasswordNotObsecure() =
      RegisterPasswordNotObsecure;

  const factory AuthState.registerPasswordConfirmationObsecure() =
      RegisterPasswordConfirmationObsecure;
  const factory AuthState.registerPasswordConfirmationNotObsecure() =
      RegisterPasswordConfirmationNotObsecure;

  const factory AuthState.loginPasswordObsecure() = LoginPasswordObsecure;
  const factory AuthState.loginPasswordNotObsecure() = LoginPasswordNotObsecure;

  const factory AuthState.passwordValidations({
    required bool hasLowercase,
    required bool hasUppercase,
    required bool hasSpecialCharacters,
    required bool hasNumber,
    required bool hasMinLength,
  }) = PasswordValidationsState;
}
