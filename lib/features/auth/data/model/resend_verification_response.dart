class ResendVerificationResponse {
  final String? message;
  final bool success;

  ResendVerificationResponse({
    this.message,
    required this.success,
  });

  factory ResendVerificationResponse.fromJson(Map<String, dynamic> json) {
    return ResendVerificationResponse(
      message: json['message'] as String?,
      success: json['success'] as bool? ?? false,
    );
  }
}