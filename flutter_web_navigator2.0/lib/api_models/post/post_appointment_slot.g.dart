// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_appointment_slot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostAppointmentSlot _$PostAppointmentSlotFromJson(Map<String, dynamic> json) =>
    PostAppointmentSlot(
      smartPaUserId: json['smartPaUserId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      ripetitions: json['ripetitions'] as int?,
      note: json['note'] as String?,
      meetingType: json['meetingType'] as String,
      appointmentSlotTypeId: json['appointmentSlotTypeId'] as String,
      helpDeskId: json['helpDeskId'] as String,
      status: $enumDecodeNullable(_$StatusEnumMap, json['status']),
    );

Map<String, dynamic> _$PostAppointmentSlotToJson(
        PostAppointmentSlot instance) =>
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

const _$StatusEnumMap = {
  Status.free: 'Free',
  Status.busy: 'busy',
  Status.suspended: 'Suspended',
};
