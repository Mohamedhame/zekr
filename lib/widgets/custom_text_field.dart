import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zekr/const/const.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/home_controller.dart';

class CustomTextField extends StatelessWidget {
  final Function onChange;
  final String searchText;
  CustomTextField(
      {super.key, required this.onChange, required this.searchText});
  final HomeController controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: controller.widgetColor.value,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.search,
                color: textColor,
              ),
              Expanded(
                child: TextFormField(
                  onChanged: (value) {
                    onChange(value);
                  },
                  textAlign: TextAlign.center,
                  style: ourStyle(size: 20, color: controller.textColor.value),
                  decoration: InputDecoration(
                    hintText: searchText,
                    hintStyle: TextStyle(
                      color: controller.textColor.value,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
