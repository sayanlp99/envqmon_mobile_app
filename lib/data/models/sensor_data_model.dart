import 'package:json_annotation/json_annotation.dart';

part 'sensor_data_model.g.dart';

@JsonSerializable()
class SensorDataModel {
  @JsonKey(name: 'device_id')
  final String deviceId;
  final double temperature;
  final double humidity;
  final double pressure;
  final double co;
  final double methane;
  final double lpg;
  @JsonKey(name: 'pm2_5')
  final double pm25;
  final double pm10;
  final double noise;
  final double light;
  @JsonKey(name: 'timestamp')
  final DateTime timestamp;

  SensorDataModel({
    required this.deviceId,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.co,
    required this.methane,
    required this.lpg,
    required this.pm25,
    required this.pm10,
    required this.noise,
    required this.light,
    required this.timestamp,
  });

  factory SensorDataModel.fromJson(Map<String, dynamic> json) => _$SensorDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$SensorDataModelToJson(this);
}
