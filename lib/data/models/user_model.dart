import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'user_id')
  final String userId;
  final String name;
  final String email;
  final List<String> roles;
  @JsonKey(name: 'is_active')
  final bool isActive;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.roles,
    required this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
