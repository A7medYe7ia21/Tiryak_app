import 'package:json_annotation/json_annotation.dart';

part 'logout_request_body.g.dart';

@JsonSerializable(createFactory: false)
class LogoutRequestBody {
  final String email;
  final String password;

  LogoutRequestBody({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LogoutRequestBodyToJson(this);
}
