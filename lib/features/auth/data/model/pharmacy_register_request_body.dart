import 'package:json_annotation/json_annotation.dart';

class PharmacyRegisterRequestBody {
  final String username;
  final String email;
  @JsonKey(name: 'phoneNumber')
  final String phoneNumber;
  final String password;
  final String role;
  @JsonKey(name: 'pharmacyName')
  final String pharmacyName;
  final String address;
  final Map<String, dynamic>? location;

  PharmacyRegisterRequestBody({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.role,
    required this.pharmacyName,
    required this.address,
    this.location,
  });

  factory PharmacyRegisterRequestBody.fromJson(Map<String, dynamic> json) {
    return PharmacyRegisterRequestBody(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 'pharmacy',
      pharmacyName: json['pharmacyName'] ?? '',
      address: json['address'] ?? '',
      location: json['location'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'phoneNumber': phoneNumber,
        'password': password,
        'role': role,
        'pharmacyName': pharmacyName,
        'address': address,
        if (location != null) 'location': location,
      };
}

class PharmacyLocation {
  final List<double> coordinates;
  final String type;

  PharmacyLocation({
    required this.coordinates,
    this.type = 'Point',
  });

  factory PharmacyLocation.fromJson(Map<String, dynamic> json) {
    return PharmacyLocation(
      coordinates: List<double>.from(json['coordinates'] ?? []),
      type: json['type'] ?? 'Point',
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'coordinates': coordinates,
      };
}
