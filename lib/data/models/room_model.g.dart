// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => RoomModel(
  roomId: json['room_id'] as String,
  name: json['name'] as String,
  homeId: json['home_id'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$RoomModelToJson(RoomModel instance) => <String, dynamic>{
  'room_id': instance.roomId,
  'name': instance.name,
  'home_id': instance.homeId,
  'user_id': instance.userId,
};
