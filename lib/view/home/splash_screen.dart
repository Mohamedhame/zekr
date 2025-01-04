import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:zekr/const/const.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/controller/shared/shared_data.dart';
import 'package:zekr/view/home/start.dart';

class SplashScreen extends StatefulWidget {
  static const String screenRoute = "SplashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  HomeController controller = Get.find<HomeController>();
  //=====
  void checkColor() async {
    bool mode = await SharedData.getData(modeTheme);
    if (!mode) {
      controller.isDark.value = false;
      controller.bgColor.value = Color(0xffffffff);
      controller.textColor.value = Color(0xff303151);
      controller.widgetColor.value = Color(0xfff9f1e4);
    }
  }

  //========================================
  @override
  void initState() {
    super.initState();
    checkColor();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAll(() => HomeScreen());
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    super.dispose();
  }

  //================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(color: Color(0xff1F212c)),
              child: Image.asset(
                "images/athkarLogo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          const Text("Designed by Mohamed Hamed")
        ],
      ),
    );
  }
}
