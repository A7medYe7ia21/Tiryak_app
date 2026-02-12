import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable(createToJson: false)
class LoginResponse {
  String? message;
  @JsonKey(name: 'user')
  UserData? user;
  String? token;

  LoginResponse({this.message, this.user, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class UserData {
  @JsonKey(name: '_id')
  String? id;
  String? username;
  String? email;
  String? phoneNumber;
  String? role;
  bool? isEmailVerified;
  String? createdAt;
  String? updatedAt;

  UserData({
    this.id,
    this.username,
    this.email,
    this.phoneNumber,
    this.role,
    this.isEmailVerified,
    this.createdAt,
    this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
}
