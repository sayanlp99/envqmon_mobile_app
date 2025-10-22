// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertModel _$AlertModelFromJson(Map<String, dynamic> json) => AlertModel(
  id: (json['id'] as num).toInt(),
  alertType: json['alertType'] as String,
  value: (json['value'] as num).toDouble(),
  unit: json['unit'] as String,
  timestamp: json['timestamp'] as String,
  deviceTopic: json['deviceTopic'] as String,
  userId: json['userId'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$AlertModelToJson(AlertModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'alertType': instance.alertType,
      'value': instance.value,
      'unit': instance.unit,
      'timestamp': instance.timestamp,
      'deviceTopic': instance.deviceTopic,
      'userId': instance.userId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
