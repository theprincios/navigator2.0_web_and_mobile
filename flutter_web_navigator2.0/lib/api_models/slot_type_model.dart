import 'package:json_annotation/json_annotation.dart';
part 'slot_type_model.g.dart';

@JsonSerializable()
class SlotTypeModel {
  static const fromJsonFactory = _$SlotTypeModelFromJson;
  factory SlotTypeModel.fromJson(Map<String, dynamic> json) =>
      _$SlotTypeModelFromJson(json);

  Map<String, dynamic> toJson() => _$SlotTypeModelToJson(this);

  String name;
  String smartPaCategory;
  SlotDuration slotDuration;
  bool? paymentFee;
  String? causalPaymentFee;

  SlotTypeModel(
      {required this.name,
      required this.smartPaCategory,
      required this.slotDuration,
      this.paymentFee,
      this.causalPaymentFee});
}

enum SlotDuration {
  @JsonValue('Fifteen')
  Fifteen,

  @JsonValue('Thirty')
  Thirty,
  @JsonValue('Sixty')
  Sixty,
  @JsonValue('OneHundredTtwenty')
  OneHundredTtwenty
}
