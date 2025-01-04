import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:zekr/controller/home_controller.dart';

import '../const/text_style.dart';

class CustomPage extends StatelessWidget {
  final String text;
  final Function onTap;
  final TextStyle? style;
  final Widget? icon;
  CustomPage(
      {super.key,
      required this.text,
      required this.onTap,
      this.style,
      this.icon});
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: controller.widgetColor.value,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: icon == null
              ? MainAxisAlignment.center
              : MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                text,
                style: style ??
                    ourStyle(
                        size: 28,
                        fontWeight: FontWeight.bold,
                        color: controller.textColor.value),
              ),
            ),
            icon ?? Container(),
          ],
        ),
      ),
    );
  }
}
