import 'package:json_annotation/json_annotation.dart';

part 'get_appointment_slot_model.g.dart';

@JsonSerializable()
class AppointmentSlotList {
  static const fromJsonFactory = _$AppointmentSlotListFromJson;
  factory AppointmentSlotList.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSlotListFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentSlotListToJson(this);

  int totalCount;
  List<AppointmentSlot> items;

  AppointmentSlotList({required this.totalCount, required this.items});
}

@JsonSerializable()
class AppointmentSlot {
  static const fromJsonFactory = _$AppointmentSlotFromJson;
  factory AppointmentSlot.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSlotFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentSlotToJson(this);

  int id;
  String name;
  DateTime startDate;
  String smartPaUserIdOperator;
  int appointmentSlotTypeId;
  int helpDeskId;
  Status status;

  AppointmentSlot(
      {required this.id,
      required this.startDate,
      required this.appointmentSlotTypeId,
      required this.helpDeskId,
      required this.status,
      required this.name,
      required this.smartPaUserIdOperator});
}

@JsonSerializable()
class AppointmentSlotById {
  static const fromJsonFactory = _$AppointmentSlotByIdFromJson;
  factory AppointmentSlotById.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSlotByIdFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentSlotByIdToJson(this);

  String smartPaUserId;
  DateTime startDate;
  int? ripetitions;
  String? note;
  String meetingType;
  int appointmentSlotTypeId;
  int helpDeskId;
  Status? status;

  AppointmentSlotById(
      {required this.smartPaUserId,
      required this.startDate,
      this.ripetitions,
      this.note,
      required this.meetingType,
      required this.appointmentSlotTypeId,
      required this.helpDeskId,
      this.status});
}

enum MeetingType {
  @JsonValue('Remote')
  remote,
  @JsonValue('Onsite')
  onsite,
}

enum Status {
  @JsonValue('Free')
  free,
  @JsonValue('busy')
  busy,
  @JsonValue('Suspended')
  suspended,
}
