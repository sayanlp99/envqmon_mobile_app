// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FcmRegistrationRequest _$FcmRegistrationRequestFromJson(
  Map<String, dynamic> json,
) => FcmRegistrationRequest(
  fcmToken: json['fcmToken'] as String,
  userId: json['userId'] as String,
);

Map<String, dynamic> _$FcmRegistrationRequestToJson(
  FcmRegistrationRequest instance,
) => <String, dynamic>{
  'fcmToken': instance.fcmToken,
  'userId': instance.userId,
};

FcmRegistrationResponse _$FcmRegistrationResponseFromJson(
  Map<String, dynamic> json,
) => FcmRegistrationResponse(message: json['message'] as String);

Map<String, dynamic> _$FcmRegistrationResponseToJson(
  FcmRegistrationResponse instance,
) => <String, dynamic>{'message': instance.message};
