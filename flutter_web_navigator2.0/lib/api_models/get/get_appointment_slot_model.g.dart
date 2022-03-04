// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_appointment_slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentSlotList _$AppointmentSlotListFromJson(Map<String, dynamic> json) =>
    AppointmentSlotList(
      totalCount: json['totalCount'] as int,
      items: (json['items'] as List<dynamic>)
          .map((e) => AppointmentSlot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AppointmentSlotListToJson(
        AppointmentSlotList instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'items': instance.items,
    };

AppointmentSlot _$AppointmentSlotFromJson(Map<String, dynamic> json) =>
    AppointmentSlot(
      id: json['id'] as int,
      startDate: DateTime.parse(json['startDate'] as String),
      appointmentSlotTypeId: json['appointmentSlotTypeId'] as int,
      helpDeskId: json['helpDeskId'] as int,
      status: $enumDecode(_$StatusEnumMap, json['status']),
      name: json['name'] as String,
      smartPaUserIdOperator: json['smartPaUserIdOperator'] as String,
    );

Map<String, dynamic> _$AppointmentSlotToJson(AppointmentSlot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'smartPaUserIdOperator': instance.smartPaUserIdOperator,
      'appointmentSlotTypeId': instance.appointmentSlotTypeId,
      'helpDeskId': instance.helpDeskId,
      'status': _$StatusEnumMap[instance.status],
    };

const _$StatusEnumMap = {
  Status.free: 'Free',
  Status.busy: 'busy',
  Status.suspended: 'Suspended',
};

AppointmentSlotById _$AppointmentSlotByIdFromJson(Map<String, dynamic> json) =>
    AppointmentSlotById(
      smartPaUserId: json['smartPaUserId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      ripetitions: json['ripetitions'] as int?,
      note: json['note'] as String?,
      meetingType: json['meetingType'] as String,
      appointmentSlotTypeId: json['appointmentSlotTypeId'] as int,
      helpDeskId: json['helpDeskId'] as int,
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']),
    );

Map<String, dynamic> _$AppointmentSlotByIdToJson(
        AppointmentSlotById instance) =>
    <String, dynamic>{
      'smartPaUserId': instance.smartPaUserId,
      'startDate': instance.startDate.toIso8601String(),
      'ripetitions': instance.ripetitions,
      'note': instance.note,
      'meetingType': instance.meetingType,
      'appointmentSlotTypeId': instance.appointmentSlotTypeId,
      'helpDeskId': instance.helpDeskId,
      'status': _$StatusEnumMap[instance.status],
    };
