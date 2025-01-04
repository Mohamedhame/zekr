import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zekr/const/const.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/controller/notification/work_manager_services.dart';
import 'package:zekr/controller/shared/shared_data.dart';

class Remember extends StatelessWidget {
  final Function onPressed;
  Remember({super.key, required this.onPressed});
  final HomeController controller = Get.find<HomeController>();
  final List<int> timeRemember = [15, 30, 45, 59];
  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Obx(() => Text("${controller.timeRemember.value}"))),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: controller.bgColor.value,
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.infinity,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  timeRemember.length,
                  (index) {
                    return InkWell(
                      onTap: () async {
                        controller.reminig.value = false;
                        WorkManagerService().cancelTask("hadith");
                        await SharedData.saveData(
                            reminder, controller.reminig.value);
                        controller.timeRemember.value = timeRemember[index];
                        await SharedData.setRemeber(
                            remeber, controller.timeRemember.value);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          child: Text(
                            "${timeRemember[index]}",
                            style: ourStyle(
                                size: 20, color: controller.textColor.value),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            alignment: Alignment.center,
            child: MaterialButton(
              onPressed: () async {
                bool isTrue = await isRun();
                if (isTrue) {
                  controller.reminig.value = false;
                  WorkManagerService().cancelTask("hadith");
                } else {
                  controller.reminig.value = true;
                  WorkManagerService().init();
                }
                await SharedData.saveData(reminder, controller.reminig.value);
                onPressed();
              },
              child:
                  Obx(() => Text(controller.reminig.value ? "إيقاف" : "تشغيل")),
            ),
          )
        ],
      ),
    );
  }

  Future<bool> isRun() async {
    bool mode = await SharedData.getReminder(reminder);
    return mode;
  }
}
