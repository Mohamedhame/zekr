import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zekr/const/style_decoration.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/home_controller.dart';

class CustomSpeed extends StatelessWidget {
  final Function onPressed;
  CustomSpeed({super.key, required this.onPressed});
  final List<double> rangeOfSpeed = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0];
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: styleDecoration(l: 12, r: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
              alignment: Alignment.center,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: IconButton(
                  onPressed: () {
                    onPressed();
                  },
                  icon: const Icon(Icons.close))),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Obx(() => Text(
                  "${controller.playbackRate.value.toStringAsFixed(2)} X",
                  style: ourStyle(size: 22),
                )),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  if (controller.playbackRate.value > 0.6) {
                    controller.playbackRate.value =
                        controller.playbackRate.value - 0.05;
                    controller.audioPlayer
                        .setSpeed(controller.playbackRate.value);
                  }
                },
                icon: const CircleAvatar(
                  backgroundColor: Color(0xff303030),
                  child: Icon(Icons.remove),
                ),
              ),
              //

              Expanded(
                child: Obx(
                  () => Slider(
                    min: 0.5,
                    max: 2.05,
                    value: controller.playbackRate.value,
                    onChanged: (value) {
                      controller.playbackRate.value = value;
                      controller.audioPlayer
                          .setSpeed(controller.playbackRate.value);
                    },
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (controller.playbackRate.value < 2) {
                    controller.playbackRate.value =
                        controller.playbackRate.value + 0.05;
                    controller.audioPlayer
                        .setSpeed(controller.playbackRate.value);
                  }
                },
                icon: const CircleAvatar(
                  backgroundColor: Color(0xff303030),
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                rangeOfSpeed.length,
                (index) {
                  return InkWell(
                    onTap: () {
                      controller.playbackRate.value = rangeOfSpeed[index];
                      controller.audioPlayer
                          .setSpeed(controller.playbackRate.value);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "${rangeOfSpeed[index]}",
                        style: ourStyle(size: 20),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
