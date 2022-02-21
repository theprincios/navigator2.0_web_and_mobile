// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_logged.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLogged _$UserLoggedFromJson(Map<String, dynamic> json) => UserLogged(
      id: json['id'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isSpidUser: json['isSpidUser'] as bool,
      fiscalCode: json['fiscalCode'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$UserLoggedToJson(UserLogged instance) =>
    <String, dynamic>{
      'id': instance.id,
      'avatarUrl': instance.avatarUrl,
      'isSpidUser': instance.isSpidUser,
      'email': instance.email,
      'firstName': instance.firstName,
      'fiscalCode': instance.fiscalCode,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
    };
