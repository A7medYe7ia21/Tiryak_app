class PharmacyRegisterResponse {
  final String message;
  final PharmacyUser user;

  PharmacyRegisterResponse({
    required this.message,
    required this.user,
  });

  factory PharmacyRegisterResponse.fromJson(Map<String, dynamic> json) {
    return PharmacyRegisterResponse(
      message: json['message'] ?? '',
      user: PharmacyUser.fromJson(json['user']),
    );
  }
}

class PharmacyUser {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String role;
  final bool isEmailVerified;
  final String createdAt;
  final String updatedAt;

  PharmacyUser({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PharmacyUser.fromJson(Map<String, dynamic> json) {
    return PharmacyUser(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      role: json['role'] ?? '',
      isEmailVerified: json['isEmailVerified'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }
}
