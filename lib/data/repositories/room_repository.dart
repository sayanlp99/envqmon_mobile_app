import 'dart:convert';
import 'package:envqmon/core/constants/api_endpoints.dart';
import 'package:envqmon/core/network/http_client.dart';
import 'package:envqmon/data/models/room_model.dart';

class RoomRepository {
  Future<RoomModel> createRoom({
    required String name,
    required String homeId,
    required String userId,
    required String token,
  }) async {
    final response = await AppHttpClient.instance.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.rooms}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'home_id': homeId,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return RoomModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create room: ${response.reasonPhrase}');
    }
  }

  Future<List<RoomModel>> getRooms(String token) async {
    final response = await AppHttpClient.instance.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.rooms}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => RoomModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get rooms: ${response.reasonPhrase}');
    }
  }
}
