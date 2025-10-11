// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModel _$HomeModelFromJson(Map<String, dynamic> json) => HomeModel(
  homeId: json['home_id'] as String,
  homeName: json['home_name'] as String,
  address: json['address'] as String,
  userId: json['user_id'] as String,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$HomeModelToJson(HomeModel instance) => <String, dynamic>{
  'home_id': instance.homeId,
  'home_name': instance.homeName,
  'address': instance.address,
  'user_id': instance.userId,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
