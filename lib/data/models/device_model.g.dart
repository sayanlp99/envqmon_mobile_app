// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) => DeviceModel(
  deviceId: json['device_id'] as String,
  name: json['name'] as String,
  imei: json['imei'] as String,
  userId: json['user_id'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$DeviceModelToJson(DeviceModel instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'name': instance.name,
      'imei': instance.imei,
      'user_id': instance.userId,
      'is_active': instance.isActive,
    };
