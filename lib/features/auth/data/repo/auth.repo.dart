import '../../../../core/networking/api_result.dart';
import '../model/forget_password_request_body.dart';
import '../model/forget_password_response.dart';
import '../model/login_request_body.dart';
import '../model/login_response.dart';
import '../model/logout_request_body.dart';
import '../model/logout_response.dart';
import '../model/pharmacy_register_request_body.dart';
import '../model/pharmacy_register_response.dart';
import '../model/reset_password_request_body.dart';
import '../model/reset_password_response.dart';
import '../model/resend_verification_request_body.dart';
import '../model/resend_verification_response.dart';
import '../model/sign_up_request_body.dart';
import '../model/sign_up_response.dart';
import '../model/user.model.dart';
import '../model/verify_email_request_body.dart';
import '../model/verify_email_response.dart';

abstract class AuthRepo {
  Future<AppUser?> getCurrentUser();
  Future<ApiResult<SignupResponse>> registerWithEmailPassword(
      SignupRequestBody body);
  Future<ApiResult<PharmacyRegisterResponse>> registerPharmacy(
      PharmacyRegisterRequestBody body);
  Future<ApiResult<LoginResponse>> loginWithEmailPassword(
      LoginRequestBody body);
  Future<ApiResult<VerifyEmailResponse>> verifyEmail(
      VerifyEmailRequestBody body);
  Future<ApiResult<ResendVerificationResponse>> resendVerificationCode(
      ResendVerificationRequestBody body);
  Future<ApiResult<ForgetPasswordResponse>> forgotPassword(
      ForgetPasswordRequestBody body);
  Future<ApiResult<ResetPasswordResponse>> resetPassword(
      ResetPasswordRequestBody body);
  Future<ApiResult<LogoutResponse>> logout(LogoutRequestBody body);
  Future<AppUser?> signInWithGoogle();
}
