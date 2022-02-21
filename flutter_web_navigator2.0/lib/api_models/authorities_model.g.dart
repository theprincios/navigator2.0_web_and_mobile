// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authorities_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Authority _$AuthorityFromJson(Map<String, dynamic> json) => Authority(
      isDefault: json['isDefault'] as bool?,
      tenantId: json['tenantId'] as String?,
      authorityId: json['authorityId'] as int?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      logoUrl: json['logoUrl'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AuthorityToJson(Authority instance) => <String, dynamic>{
      'isDefault': instance.isDefault,
      'tenantId': instance.tenantId,
      'authorityId': instance.authorityId,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'logoUrl': instance.logoUrl,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
