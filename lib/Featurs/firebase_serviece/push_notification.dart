// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/Featurs/splash/view/splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';

class FirebaseViewModel extends ChangeNotifier {
  FirebaseMessaging? _messaging;
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String firebasetoken = '';
  String get fcmtoken => firebasetoken;
  set setfcmtoken(String token) {
    firebasetoken = token;
    notifyListeners();
  }

  // Save FCM token to Firestore for the current user
  Future<void> saveFCMTokenToFirestore(String userId, String token) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
        'platform': Platform.isAndroid ? 'android' : 'ios',
      });
      log('FCM token saved to Firestore for user: $userId');
    } catch (e) {
      log('Error saving FCM token to Firestore: $e');
    }
  }

  registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging!.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );
    String? token;
    try {
      if (Platform.isAndroid) {
        token = await FirebaseMessaging.instance.getToken();
      } else {
        token = await FirebaseMessaging.instance.getAPNSToken();
      }

      setfcmtoken = token ?? '';
      log('FCM Token: $fcmtoken');

      // Save token to Firestore (you need to pass the userId from your auth system)
      // Uncomment and modify this when you have the userId available
      // final prefs = await SharedPreferences.getInstance();
      // String? userId = prefs.getString('userId');
      // if (userId != null && token != null) {
      //   await saveFCMTokenToFirestore(userId, token);
      // }

      // Listen for token refresh
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        setfcmtoken = newToken;
        log('FCM Token refreshed: $newToken');
        // Update token in Firestore when refreshed
        // if (userId != null) {
        //   saveFCMTokenToFirestore(userId, newToken);
        // }
      });
    } catch (e) {
      log('error fcm $e');
    }

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      var initiizationSettingsAndroid = const AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      var iosInit = const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      var initializationSettings = InitializationSettings(
        android: initiizationSettingsAndroid,
        iOS: iosInit,
      );

      flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
              switch (notificationResponse.notificationResponseType) {
                case NotificationResponseType.selectedNotification:
                  selectNotification(notificationResponse.payload ?? '');
                  break;
                case NotificationResponseType.selectedNotificationAction:
                  break;
              }
            },
      );

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification? notification = message.notification;
        var data = message.data;

        if (notification != null) {
          flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
                attachments: notification.apple?.imageUrl != null
                    ? [
                        DarwinNotificationAttachment(
                          notification.apple!.imageUrl!,
                        ),
                      ]
                    : null,
              ),
              android: AndroidNotificationDetails(
                '1',
                'pushnotification',
                channelDescription: 'Keyroute',
                color: Colors.white,
                colorized: true,
                priority: Priority.max,
                channelShowBadge: true,
                importance: Importance.high,
                playSound: true,
                styleInformation: notification.android?.imageUrl != null
                    ? BigPictureStyleInformation(
                        FilePathAndroidBitmap(notification.android!.imageUrl!),
                        contentTitle: notification.title,
                        summaryText: notification.body,
                      )
                    : null,
              ),
            ),
            payload: jsonEncode(data),
          );
        }
      });

      // Handle notification tap when app is in background/terminated
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        log('Notification tapped: ${message.data}');
        selectNotification(jsonEncode(message.data));
      });

      // Check if app was opened from a notification when terminated
      RemoteMessage? initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (initialMessage != null) {
        log('App opened from notification: ${initialMessage.data}');
        selectNotification(jsonEncode(initialMessage.data));
      }
    }
  }

  listenToNotification() =>
      onNotificationClick.stream.listen(onNotificationListener);

  onNotificationListener(String? payload) async {
    if (payload != null && payload.isNotEmpty) {
      try {
        final data = jsonDecode(payload);
        // Handle notification tap based on data
        // You can navigate to specific screens based on notification type

        navigatorKey.currentState!.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const SplashScreen()),
          (route) => false,
        );
      } catch (e) {
        log('Error parsing notification payload: $e');
      }
    }
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {}

  void selectNotification(String? payload) {
    if (payload != null) {
      onNotificationClick.add(payload);
    }
  }

  // Delete FCM token from Firestore on logout
  Future<void> deleteFCMToken(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': FieldValue.delete(),
      });

      // Also delete token from FCM
      await FirebaseMessaging.instance.deleteToken();

      log('FCM token deleted for user: $userId');
    } catch (e) {
      log('Error deleting FCM token: $e');
    }
  }
}

class PushData {
  String? id;
  String? action;

  PushData({this.id, this.action});
}
