// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_helpDesk_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostHelpDesk _$PostHelpDeskFromJson(Map<String, dynamic> json) => PostHelpDesk(
      address: json['address'] as String,
      addressPoint:
          AddressPoint.fromJson(json['addressPoint'] as Map<String, dynamic>),
      addressNote: json['addressNote'] as String?,
      name: json['name'] as String,
      publicTransportNote: json['publicTransportNote'] as String?,
      services: (json['services'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PostHelpDeskToJson(PostHelpDesk instance) =>
    <String, dynamic>{
      'addressPoint': instance.addressPoint,
      'addressNote': instance.addressNote,
      'publicTransportNote': instance.publicTransportNote,
      'services': instance.services,
      'name': instance.name,
      'address': instance.address,
    };
