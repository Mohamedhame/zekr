import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/widgets/azkar/azkar_button.dart';

class CustomRow extends StatelessWidget {
  CustomRow({super.key});
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AzkarButton(
              title: "أذكار الصباح",
              textColor: controller.textColor.value,
              changeColor: () {
                controller.isMorning.value = true;
                controller.pageCurrent.value = 0;
                controller.pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.ease,
                );
              },
              background: controller.isMorning.value
                  ? controller.widgetColor.value
                  : controller.bgColor.value.withOpacity(0.3),
            ),
            AzkarButton(
              title: "أذكار المساء",
              textColor: controller.textColor.value,
              changeColor: () {
                controller.isMorning.value = false;
                controller.pageCurrent.value = 0;
                controller.pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.ease,
                );
              },
              background: controller.isMorning.value
                  ? controller.bgColor.value.withOpacity(0.3)
                  : controller.widgetColor.value,
            ),
          ],
        ));
  }
}
