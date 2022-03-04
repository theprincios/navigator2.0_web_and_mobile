// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_appointment_slot_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostAppointmentSlotType _$PostAppointmentSlotTypeFromJson(
        Map<String, dynamic> json) =>
    PostAppointmentSlotType(
      payment: json['payment'] as bool,
      paymentReason: json['paymentReason'] as String?,
      duration: $enumDecode(_$SlotDurationEnumMap, json['duration']),
      name: json['name'] as String,
    );

Map<String, dynamic> _$PostAppointmentSlotTypeToJson(
        PostAppointmentSlotType instance) =>
    <String, dynamic>{
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
