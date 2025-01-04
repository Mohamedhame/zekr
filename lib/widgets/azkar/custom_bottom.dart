import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zekr/controller/azkar/data.dart';
import 'package:zekr/controller/home_controller.dart';

class CustomBottom extends StatelessWidget {
  CustomBottom({super.key});
  final HomeController controller = Get.find<HomeController>();
  final Data data = Data();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: controller.widgetColor.value,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              if (controller.pageCurrent.value > 0) {
                controller.previousPage();
                controller.audioPlayer.stop(); // أوقف الصوت عند تغيير الصفحة
                controller.isPlaying.value = false;
              }
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: controller.textColor.value,
            ),
          ),
          //=============
          IconButton(
            onPressed: () {
              controller.isPlaying.value = !controller.isPlaying.value;
              final String? audioPath = controller.isMorning.value
                  ? data.zekrGroup[controller.pageCurrent.value].audio
                  : data.zekrGrouMsaa[controller.pageCurrent.value].audio;

              // // إذا كان هناك ملف صوتي صالح
              if (audioPath != null) {
                controller.togglePlay(controller.isPlaying.value, audioPath);
              }
            },
            icon: Obx(() => Icon(
                  controller.isPlaying.value ? Icons.pause : Icons.play_arrow,
                  color: controller.textColor.value,
                )),
          ),
          //=============

          IconButton(
            onPressed: () {
              if (controller.pageCurrent.value < data.zekrGroup.length - 1) {
                controller.nextPage();
                controller.audioPlayer.stop();
                controller.isPlaying.value = false;
              }
            },
            icon: Icon(
              Icons.arrow_forward_ios,
              color: controller.textColor.value,
            ),
          ),
        ],
      ),
    );
  }
}
