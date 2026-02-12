class ApiConstants {
  static const String apiBaseUrl = "https://tiryak.vercel.app";
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String pharmacyRegister = "/auth/register";
  static const String verifyEmail = "/auth/verify-email";
  static const String resendVerificationCode = "/auth/resend-verification-code";
  static const String forgetPassword = "/auth/forget-password";
  static const String resetPassword = "/auth/reset-password";
  static const String logout = "/auth/logout";
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
