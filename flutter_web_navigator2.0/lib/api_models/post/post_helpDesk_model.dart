import 'dart:developer';

import 'package:es_2022_02_02_1/api_models/get/get_helpDesk_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_helpDesk_model.g.dart';

@JsonSerializable()
class PostHelpDesk {
  static const fromJsonFactory = _$PostHelpDeskFromJson;
  factory PostHelpDesk.fromJson(Map<String, dynamic> json) =>
      _$PostHelpDeskFromJson(json);

  Map<String, dynamic> toJson() => _$PostHelpDeskToJson(this);

  AddressPoint addressPoint;
  String? addressNote;
  String? publicTransportNote;
  List<String>? services;
  String name;
  String address;
  PostHelpDesk(
      {required this.address,
      required this.addressPoint,
      this.addressNote,
      required this.name,
      this.publicTransportNote,
      this.services});
}

enum Service {
  @JsonValue('FreeParking')
  freeParking,
  @JsonValue('PaidParking')
  aidParking,
  @JsonValue('DisabledParking')
  disabledParking,
  @JsonValue('Elevator')
  elevator,
  @JsonValue('WaitingRoom')
  aitingRoom,
}
