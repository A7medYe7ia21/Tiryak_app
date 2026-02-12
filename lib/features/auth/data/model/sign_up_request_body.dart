import 'package:json_annotation/json_annotation.dart';

part 'sign_up_request_body.g.dart';

@JsonSerializable(createFactory: false)
class SignupRequestBody {
  final String username;
  final String email;
  @JsonKey(name: 'phoneNumber')
  final String phoneNumber;
  final String password;

  SignupRequestBody({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$SignupRequestBodyToJson(this);
}
