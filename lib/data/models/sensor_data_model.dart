import 'package:json_annotation/json_annotation.dart';

part 'sensor_data_model.g.dart';

@JsonSerializable()
class SensorDataModel {
  final String id;
  @JsonKey(name: 'device_id')
  final String deviceId;
  final double temperature;
  final double humidity;
  final double pressure;
  final double co;
  final double co2;
  final double methane;
  final double lpg;
  @JsonKey(name: 'pm25')
  final double pm25;
  final double pm10;
  final double noise;
  final double light;
  @JsonKey(name: 'recorded_at')
  final String recordedAt;

  SensorDataModel({
    required this.id,
    required this.deviceId,
    required this.temperature,
    required this.humidity,
    required this.pressure,
    required this.co,
    required this.co2,
    required this.methane,
    required this.lpg,
    required this.pm25,
    required this.pm10,
    required this.noise,
    required this.light,
    required this.recordedAt,
  });

  DateTime get timestamp {
    // Convert Unix timestamp string to DateTime
    final timestampInt = int.tryParse(recordedAt) ?? 0;
    return DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000);
  }

  factory SensorDataModel.fromJson(Map<String, dynamic> json) => _$SensorDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$SensorDataModelToJson(this);
}
