import 'package:json_annotation/json_annotation.dart';

part 'home_model.g.dart';

@JsonSerializable()
class HomeModel {
  @JsonKey(name: 'home_id')
  final String homeId;
  final String name;
  final String address;
  @JsonKey(name: 'user_id')
  final String userId;

  HomeModel({
    required this.homeId,
    required this.name,
    required this.address,
    required this.userId,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => _$HomeModelFromJson(json);
  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
}
