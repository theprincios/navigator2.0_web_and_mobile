import 'package:json_annotation/json_annotation.dart';
part 'get_appointment_slot_type_model.g.dart';

@JsonSerializable()
class AppointmentSlotTypeList {
  static const fromJsonFactory = _$AppointmentSlotTypeListFromJson;
  factory AppointmentSlotTypeList.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSlotTypeListFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentSlotTypeListToJson(this);

  int totalCount;
  List<AppointmentSlotType> items;

  AppointmentSlotTypeList({required this.totalCount, required this.items});
}

@JsonSerializable()
class AppointmentSlotType {
  static const fromJsonFactory = _$AppointmentSlotTypeFromJson;
  factory AppointmentSlotType.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSlotTypeFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentSlotTypeToJson(this);

  int id;
  String name;

  AppointmentSlotType({
    required this.id,
    required this.name,
  });
}

@JsonSerializable()
class AppointmentSlotTypeById {
  static const fromJsonFactory = _$AppointmentSlotTypeByIdFromJson;
  factory AppointmentSlotTypeById.fromJson(Map<String, dynamic> json) =>
      _$AppointmentSlotTypeByIdFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentSlotTypeByIdToJson(this);

  int id;
  bool payment;
  String? paymentReason;
  SlotDuration duration;
  String name;

  AppointmentSlotTypeById(
      {required this.id,
      required this.payment,
      this.paymentReason,
      required this.duration,
      required this.name});
}

@JsonSerializable()
class AppointmentTypeListShort {
  static const fromJsonFactory = _$AppointmentTypeListShortFromJson;
  factory AppointmentTypeListShort.fromJson(Map<String, dynamic> json) =>
      _$AppointmentTypeListShortFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentTypeListShortToJson(this);

  int id;
  String? name;
  SlotDuration duration;

  AppointmentTypeListShort(
      {required this.id, this.name, required this.duration});
}

enum SlotDuration {
  @JsonValue('QuarterHour')
  quarterHour,

  @JsonValue('HalfHour')
  halfHour,
  @JsonValue('OneHour')
  oneHour,
  @JsonValue('TwoHours')
  twoHours
}
