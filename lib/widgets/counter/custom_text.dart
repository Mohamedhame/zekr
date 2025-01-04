import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/home_controller.dart';

class CustomText extends StatelessWidget {
  CustomText({super.key});
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(()=> CircularPercentIndicator(
      radius: 140,
      lineWidth: 7,
      percent: controller.counter.value /
          controller.total.value,
      progressColor: Colors.deepPurple,
      backgroundColor: Colors.deepPurple.shade100,
      circularStrokeCap: CircularStrokeCap.round,
      center: Text(
        controller.counter.value.toString(),
        style: ourStyle(color: controller.textColor.value,size: 50),
      ),
    ));
  }
}
