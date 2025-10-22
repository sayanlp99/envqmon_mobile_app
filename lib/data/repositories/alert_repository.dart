import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:envqmon/core/constants/api_endpoints.dart';
import 'package:envqmon/core/constants/app_config.dart';
import 'package:envqmon/core/network/http_client.dart';
import 'package:envqmon/data/models/alert_model.dart';
import 'package:envqmon/data/models/fcm_registration_model.dart';

class AlertRepository {
  final http.Client _client = AppHttpClient.instance;

  Future<FcmRegistrationResponse> registerFcmToken({
    required String fcmToken,
    required String userId,
    required String authToken,
  }) async {
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.registerFcmToken}');
      print('Registering FCM token at URL: $url');
      
      final request = FcmRegistrationRequest(
        fcmToken: fcmToken,
        userId: userId,
      );

      print('Request payload: ${jsonEncode(request.toJson())}');

      final response = await _client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(request.toJson()),
      ).timeout(
        Duration(seconds: AppConfig.apiTimeoutSeconds),
        onTimeout: () {
          throw Exception('Request timeout - check your internet connection');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return FcmRegistrationResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to register FCM token: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Detailed error in registerFcmToken: $e');
      throw Exception('Error registering FCM token: $e');
    }
  }

  Future<List<AlertModel>> getAlerts({
    required String authToken,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.getAlerts}?page=$page&limit=$limit');
      
      final response = await _client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((json) => AlertModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch alerts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching alerts: $e');
    }
  }
}
