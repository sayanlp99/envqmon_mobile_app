// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  userId: json['user_id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'user_id': instance.userId,
  'name': instance.name,
  'email': instance.email,
  'is_active': instance.isActive,
};
