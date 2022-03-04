import 'package:es_2022_02_02_1/api_models/get/get_appointment_slot_model.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post_appointment_slot.g.dart';

@JsonSerializable()
class PostAppointmentSlot {
  static const fromJsonFactory = _$PostAppointmentSlotFromJson;
  factory PostAppointmentSlot.fromJson(Map<String, dynamic> json) =>
      _$PostAppointmentSlotFromJson(json);

  Map<String, dynamic> toJson() => _$PostAppointmentSlotToJson(this);

  String smartPaUserId;
  DateTime startDate;
  int? ripetitions;
  String? note;
  String meetingType;
  String appointmentSlotTypeId;
  String helpDeskId;
  Status? status;

  PostAppointmentSlot(
      {required this.smartPaUserId,
      required this.startDate,
      this.ripetitions,
      this.note,
      required this.meetingType,
      required this.appointmentSlotTypeId,
      required this.helpDeskId,
      this.status});
}
