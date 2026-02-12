import 'package:json_annotation/json_annotation.dart';

part 'logout_response.g.dart';

@JsonSerializable(createToJson: false)
class LogoutResponse {
  final String message;

  LogoutResponse({required this.message});

  factory LogoutResponse.fromJson(Map<String, dynamic> json) =>
      _$LogoutResponseFromJson(json);
}
