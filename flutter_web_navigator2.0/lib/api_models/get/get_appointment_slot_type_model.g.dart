// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_appointment_slot_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentSlotTypeList _$AppointmentSlotTypeListFromJson(
        Map<String, dynamic> json) =>
    AppointmentSlotTypeList(
      totalCount: json['totalCount'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => AppointmentSlotType.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppointmentSlotTypeListToJson(
        AppointmentSlotTypeList instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'items': instance.items,
    };

AppointmentSlotType _$AppointmentSlotTypeFromJson(Map<String, dynamic> json) =>
    AppointmentSlotType(
      id: json['id'] as int,
      name: json['name'] as String,
    );

Map<String, dynamic> _$AppointmentSlotTypeToJson(
        AppointmentSlotType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

AppointmentSlotTypeById _$AppointmentSlotTypeByIdFromJson(
        Map<String, dynamic> json) =>
    AppointmentSlotTypeById(
      id: json['id'] as int,
      payment: json['payment'] as bool,
      paymentReason: json['paymentReason'] as String?,
      duration: $enumDecode(_$SlotDurationEnumMap, json['duration']),
      name: json['name'] as String,
    );

Map<String, dynamic> _$AppointmentSlotTypeByIdToJson(
        AppointmentSlotTypeById instance) =>
    <String, dynamic>{
      'id': instance.id,
      'payment': instance.payment,
      'paymentReason': instance.paymentReason,
      'duration': _$SlotDurationEnumMap[instance.duration],
      'name': instance.name,
    };

const _$SlotDurationEnumMap = {
  SlotDuration.quarterHour: 'QuarterHour',
  SlotDuration.halfHour: 'HalfHour',
  SlotDuration.oneHour: 'OneHour',
  SlotDuration.twoHours: 'TwoHours',
};

AppointmentTypeListShort _$AppointmentTypeListShortFromJson(
        Map<String, dynamic> json) =>
    AppointmentTypeListShort(
      id: json['id'] as int,
      name: json['name'] as String?,
      duration: $enumDecode(_$SlotDurationEnumMap, json['duration']),
    );

Map<String, dynamic> _$AppointmentTypeListShortToJson(
        AppointmentTypeListShort instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'duration': _$SlotDurationEnumMap[instance.duration],
    };
