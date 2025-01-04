import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/widgets/counter/custom_text.dart';

class CustomCounter extends StatelessWidget {
  CustomCounter({super.key});
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: controller.widgetColor.value,
            border: Border.all(color: controller.textColor.value),
            borderRadius: BorderRadius.circular(12)),
        height: MediaQuery.of(context).size.height * 0.60,
        width: MediaQuery.of(context).size.width / 1.05,
        child: Center(
          child: SingleChildScrollView(
            child: CustomText(),
          ),
        ));
  }
}
