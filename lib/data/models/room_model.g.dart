// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
  roomId: json['room_id'] as String,
  roomName: json['room_name'] as String,
  homeId: json['home_id'] as String,
  userId: json['user_id'] as String,
  type: json['type'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
  'room_id': instance.roomId,
  'room_name': instance.roomName,
  'home_id': instance.homeId,
  'user_id': instance.userId,
  'type': instance.type,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
