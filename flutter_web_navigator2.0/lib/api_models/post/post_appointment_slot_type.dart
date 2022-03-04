import 'package:es_2022_02_02_1/api_models/get/get_appointment_slot_type_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_appointment_slot_type.g.dart';

@JsonSerializable()
class PostAppointmentSlotType {
  static const fromJsonFactory = _$PostAppointmentSlotTypeFromJson;
  factory PostAppointmentSlotType.fromJson(Map<String, dynamic> json) =>
      _$PostAppointmentSlotTypeFromJson(json);

  Map<String, dynamic> toJson() => _$PostAppointmentSlotTypeToJson(this);

  bool payment;
  String? paymentReason;
  SlotDuration duration;
  String name;

  PostAppointmentSlotType(
      {required this.payment,
      this.paymentReason,
      required this.duration,
      required this.name});
}
