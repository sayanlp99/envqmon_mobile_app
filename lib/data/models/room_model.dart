import 'package:json_annotation/json_annotation.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel {
  @JsonKey(name: 'room_id')
  final String roomId;
  final String name;
  @JsonKey(name: 'home_id')
  final String homeId;
  @JsonKey(name: 'user_id')
  final String userId;

  RoomModel({
    required this.roomId,
    required this.name,
    required this.homeId,
    required this.userId,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}
