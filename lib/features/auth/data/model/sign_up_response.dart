import 'package:json_annotation/json_annotation.dart';
part 'sign_up_response.g.dart';

@JsonSerializable(createToJson: false)
class SignupResponse {
  String? message;
  @JsonKey(name: 'user')
  UserData? user;

  SignupResponse({this.message, this.user});

  factory SignupResponse.fromJson(Map<String, dynamic> json) =>
      _$SignupResponseFromJson(json);
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
