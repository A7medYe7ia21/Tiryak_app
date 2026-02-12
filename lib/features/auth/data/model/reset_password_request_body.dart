import 'package:json_annotation/json_annotation.dart';

part 'reset_password_request_body.g.dart';

@JsonSerializable(createFactory: false)
class ResetPasswordRequestBody {
  final String email;
  final String token;
  final String newPassword;

  ResetPasswordRequestBody({
    required this.email,
    required this.token,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestBodyToJson(this);
}
