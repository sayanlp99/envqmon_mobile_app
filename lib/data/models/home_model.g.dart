// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModel _$HomeModelFromJson(Map<String, dynamic> json) => HomeModel(
  homeId: json['home_id'] as String,
  name: json['name'] as String,
  address: json['address'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$HomeModelToJson(HomeModel instance) => <String, dynamic>{
  'home_id': instance.homeId,
  'name': instance.name,
  'address': instance.address,
  'user_id': instance.userId,
};
