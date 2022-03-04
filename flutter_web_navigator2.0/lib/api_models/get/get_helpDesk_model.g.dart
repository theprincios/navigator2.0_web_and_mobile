// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_helpDesk_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HelpDeskList _$HelpDeskListFromJson(Map<String, dynamic> json) => HelpDeskList(
      items: (json['items'] as List<dynamic>)
          .map((e) => HelpDesk.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int,
    );

Map<String, dynamic> _$HelpDeskListToJson(HelpDeskList instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'items': instance.items,
    };

HelpDesk _$HelpDeskFromJson(Map<String, dynamic> json) => HelpDesk(
      id: json['id'] as int,
      name: json['name'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$HelpDeskToJson(HelpDesk instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
    };

HelpDeskById _$HelpDeskByIdFromJson(Map<String, dynamic> json) => HelpDeskById(
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

Map<String, dynamic> _$HelpDeskByIdToJson(HelpDeskById instance) =>
    <String, dynamic>{
      'addressPoint': instance.addressPoint,
      'addressNote': instance.addressNote,
      'publicTransportNote': instance.publicTransportNote,
      'services': instance.services,
      'name': instance.name,
      'address': instance.address,
    };

AddressPoint _$AddressPointFromJson(Map<String, dynamic> json) => AddressPoint(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AddressPointToJson(AddressPoint instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

HelpDeskListShort _$HelpDeskListShortFromJson(Map<String, dynamic> json) =>
    HelpDeskListShort(
      id: json['id'] as int,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$HelpDeskListShortToJson(HelpDeskListShort instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
