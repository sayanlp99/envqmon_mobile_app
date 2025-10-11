import 'dart:convert';
import 'package:envqmon/core/constants/api_endpoints.dart';
import 'package:envqmon/core/network/http_client.dart';
import 'package:envqmon/data/models/device_model.dart';
import 'package:envqmon/data/models/sensor_data_model.dart';

class DeviceRepository {
  Future<DeviceModel> createDevice({
    required String name,
    required String imei,
    required String userId,
    required String token,
  }) async {
    final response = await AppHttpClient.instance.post(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.devices}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'device_name': name,
        'device_imei': imei,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return DeviceModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create device: ${response.reasonPhrase}');
    }
  }

  Future<List<DeviceModel>> getDevices(String token) async {
    final response = await AppHttpClient.instance.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.devices}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => DeviceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get devices: ${response.reasonPhrase}');
    }
  }

  Future<SensorDataModel> getLatestData(String deviceId, String token) async {
    final response = await AppHttpClient.instance.get(
      Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.getLatestData(deviceId)}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return SensorDataModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get latest data: ${response.reasonPhrase}');
    }
  }

  Future<List<SensorDataModel>> getRangeData({
    required String deviceId,
    required DateTime startTime,
    required DateTime endTime,
    required String token,
  }) async {
    final response = await AppHttpClient.instance.get(
      Uri.parse('${ApiEndpoints.baseUrl}/data/$deviceId?start=${startTime.millisecondsSinceEpoch ~/ 1000}&end=${endTime.millisecondsSinceEpoch ~/ 1000}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => SensorDataModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get range data: ${response.reasonPhrase}');
    }
  }
}
