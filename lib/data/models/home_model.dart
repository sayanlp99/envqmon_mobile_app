import 'package:json_annotation/json_annotation.dart';

part 'home_model.g.dart';

@JsonSerializable()
class HomeModel {
  @JsonKey(name: 'home_id')
  final String homeId;

  @JsonKey(name: 'home_name')
  final String homeName;

  @JsonKey(fromJson: _addressFromJson)
  final String address;

  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'createdAt')
  final String createdAt;

  @JsonKey(name: 'updatedAt')
  final String updatedAt;

  HomeModel({
    required this.homeId,
    required this.homeName,
    required this.address,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => _$HomeModelFromJson(json);
  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
  static String _addressFromJson(dynamic value) {
    if (value == null || (value is String && value.trim().isEmpty)) {
      return 'N/A';
    }
    return value as String;
  }
}
