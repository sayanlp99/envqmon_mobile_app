import 'package:json_annotation/json_annotation.dart';

part 'room_model.g.dart';

@JsonSerializable()
class RoomModel {
  @JsonKey(name: 'room_id')
  final String roomId;
  @JsonKey(name: 'room_name')
  final String roomName;
  @JsonKey(name: 'home_id')
  final String homeId;
  @JsonKey(name: 'user_id')
  final String userId;
  final String? type;
  @JsonKey(name: 'createdAt')
  final String createdAt;
  @JsonKey(name: 'updatedAt')
  final String updatedAt;

  RoomModel({
    required this.roomId,
    required this.roomName,
    required this.homeId,
    required this.userId,
    this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) => _$RoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomModelToJson(this);
}
