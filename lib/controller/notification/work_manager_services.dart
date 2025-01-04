import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:zekr/const/const.dart';
import 'package:zekr/controller/database/hadith_database.dart';
import 'package:zekr/controller/notification/notify_helper.dart';
import 'package:zekr/controller/shared/shared_data.dart';

class WorkManagerService {
  Future<int> getRemember() async {
    try {
      int remember = await SharedData.getRemember(remeber);
      return remember;
    } catch (e) {
      return 15;
    }
  }

  Future<void> init() async {
    try {
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
      log("WorkManager initialized successfully");

      await registerHadithNotificationTask();
      await registerDailyTask();
      await registerNightlyTask();
    } catch (e) {
      log("Error initializing WorkManager: $e");
    }
  }

  //========================Hadith Task=====================
  Future<void> registerHadithNotificationTask() async {
    try {
      int remember = await getRemember();
      await Workmanager().registerPeriodicTask(
        "hadith",
        "hadith",
        frequency: Duration(minutes: remember),
      );
      log("Hadith notification task registered successfully.");
    } catch (e) {
      log("Error registering Hadith notification task: $e");
    }
  }

  //========================Daily Task======================
  Future<void> registerDailyTask() async {
    try {
      await Workmanager().registerPeriodicTask(
        "daily",
        "daily",
        frequency: const Duration(hours: 12),
      );
      log("Daily task registered successfully.");
    } catch (e) {
      log("Error registering Daily task: $e");
    }
  }

  //========================Nightly Task====================
  Future<void> registerNightlyTask() async {
    try {
      await Workmanager().registerPeriodicTask(
        "nightly",
        "nightly",
        frequency: const Duration(hours: 12),
      );
      log("Nightly task registered successfully.");
    } catch (e) {
      log("Error registering Nightly task: $e");
    }
  }

  //========================Cancel Task=====================
  Future<void> cancelTask(String id) async {
    try {
      await Workmanager().cancelByUniqueName(id);
      log("Task cancelled: $id");
    } catch (e) {
      log("Error cancelling task: $e");
    }
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await HadithDatabase.initDb();

    try {
      switch (task) {
        case "hadith":
          bool shouldRun = await isRun();
          print("$shouldRun=============");
          if (shouldRun != false) {
            log("Executing Hadith notification task...");
            await NotifyHelper.showHadithNotification();
          }
          break;

        case "daily":
          log("Executing Daily notification task...");
          await NotifyHelper.showDailyScheduledNotification();
          break;

        case "nightly":
          log("Executing Nightly notification task...");
          await NotifyHelper.showNightlyScheduledNotification();
          break;

        default:
          log("Unknown task: $task");
      }
    } catch (e) {
      log("Error executing task $task: $e");
    }

    return Future.value(true);
  });
}

Future<bool> isRun() async {
  try {
    bool mode = await SharedData.getReminder(reminder);
    return mode;
  } catch (e) {
    log("Error fetching reminder mode: $e");
    return false;
  }
}
