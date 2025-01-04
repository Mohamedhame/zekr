import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/azkar/get_days_arbic.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/widgets/azkar/custom_text_style.dart';

class CustomDate extends StatelessWidget {
  CustomDate({super.key});
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextStyle(
            title: DateFormat.yMd().format(DateTime.now()),
            background: controller.widgetColor.value,
            style: ourStyle(size: 20, color: controller.textColor.value),
            padd: 15,
          ),
          CustomTextStyle(
            title: getDayWithArbic(),
            background: controller.widgetColor.value,
            style: ourStyle(size: 25, color: controller.textColor.value),
            padd: 8,
          ),
          CustomTextStyle(
            title: jHijri.toString(),
            background: controller.widgetColor.value,
            style: ourStyle(size: 20, color: controller.textColor.value),
            padd: 15,
          ),
        ],
      ),
    );
  }
}
