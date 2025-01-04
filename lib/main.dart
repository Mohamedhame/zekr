import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zekr/controller/database/hadith_database.dart';
import 'package:zekr/controller/database/notes_database.dart';
import 'package:zekr/controller/notification/notify_helper.dart';
import 'package:zekr/controller/notification/work_manager_services.dart';
import 'package:zekr/view/home/splash_screen.dart';
import 'package:zekr/controller/binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const supabaseUrl = 'https://nwwptsboddtvocckydkd.supabase.co';
  const supabaseKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im53d3B0c2JvZGR0dm9jY2t5ZGtkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mjc0NjkyOTAsImV4cCI6MjA0MzA0NTI5MH0.sAB0vJMcCA-eA4CSbBfter3xJJ-XMKmruRC6ZYr1tXM";
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
  await JustAudioBackground.init(
    androidNotificationChannelId: 'come.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await HadithDatabase.initDb();
  await NotesDatabase.initDb();
  await WorkManagerService().init();
  await NotifyHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      locale: Locale('ar'),
      debugShowCheckedModeBanner: false,
      title: 'Zekr',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialBinding: MyBinding(),
      home: SplashScreen(),
    );
  }
}
