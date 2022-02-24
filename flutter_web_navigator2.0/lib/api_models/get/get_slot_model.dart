import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';

part 'get_slot_model.g.dart';

@JsonSerializable()
class SlotModel {
  static const fromJsonFactory = _$SlotModelFromJson;
  factory SlotModel.fromJson(Map<String, dynamic> json) =>
      _$SlotModelFromJson(json);

  Map<String, dynamic> toJson() => _$SlotModelToJson(this);

  List<String> slotReference;

  List<String> cageReference;
  String startDate;
  String endDate;
  String? numberRepetitions;
  String? referenzeOperator;
  String? note;
  String? appointmentType;
  OperatorState operatorState;

  SlotModel({
    required this.slotReference,
    required this.cageReference,
    required this.startDate,
    required this.endDate,
    required this.operatorState,
    this.numberRepetitions,
    this.referenzeOperator,
    this.note,
    this.appointmentType,
  });
}

enum OperatorState {
  @JsonValue('Free')
  Free,
  @JsonValue('busy')
  Busy,
  @JsonValue('Suspended')
  Suspended,
}
