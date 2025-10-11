import 'package:json_annotation/json_annotation.dart';

part 'device_model.g.dart';

@JsonSerializable()
class DeviceModel {
  @JsonKey(name: 'device_id')
  final String deviceId;
  final String name;
  final String imei;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'is_active')
  final bool isActive;

  DeviceModel({
    required this.deviceId,
    required this.name,
    required this.imei,
    required this.userId,
    required this.isActive,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) => _$DeviceModelFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);
}
