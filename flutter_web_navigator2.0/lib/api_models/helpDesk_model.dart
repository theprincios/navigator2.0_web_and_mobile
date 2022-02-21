import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';

part 'helpDesk_model.g.dart';

@JsonSerializable()
class HelpDeskList {
  static const fromJsonFactory = _$HelpDeskListFromJson;
  factory HelpDeskList.fromJson(Map<String, dynamic> json) =>
      _$HelpDeskListFromJson(json);

  Map<String, dynamic> toJson() => _$HelpDeskListToJson(this);

  int totalCount;
  List<HelpDesk> items;

  HelpDeskList({required this.items, required this.totalCount});
}

@JsonSerializable()
class HelpDesk {
  static const fromJsonFactory = _$HelpDeskFromJson;
  factory HelpDesk.fromJson(Map<String, dynamic> json) =>
      _$HelpDeskFromJson(json);

  Map<String, dynamic> toJson() => _$HelpDeskToJson(this);

  String id;
  String name;
  String address;

  HelpDesk({
    required this.id,
    required this.name,
    required this.address,
  });
}

@JsonSerializable()
class HelpDeskById implements HelpDesk {
  static const fromJsonFactory = _$HelpDeskByIdFromJson;
  factory HelpDeskById.fromJson(Map<String, dynamic> json) =>
      _$HelpDeskByIdFromJson(json);

  Map<String, dynamic> toJson() => _$HelpDeskByIdToJson(this);
  AddressPoint addressPoint;
  String? addressNote;
  String? publicTransportNote;
  List<String>? services;

  HelpDeskById(
      {required this.id,
      required this.address,
      required this.name,
      this.addressNote,
      required this.addressPoint,
      this.publicTransportNote,
      this.services});

  @override
  String address;

  @override
  String id;

  @override
  String name;
}

@JsonSerializable()
class AddressPoint {
  static const fromJsonFactory = _$AddressPointFromJson;
  factory AddressPoint.fromJson(Map<String, dynamic> json) =>
      _$AddressPointFromJson(json);

  Map<String, dynamic> toJson() => _$AddressPointToJson(this);

  double? latitude;
  double? longitude;

  AddressPoint({
    this.latitude,
    this.longitude,
  });
}
