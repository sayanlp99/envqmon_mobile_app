// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorDataModel _$SensorDataModelFromJson(Map<String, dynamic> json) =>
    SensorDataModel(
      deviceId: json['device_id'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      co: (json['co'] as num).toDouble(),
      methane: (json['methane'] as num).toDouble(),
      lpg: (json['lpg'] as num).toDouble(),
      pm25: (json['pm2_5'] as num).toDouble(),
      pm10: (json['pm10'] as num).toDouble(),
      noise: (json['noise'] as num).toDouble(),
      light: (json['light'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$SensorDataModelToJson(SensorDataModel instance) =>
    <String, dynamic>{
      'device_id': instance.deviceId,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'pressure': instance.pressure,
      'co': instance.co,
      'methane': instance.methane,
      'lpg': instance.lpg,
      'pm2_5': instance.pm25,
      'pm10': instance.pm10,
      'noise': instance.noise,
      'light': instance.light,
      'timestamp': instance.timestamp.toIso8601String(),
    };
