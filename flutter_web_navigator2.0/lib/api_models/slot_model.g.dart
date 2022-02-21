// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotModel _$SlotModelFromJson(Map<String, dynamic> json) => SlotModel(
      slotReference: (json['slotReference'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      cageReference: (json['cageReference'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      operatorState: $enumDecode(_$OperatorStateEnumMap, json['operatorState']),
      numberRepetitions: json['numberRepetitions'] as String?,
      referenzeOperator: json['referenzeOperator'] as String?,
      note: json['note'] as String?,
      appointmentType: json['appointmentType'] as String?,
    );

Map<String, dynamic> _$SlotModelToJson(SlotModel instance) => <String, dynamic>{
      'slotReference': instance.slotReference,
      'cageReference': instance.cageReference,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'numberRepetitions': instance.numberRepetitions,
      'referenzeOperator': instance.referenzeOperator,
      'note': instance.note,
      'appointmentType': instance.appointmentType,
      'operatorState': _$OperatorStateEnumMap[instance.operatorState],
    };

const _$OperatorStateEnumMap = {
  OperatorState.Free: 'Free',
  OperatorState.Busy: 'busy',
  OperatorState.Suspended: 'Suspended',
};
