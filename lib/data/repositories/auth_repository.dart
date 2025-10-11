import 'dart:convert';
import 'package:envqmon/core/constants/api_endpoints.dart';
import 'package:envqmon/core/network/http_client.dart';
import 'package:envqmon/data/models/auth_response_model.dart';
import 'package:envqmon/data/models/user_model.dart';

class AuthRepository {
  Future<AuthResponseModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await AppHttpClient.instance.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.register}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return AuthResponseModel.fromJson(responseData);
    } else {
      throw Exception('Registration failed: ${response.reasonPhrase}');
    }
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await AppHttpClient.instance.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.login}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return AuthResponseModel.fromJson(responseData);
    } else {
      throw Exception('Login failed: ${response.reasonPhrase}');
    }
  }

  Future<UserModel> getUserProfile(String token) async {
    final response = await AppHttpClient.instance.get(
      Uri.parse('${ApiEndpoints.baseUrl}/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user profile: ${response.reasonPhrase}');
    }
  }
}
