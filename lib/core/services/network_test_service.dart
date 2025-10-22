import 'package:http/http.dart' as http;
import 'package:envqmon/core/constants/api_endpoints.dart';

class NetworkTestService {
  static final http.Client _client = http.Client();

  static Future<bool> testApiConnectivity() async {
    try {
      print('Testing API connectivity...');
      final url = Uri.parse('${ApiEndpoints.baseUrl}/health');
      
      final response = await _client.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );
      
      print('API connectivity test - Status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('API connectivity test failed: $e');
      return false;
    }
  }

  static Future<bool> testBasicConnectivity() async {
    try {
      print('Testing basic internet connectivity...');
      final response = await _client.get(
        Uri.parse('https://www.google.com'),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Connection timeout');
        },
      );
      
      print('Basic connectivity test - Status: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Basic connectivity test failed: $e');
      return false;
    }
  }

  static Future<void> runConnectivityTests() async {
    print('=== Network Connectivity Tests ===');
    
    final basicConnectivity = await testBasicConnectivity();
    print('Basic internet connectivity: ${basicConnectivity ? "✅ PASS" : "❌ FAIL"}');
    
    final apiConnectivity = await testApiConnectivity();
    print('API connectivity: ${apiConnectivity ? "✅ PASS" : "❌ FAIL"}');
    
    print('=== End Network Tests ===');
  }
}
