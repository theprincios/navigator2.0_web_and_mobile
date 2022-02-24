// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_slot_type_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotTypeModel _$SlotTypeModelFromJson(Map<String, dynamic> json) =>
    SlotTypeModel(
      name: json['name'] as String,
      smartPaCategory: json['smartPaCategory'] as String,
      slotDuration: $enumDecode(_$SlotDurationEnumMap, json['slotDuration']),
      paymentFee: json['paymentFee'] as bool?,
      causalPaymentFee: json['causalPaymentFee'] as String?,
    );

Map<String, dynamic> _$SlotTypeModelToJson(SlotTypeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'smartPaCategory': instance.smartPaCategory,
      'slotDuration': _$SlotDurationEnumMap[instance.slotDuration],
      'paymentFee': instance.paymentFee,
      'causalPaymentFee': instance.causalPaymentFee,
    };

const _$SlotDurationEnumMap = {
  SlotDuration.Fifteen: 'Fifteen',
  SlotDuration.Thirty: 'Thirty',
  SlotDuration.Sixty: 'Sixty',
  SlotDuration.OneHundredTtwenty: 'OneHundredTtwenty',
};
