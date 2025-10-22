import 'package:json_annotation/json_annotation.dart';

part 'fcm_registration_model.g.dart';

@JsonSerializable()
class FcmRegistrationRequest {
  final String fcmToken;
  final String userId;

  const FcmRegistrationRequest({
    required this.fcmToken,
    required this.userId,
  });

  factory FcmRegistrationRequest.fromJson(Map<String, dynamic> json) => 
      _$FcmRegistrationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$FcmRegistrationRequestToJson(this);
}

@JsonSerializable()
class FcmRegistrationResponse {
  final String message;

  const FcmRegistrationResponse({
    required this.message,
  });

  factory FcmRegistrationResponse.fromJson(Map<String, dynamic> json) => 
      _$FcmRegistrationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$FcmRegistrationResponseToJson(this);
}
