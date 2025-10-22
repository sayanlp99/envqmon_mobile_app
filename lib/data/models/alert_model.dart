import 'package:json_annotation/json_annotation.dart';

part 'alert_model.g.dart';

@JsonSerializable()
class AlertModel {
  final int id;
  final String alertType;
  final double value;
  final String unit;
  final String timestamp;
  final String deviceTopic;
  final String userId;
  final String createdAt;
  final String updatedAt;

  const AlertModel({
    required this.id,
    required this.alertType,
    required this.value,
    required this.unit,
    required this.timestamp,
    required this.deviceTopic,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) => _$AlertModelFromJson(json);
  Map<String, dynamic> toJson() => _$AlertModelToJson(this);

  String get formattedAlertType {
    switch (alertType) {
      case 'temperature_high':
        return 'High Temperature';
      case 'humidity_high':
        return 'High Humidity';
      case 'pressure_high':
        return 'High Pressure';
      case 'co_high':
        return 'High CO Level';
      case 'methane_high':
        return 'High Methane';
      case 'lpg_high':
        return 'High LPG';
      case 'pm25_high':
        return 'High PM2.5';
      case 'pm10_high':
        return 'High PM10';
      case 'noise_high':
        return 'High Noise';
      default:
        return alertType.replaceAll('_', ' ').split(' ').map((word) => 
          word[0].toUpperCase() + word.substring(1)).join(' ');
    }
  }

  String get formattedValue {
    return '${value.toStringAsFixed(1)} $unit';
  }

  DateTime get createdAtDateTime {
    return DateTime.parse(createdAt);
  }

  DateTime get timestampDateTime {
    return DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
  }
}
