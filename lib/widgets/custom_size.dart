import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/home_controller.dart';

class CustomSize extends StatelessWidget {
  final Function onPressed;
  CustomSize({super.key, required this.onPressed});

  final HomeController controller = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: controller.widgetColor.value,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
              alignment: Alignment.topLeft,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: controller.widgetColor.value),
              child: IconButton(
                onPressed: () {
                  onPressed();
                },
                icon: CircleAvatar(
                  backgroundColor: controller.textColor.value,
                  child: Icon(
                    Icons.close,
                    color: controller.widgetColor.value,
                  ),
                ),
              )),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Obx(() => Text(
                  controller.fontSize.value.toStringAsFixed(2),
                  style: ourStyle(size: 22, color: controller.textColor.value),
                )),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (controller.fontSize.value > 10) {
                    controller.fontSize.value--;
                  }
                },
                icon: CircleAvatar(
                  backgroundColor: controller.textColor.value,
                  child: Icon(
                    Icons.remove,
                    color: controller.widgetColor.value,
                  ),
                ),
              ),
              //

              Expanded(
                child: Obx(
                  () => Slider(
                    min: 8,
                    max: 71,
                    value: controller.fontSize.value,
                    onChanged: (value) {
                      controller.fontSize.value = value;
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (controller.fontSize.value < 70) {
                    controller.fontSize.value++;
                  }
                },
                icon: CircleAvatar(
                  backgroundColor: controller.textColor.value,
                  child: Icon(
                    Icons.add,
                    color: controller.widgetColor.value,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
