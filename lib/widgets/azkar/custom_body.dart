import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/azkar/data.dart';
import 'package:zekr/controller/home_controller.dart';

class CustomBody extends StatelessWidget {
  final Data data;
  CustomBody({super.key, required this.data});
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: PageView.builder(
        onPageChanged: (value) {
          controller.pageCurrent.value = value;
          controller.count.value = 0;
          controller.audioPlayer.stop();
          controller.isPlaying.value = false;
        },
        controller: controller.pageController,
        itemCount: data.zekrGrouMsaa.length,
        itemBuilder: (context, index) {
          return Obx(
            () => InkWell(
              onTap: () {
                if (controller.isMorning.value) {
                  if (data.zekrGroup[index].counter > 0 &&
                      controller.count.value < data.zekrGroup[index].counter) {
                    controller.count.value++;
                  } else if (data.zekrGroup[index].counter == 0) {
                    Get.snackbar("", "لا يوجد عدد",
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: controller.textColor.value);
                  } else {
                    Get.snackbar("", "انتهي العد",
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: controller.textColor.value);
                  }
                } else {
                  if (data.zekrGrouMsaa[index].counter > 0 &&
                      controller.count.value <
                          data.zekrGrouMsaa[index].counter) {
                    controller.count.value++;
                  } else if (data.zekrGrouMsaa[index].counter == 0) {
                    Get.snackbar("", "لا يوجد عدد",
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: controller.textColor.value);
                  } else {
                    Get.snackbar("", "انتهي العد",
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: controller.textColor.value);
                  }
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: controller.widgetColor.value,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 3),
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Obx(() => CircularPercentIndicator(
                                    radius: 25,
                                    lineWidth: 3,
                                    percent: controller.isMorning.value
                                        ? data.zekrGroup[index].counter == 0
                                            ? 0.0
                                            : min(
                                                controller.count.value /
                                                    data.zekrGroup[index]
                                                        .counter,
                                                1.0)
                                        : data.zekrGrouMsaa[index].counter == 0
                                            ? 0.0
                                            : min(
                                                controller.count.value /
                                                    data.zekrGrouMsaa[index]
                                                        .counter,
                                                1.0),
                                    center: Text(
                                      controller.count.value.toString(),
                                      style: ourStyle(
                                          size: 16,
                                          color: controller.textColor.value),
                                    ),
                                  )),
                            ),
                            Text(
                              controller.isMorning.value
                                  ? "${index + 1} /"
                                      "${data.zekrGroup.length}"
                                  : "${index + 1} /"
                                      "${data.zekrGrouMsaa.length}",
                              style: ourStyle(
                                  color: controller.textColor.value, size: 20),
                            )
                          ],
                        ),
                      ),
                      Divider(),
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Text(
                              controller.isMorning.value
                                  ? data.zekrGroup[index].azkar
                                  : data.zekrGrouMsaa[index].azkar,
                              // currentZekr.azkar,
                              textAlign: TextAlign.center,
                              style: ourStyle(
                                  size: controller.fontSize.value,
                                  color: controller.textColor.value),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}
