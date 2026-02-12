import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../features/auth/data/model/forget_password_request_body.dart';
import '../../features/auth/data/model/forget_password_response.dart';
import '../../features/auth/data/model/login_request_body.dart';
import '../../features/auth/data/model/login_response.dart';
import '../../features/auth/data/model/logout_request_body.dart';
import '../../features/auth/data/model/logout_response.dart';
import '../../features/auth/data/model/pharmacy_register_request_body.dart';
import '../../features/auth/data/model/pharmacy_register_response.dart';
import '../../features/auth/data/model/resend_verification_request_body.dart';
import '../../features/auth/data/model/resend_verification_response.dart';
import '../../features/auth/data/model/reset_password_request_body.dart';
import '../../features/auth/data/model/reset_password_response.dart';
import '../../features/auth/data/model/sign_up_request_body.dart';
import '../../features/auth/data/model/sign_up_response.dart';
import '../../features/auth/data/model/verify_email_request_body.dart';
import '../../features/auth/data/model/verify_email_response.dart';
import 'api_constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl, ParseErrorLogger? errorLogger}) =
      _ApiService;

  @POST(ApiConstants.login)
  Future<LoginResponse> login(
    @Body() LoginRequestBody loginRequestBody,
  );

  @POST(ApiConstants.register)
  Future<SignupResponse> register(
    @Body() SignupRequestBody signupRequestBody,
  );

  @POST(ApiConstants.pharmacyRegister)
  Future<PharmacyRegisterResponse> pharmacyRegister(
    @Body() PharmacyRegisterRequestBody pharmacyRegisterRequestBody,
  );

  @POST(ApiConstants.verifyEmail)
  Future<VerifyEmailResponse> verifyEmail(
    @Body() VerifyEmailRequestBody verifyEmailRequestBody,
  );

  @POST(ApiConstants.resendVerificationCode)
  Future<ResendVerificationResponse> resendVerificationCode(
    @Query('email') ResendVerificationRequestBody body,
  );

  @POST(ApiConstants.forgetPassword)
  Future<ForgetPasswordResponse> forgetPassword(
    @Body() ForgetPasswordRequestBody forgetPasswordRequestBody,
  );

  @PUT(ApiConstants.resetPassword)
  Future<ResetPasswordResponse> resetPassword(
    @Body() ResetPasswordRequestBody resetPasswordRequestBody,
  );

  @POST(ApiConstants.logout)
  Future<LogoutResponse> logout(
    @Body() LogoutRequestBody logoutRequestBody,
  );
}
