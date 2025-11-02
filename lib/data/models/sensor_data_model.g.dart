// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SensorDataModel _$SensorDataModelFromJson(Map<String, dynamic> json) =>
    SensorDataModel(
      id: _parseInt(json['id']),
      deviceId: json['device_id'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      humidity: (json['humidity'] as num).toDouble(),
      pressure: (json['pressure'] as num).toDouble(),
      co: (json['co'] as num).toDouble(),
      co2: (json['co2'] as num).toDouble(),
      methane: (json['methane'] as num).toDouble(),
      lpg: (json['lpg'] as num).toDouble(),
      pm25: (json['pm25'] as num).toDouble(),
      pm10: (json['pm10'] as num).toDouble(),
      noise: (json['noise'] as num).toDouble(),
      light: (json['light'] as num).toDouble(),
      recordedAt: _parseInt(json['recorded_at']),
    );

Map<String, dynamic> _$SensorDataModelToJson(SensorDataModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'device_id': instance.deviceId,
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'pressure': instance.pressure,
      'co': instance.co,
      'co2': instance.co2,
      'methane': instance.methane,
      'lpg': instance.lpg,
      'pm25': instance.pm25,
      'pm10': instance.pm10,
      'noise': instance.noise,
      'light': instance.light,
      'recorded_at': instance.recordedAt,
    };
