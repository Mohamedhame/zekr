import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zekr/controller/notification/notify_helper.dart';
import 'package:zekr/view/azkar.dart';
import 'package:zekr/view/hadith/explain_hadith.dart';
import 'package:zekr/view/home/home_page.dart';
import 'package:zekr/view/settings.dart';

class HomeScreen extends StatefulWidget {
  static const String screenRoute = "HomeScreen";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //=========================
  void _runWhileAppIsTerminated() async {
    var details = await NotifyHelper.flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (details != null && details.didNotificationLaunchApp) {
      Get.offAll(() => HomePage());

      if (details.notificationResponse != null) {
        int? notificationId = details.notificationResponse!.id;

        if (notificationId == 1000 || notificationId == 1002) {
          Get.to(() => Azkar());
        } else if (notificationId == 1003) {
          String? payload = details.notificationResponse!.payload;
          Get.to(() => ExplainHadith(
                title: payload ?? 'عنوان غير معروف',
              ));
        } else if (notificationId == 1006) {
          Get.to(() => Settings());
        }
      }
    }
  }

  //=========================

  @override
  void initState() {
    super.initState();
    _runWhileAppIsTerminated();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //==========================

  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
