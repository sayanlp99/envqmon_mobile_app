class AppConfig {
  // Set to false to disable FCM token registration (useful for debugging)
  static const bool enableFcmRegistration = true;
  
  // Set to true to enable detailed network debugging
  static const bool enableNetworkDebugging = true;
  
  // API timeout duration in seconds
  static const int apiTimeoutSeconds = 30;
  
  // Retry attempts for FCM registration
  static const int fcmRetryAttempts = 3;
  
  // Debug mode - set to true to see more detailed logs
  static const bool debugMode = true;
}
