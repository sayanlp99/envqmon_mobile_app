import 'package:http/http.dart' as http;

class AppHttpClient {
  static final http.Client _client = http.Client();

  static http.Client get instance => _client;
}
