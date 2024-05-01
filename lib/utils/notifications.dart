import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:prepitpro/helpers/db_init.dart';
import 'package:prepitpro/models/notifications.dart';

class NotificationsManager with ChangeNotifier {
  static final List<NotificationsHistory> _notificationsHistory = [];

  List<NotificationsHistory> get notificationsHistory => _notificationsHistory;

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  static Future<void> initializeNotification(
      {Function(NotificationResponse)?
          onDidReceiveNotificationResponse}) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("app_icon");
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('reminder', 'Reminder for Practice',
            channelDescription: 'A Reminder to Practice',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    return notificationDetails;
  }

  static Future<bool> isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      return granted;
    } else {
      return false;
    }
  }

//Request Permissions
  static Future<bool> requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      final bool? grantedNotificationPermission =
          await _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  MacOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
              );
      return grantedNotificationPermission ?? false;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();

      return grantedNotificationPermission ?? false;
    } else {
      return false;
    }
  }

//Add notification History to DB
  static Future<void> _addNotificationHistory({
    String? title,
    String? body,
    String? name,
    String? image,
    Object? metadata,
  }) async {
    final userId = DBInit.supabase.auth.currentUser?.id;
    final response = await DBInit.supabase
        .from("notifications")
        .upsert({
          "title": title,
          "name": name,
          "metadata": metadata,
          "image": image,
          "body": body
        })
        .eq("user_id", userId!)
        .select();
    final resdata = response[0];
    _notificationsHistory.add(NotificationsHistory(
        metadata: resdata["metadata"],
        body: resdata["body"],
        id: resdata["id"],
        createdAt: DateTime.tryParse(resdata["created_at"]),
        image: resdata["image"],
        name: resdata["name"],
        title: resdata["title"],
        user_id: resdata["user_id"]));
    print(_notificationsHistory);
  }

  static Future<void> triggerNotification({String? title, String? body}) async {
    await NotificationsManager._flutterLocalNotificationsPlugin.show(
        0,
        title ?? 'Practice today',
        body ?? "Open app to continue today's practice",
        await _notificationDetails(),
        payload: '😊');
  }

  static Future<void> periodicNotification(
      {int? id = 1,
      String? channelName,
      String? channelDesc,
      String? title,
      String? body}) async {
    await _flutterLocalNotificationsPlugin.periodicallyShow(id!, title, body,
        RepeatInterval.daily, await NotificationsManager._notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }

  static final _firebaseMessaging = FirebaseMessaging.instance;

  @pragma("vm:entry-point")
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print("Message: ${message.data}");
  }

  static Future<void> firebaseNotificationInit() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print("$fcmToken");
    //TODO send token to server
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
