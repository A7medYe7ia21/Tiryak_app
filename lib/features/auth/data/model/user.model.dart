class AppUser {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? role;
  final bool? isEmailVerified;
  final String? token;
  final String? pharmacyName;
  final String? address;
  final PharmacyLocation? location;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.role,
    this.isEmailVerified,
    this.token,
    this.pharmacyName,
    this.address,
    this.location,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['_id'],
      name: json['username'] ?? json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      role: json['role'],
      isEmailVerified: json['isEmailVerified'],
      token: json['token'],
      pharmacyName: json['pharmacyName'],
      address: json['address'],
      location: json['location'] != null
          ? PharmacyLocation.fromJson(json['location'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'isEmailVerified': isEmailVerified,
      'token': token,
      'pharmacyName': pharmacyName,
      'address': address,
      'location': location?.toJson(),
    };
  }
}

class PharmacyLocation {
  final List<double> coordinates;

  PharmacyLocation({required this.coordinates});

  factory PharmacyLocation.fromJson(Map<String, dynamic> json) {
    return PharmacyLocation(
      coordinates: List<double>.from(json['coordinates'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coordinates': coordinates,
    };
  }
}
