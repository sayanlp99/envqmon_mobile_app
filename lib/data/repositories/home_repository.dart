import 'dart:convert';
import 'package:envqmon/core/constants/api_endpoints.dart';
import 'package:envqmon/core/network/http_client.dart';
import 'package:envqmon/data/models/home_model.dart';

class HomeRepository {
  Future<HomeModel> createHome({
    required String name,
    required String address,
    required String userId,
    required String token,
  }) async {
    final response = await AppHttpClient.instance.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.homes}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'home_name': name,
        'address': address,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return HomeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create home: ${response.reasonPhrase}');
    }
  }

  Future<List<HomeModel>> getHomes(String token) async {
    final response = await AppHttpClient.instance.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.homes}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => HomeModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get homes: ${response.reasonPhrase}');
    }
  }

  Future<HomeModel> getHomeById(String homeId, String token) async {
    final response = await AppHttpClient.instance.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.getHomeById(homeId)}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return HomeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get home: ${response.reasonPhrase}');
    }
  }
}
