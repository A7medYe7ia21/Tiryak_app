class ResendVerificationRequestBody {
  final String email;

  ResendVerificationRequestBody({
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}