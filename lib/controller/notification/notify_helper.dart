import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:zekr/controller/database/hadith_database.dart';
import 'package:zekr/view/azkar.dart';
import 'package:zekr/view/hadith/explain_hadith.dart';

@pragma('vm:entry-point')
void onTap(NotificationResponse notificationResponse) async {
  if (notificationResponse.id == 1000 || notificationResponse.id == 1002) {
    Get.to(() => Azkar());
  }
  if (notificationResponse.id == 1003) {
    Get.to(() => ExplainHadith(title: notificationResponse.payload!));
  }
}

class NotifyHelper {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static StreamController<NotificationResponse> streamController =
      StreamController();

  // ================================
  static Future<void> init() async {
    try {
      tz.initializeTimeZones();

      const InitializationSettings settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );

      await flutterLocalNotificationsPlugin.initialize(settings,
          onDidReceiveNotificationResponse: onTap,
          onDidReceiveBackgroundNotificationResponse: onTap);

      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'zekr_channel',
        'zekr',
        description: 'Channel for zekr Notifications',
        importance: Importance.high,
        playSound: true,
        showBadge: true,
      );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await requestNotificationPermission();

      bool isPermission = await requestExactAlarmPermission();
      if (isPermission) {
        print("Exact alarm permission granted.");
      } else {
        print("Exact alarm permission denied.");
      }
    } catch (e) {
      debugPrint("Error initializing notifications: $e");
    }
  }

  // ================================
  static Future<void> requestNotificationPermission() async {
    final isNotificationsEnabled = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;

    if (!isNotificationsEnabled) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    if (await Permission.notification.isDenied) {
      final status = await Permission.notification.request();
      if (status.isDenied) {
        print("Notification permission denied by user.");
      } else if (status.isGranted) {
        print("Notification permission granted.");
      }
    }
  }

  //==========================
  static Future<bool> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;

      if (build.version.sdkInt >= 30) {
        var status = await Permission.scheduleExactAlarm.request();
        return status.isGranted;
      }
    }
    var status = await Permission.scheduleExactAlarm.status;
    if (!status.isGranted) {
      status = await Permission.scheduleExactAlarm.request();
    }
    return status.isGranted;
  }

  // ================================
  static Future<void> showDailyScheduledNotification() async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        "id_1",
        "Daily Scheduled Notification",
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound("azkar"),
      );

      NotificationDetails details =
          const NotificationDetails(android: androidDetails);
      tz.initializeTimeZones();
      final String currentLocation = await FlutterTimezone.getLocalTimezone();
      log(currentLocation);
      tz.setLocalLocation(tz.getLocation(currentLocation));
      //================================================
      var currentTime = tz.TZDateTime.now(tz.local);
      var scheduleTime = tz.TZDateTime(tz.local, currentTime.year,
          currentTime.month, currentTime.day, 08, 0);
      //=====================================================
      if (scheduleTime.isBefore(currentTime)) {
        scheduleTime = scheduleTime.add(const Duration(days: 1));
      }
      //===================================================
      await flutterLocalNotificationsPlugin.zonedSchedule(
        1000,
        "أذكار الصباح",
        "أذكار الصباح",
        scheduleTime,
        details,
        payload: "Nightly Scheduled Notification",
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e, stackTrace) {
      debugPrint("Error scheduling nightly notification: $e");
      debugPrint("Stack trace: $stackTrace");
    }
  }

  // ================================
  static Future<void> showNightlyScheduledNotification() async {
    try {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        "id_2",
        "Nightly Scheduled Notification",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        styleInformation: DefaultStyleInformation(true, true),
        sound: RawResourceAndroidNotificationSound("msaa"),
      );

      NotificationDetails details =
          const NotificationDetails(android: androidDetails);
      tz.initializeTimeZones();
      final String currentLocation = await FlutterTimezone.getLocalTimezone();
      log(currentLocation);
      tz.setLocalLocation(tz.getLocation(currentLocation));
      //================================================
      var currentTime = tz.TZDateTime.now(tz.local);
      var scheduleTime = tz.TZDateTime(tz.local, currentTime.year,
          currentTime.month, currentTime.day, 17, 0);
      //=====================================================
      if (scheduleTime.isBefore(currentTime)) {
        scheduleTime = scheduleTime.add(const Duration(days: 1));
      }
      //===================================================
      await flutterLocalNotificationsPlugin.zonedSchedule(
        1002,
        "أذكار المساء",
        "أذكار المساء",
        scheduleTime,
        details,
        payload: "Nightly Scheduled Notification",
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (e, stackTrace) {
      debugPrint("Error scheduling nightly notification: $e");
      debugPrint("Stack trace: $stackTrace");
    }
  }

  //==================== Hadith ===========================
  static Future<void> showHadithNotification() async {
    try {
      List hadith = [];
      for (var element in await HadithDatabase.getHadith()) {
        hadith.add({
          "title": element['title'],
          "nuse": element['nuse'],
        });
      }

      if (hadith.isEmpty) {
        debugPrint("قائمة الأحاديث فارغة، لا يمكن عرض الإشعار.");
        return;
      }

      hadith.shuffle();
      String nuseText = hadith[0]['nuse'].toString();
      String titleText = hadith[0]['title'].toString();

      final AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        "id_3",
        "Basic Notification",
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('song'),
        styleInformation: BigTextStyleInformation(
          nuseText,
          contentTitle: titleText,
          summaryText: titleText,
        ),
      );

      final NotificationDetails details =
          NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        1003,
        titleText,
        nuseText,
        details,
        payload: titleText,
      );
    } catch (e, stackTrace) {
      debugPrint("Error showing hadith notification: $e");
      debugPrint("Stack trace: $stackTrace");
    }
  }

  // ================================
  static Future<void> cancelNotification(int id) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(id);
    } catch (e) {
      debugPrint("Error canceling notification: $e");
    }
  }

  //==========================
  static Future<void> scheduleNotificationDetails(
      int id, String title, String category, DateTime scheduledTime) async {
    const androidDetails = AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    final notificationDetails = NotificationDetails(android: androidDetails);
    if (scheduledTime.isBefore(DateTime.now())) {
    } else {
      await flutterLocalNotificationsPlugin.zonedSchedule(id, title, category,
          tz.TZDateTime.from(scheduledTime, tz.local), notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
    }
  }

  //=====================================
}
