class ApiEndpoints {
  static const String baseUrl = 'https://api.envqmon.sayan.fit/api';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String homes = '/homes';
  static const String homeById = '/homes/:home_id';
  static const String rooms = '/rooms';
  static const String devices = '/devices';
  static const String latestData = '/data/latest/:device_id';
  static const String rangeData = '/data/range/:device_id';

  static String getHomeById(String homeId) => '/homes/$homeId';
  static String getLatestData(String deviceId) => '/data/latest/$deviceId';
  static String getRangeData(String deviceId) => '/data/range/$deviceId';
}
