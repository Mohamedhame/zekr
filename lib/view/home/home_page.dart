import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/controller/onlin_data/supabas_data.dart';
import 'package:zekr/view/azkar.dart';
import 'package:zekr/view/counter.dart';
import 'package:zekr/view/hadith/hadith.dart';
import 'package:zekr/view/quran/audio_play.dart';
import 'package:zekr/view/task/notes.dart';
import 'package:zekr/view/quran/quraa.dart';
import 'package:zekr/view/settings.dart';
import 'package:zekr/widgets/custom_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final HomeController controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    if (controller.isConnective.value) {
      SupabasData().insertHadithToDatabase();
    }
    return Obx(() => Scaffold(
          backgroundColor: controller.bgColor.value,
          body: SafeArea(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10, left: 10),
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      onPressed: () {
                        controller.changeThem();
                      },
                      icon: controller.isDark.value
                          ? const Icon(
                              Icons.light_mode,
                              color: Colors.white,
                            )
                          : const Icon(
                              Icons.dark_mode,
                              color: Colors.black,
                            )),
                ),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(width: double.infinity),
                          CustomPage(
                              text: "قران كريم ",
                              onTap: () {
                                if (controller.audioPlayer.playing) {
                                  Get.to(() => AudioPlay());
                                } else {
                                  Get.offAll(() => Quraa());
                                }
                              }),
                          CustomPage(
                              text: "حديث شريف",
                              onTap: () {
                                Get.to(() => Hadith());
                              }),
                          CustomPage(
                              text: "أذكار الصباح والمساء",
                              onTap: () {
                                Get.to(() => Azkar());
                              }),
                          CustomPage(
                              text: "السبحة",
                              onTap: () {
                                Get.to(() => Counter());
                              }),
                          CustomPage(
                              text: "ملاحظات",
                              onTap: () {
                                Get.to(() => Notes());
                              }),
                          CustomPage(
                              text: "حول التطبيق",
                              onTap: () {
                                Get.to(() => Settings());
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
