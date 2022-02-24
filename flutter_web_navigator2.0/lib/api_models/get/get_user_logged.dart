import 'package:json_annotation/json_annotation.dart';
part 'get_user_logged.g.dart';

@JsonSerializable()
class UserLogged {
  static const fromJsonFactory = _$UserLoggedFromJson;

  factory UserLogged.fromJson(Map<String, dynamic> json) =>
      _$UserLoggedFromJson(json);

  Map<String, dynamic> toJson() => _$UserLoggedToJson(this);

  final String id;
  final String? avatarUrl;
  final bool isSpidUser;
  final String email;
  final String firstName;
  final String fiscalCode;
  final String lastName;
  final String? phoneNumber;

  UserLogged({
    required this.id,
    this.avatarUrl,
    required this.isSpidUser,
    required this.fiscalCode,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
  });
}
