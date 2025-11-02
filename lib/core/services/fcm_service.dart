import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:envqmon/data/repositories/alert_repository.dart';
import 'package:envqmon/core/constants/app_config.dart';

class FcmService {
  final AlertRepository _alertRepository;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  FcmService({required AlertRepository alertRepository}) 
      : _alertRepository = alertRepository;

  Future<String?> getFcmToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  Future<bool> registerFcmToken({
    required String userId,
    required String authToken,
  }) async {
    // Check if FCM registration is enabled
    if (!AppConfig.enableFcmRegistration) {
      print('FCM registration is disabled in app config');
      return false;
    }

    try {
      final fcmToken = await getFcmToken();
      if (fcmToken == null) {
        print('FCM token is null, cannot register');
        return false;
      }

      print('Attempting to register FCM token for user: $userId');
      if (AppConfig.enableNetworkDebugging) {
        print('FCM Token: ${fcmToken.substring(0, 20)}...');
      }
      
      // Retry mechanism
      for (int attempt = 1; attempt <= AppConfig.fcmRetryAttempts; attempt++) {
        try {
          print('FCM registration attempt $attempt of ${AppConfig.fcmRetryAttempts}');
          
          await _alertRepository.registerFcmToken(
            fcmToken: fcmToken,
            userId: userId,
            authToken: authToken,
          );

          print('FCM token registered successfully on attempt $attempt');
          return true;
        } catch (e) {
          print('FCM registration attempt $attempt failed: $e');
          if (attempt == AppConfig.fcmRetryAttempts) {
            rethrow;
          }
          // Wait before retry
          await Future.delayed(Duration(seconds: attempt * 2));
        }
      }
      
      return false;
    } catch (e) {
      print('Error registering FCM token after all attempts: $e');
      // Don't throw the error, just return false to prevent app crashes
      return false;
    }
  }

  Future<void> requestPermission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  void setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground message: ${message.notification?.title}');
      // You can add in-app notification display here
    });

    // Handle app opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened from notification: ${message.notification?.title}');
      // You can add navigation logic here
    });
  }
}
