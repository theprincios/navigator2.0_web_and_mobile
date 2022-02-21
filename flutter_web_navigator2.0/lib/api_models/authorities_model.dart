import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';

part 'authorities_model.g.dart';

@JsonSerializable()
class Authority {
  static const fromJsonFactory = _$AuthorityFromJson;
  factory Authority.fromJson(Map<String, dynamic> json) =>
      _$AuthorityFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorityToJson(this);

  bool? isDefault;
  String? tenantId;
  int? authorityId;
  String? name;
  String? imageUrl;
  String? logoUrl;
  double? latitude;
  double? longitude;

  Authority(
      {this.isDefault,
      this.tenantId,
      this.authorityId,
      this.name,
      this.imageUrl,
      this.logoUrl,
      this.latitude,
      this.longitude});
}
