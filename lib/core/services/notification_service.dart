import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'supabase_service.dart';
import 'auth_service.dart';

/// Handles Firebase Cloud Messaging (FCM) and local notifications.
///
/// Manages FCM token registration, message handling, and local notification
/// display via [flutter_local_notifications]. Tokens are stored in Supabase
/// for server-side push delivery.
///
/// Call [init] once at app startup after Firebase initialization.
///
/// Use [instance] for quick access; inject configured instances for tests.
class NotificationService {
  static final NotificationService instance = NotificationService();

  NotificationService({SupabaseService? supabase, AuthService? auth})
    : _supabase = supabase ?? SupabaseService.instance,
      _auth = auth ?? AuthService.instance;

  final SupabaseService _supabase;
  final AuthService _auth;

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  late final FirebaseMessaging _messaging;

  Future<void> init() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {},
    );

    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await _messaging.getToken();
      await _saveToken(token);

      _messaging.onTokenRefresh.listen(_saveToken);

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
    }
  }

  Future<void> _saveToken(String? token) async {
    if (token == null) return;
    try {
      final userId = _auth.userId;
      if (userId.isEmpty) return;
      await _supabase.profiles.upsert({
        'id': userId,
        'fcm_token': token,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('[NotificationService] _saveToken failed: $e');
    }
  }

  Future<void> clearToken() async {
    try {
      final userId = _auth.userId;
      if (userId.isEmpty) return;
      await _supabase.profiles.upsert({
        'id': userId,
        'fcm_token': null,
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('[NotificationService] clearToken failed: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;
    _showLocalNotification(notification);
  }

  @pragma('vm:entry-point')
  static Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    await Firebase.initializeApp();
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'watch_atlas_channel',
      'WatchAtlas',
      channelDescription: 'Notifications from WatchAtlas',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final localNotifications = FlutterLocalNotificationsPlugin();
    await localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
    );
  }

  Future<void> _showLocalNotification(RemoteNotification notification) async {
    const androidDetails = AndroidNotificationDetails(
      'watch_atlas_channel',
      'WatchAtlas',
      channelDescription: 'Notifications from WatchAtlas',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: details,
    );
  }

  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'watch_atlas_channel',
      'WatchAtlas',
      channelDescription: 'Notifications from WatchAtlas',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _localNotifications.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }
}
