import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/widgets/remember/remember.dart';

class Settings extends StatelessWidget {
  Settings({super.key});
  final HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.bgColor.value,
        appBar: AppBar(
          backgroundColor: controller.widgetColor.value,
          foregroundColor: controller.textColor.value,
          centerTitle: true,
          title: Text(
            "حول التطبيق",
            style: ourStyle(
                size: 22,
                color: controller.textColor.value,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                customContainer(
                    title: "القران الكريم ",
                    content:
                        "يضم التطبيق عدد من القراء المشهورين \nيمكنك تحميل السوره التي تريد والاستماع اليها في حالة عدم الاتصال بالشبكة"),
                customContainer(
                    title: "الحديث النبوي الشريف",
                    content:
                        "من كتاب الاربعين النووية للإمام النووي وشرح الشيخ ابن عثيمين \nرحمها الله تعالي"),
                customContainer(
                    title: "أذكار الصباح والمساء",
                    content:
                        "من كتاب حصن المسلم والتلاوة الصوتية في اغلبها للشيخ مشاري العفاسي"),
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: controller.widgetColor.value,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: controller.textColor.value)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        "التذكير بالصلاة علي النبي",
                        style: ourStyle(
                            size: 22, color: controller.textColor.value),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: controller.bgColor.value,
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: controller.textColor.value)),
                        child: TextButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Color(0xff30314d),
                                builder: (BuildContext context) {
                                  return Remember(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            },
                            child: Text(
                                controller.reminig.value ? "تعديل" : "تشغيل")),
                      ),
                    ],
                  ),
                ),
                customContainer(title: "", content: "لا تنسانا من صالح دُعائك"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customContainer(
      {Widget? widget, String? title, required String content}) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: controller.widgetColor.value,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: controller.textColor.value)),
      child: Column(
        children: [
          title!.isNotEmpty
              ? Text(
                  title,
                  style: ourStyle(
                      color: controller.textColor.value,
                      size: 22,
                      fontWeight: FontWeight.bold),
                )
              : SizedBox(),
          title.isNotEmpty ? Divider() : SizedBox(),
          Text(
              textAlign: TextAlign.center,
              content,
              style: ourStyle(
                color: controller.textColor.value,
                size: 22,
              )),
          widget != null ? Divider() : SizedBox(),
          widget ?? SizedBox(),
        ],
      ),
    );
  }
}
/*
TextButton(
                          onPressed: () async {
                            bool isTrue = await isRun();
                            if (isTrue) {
                              controller.reminig.value = false;
                              WorkManagerService().cancelTask("hadith");
                            } else {
                              controller.reminig.value = true;
                              WorkManagerService().init();
                            }
                            await SharedData.saveData(
                                reminder, controller.reminig.value);
                          },
                          child: Text(
                            controller.reminig.value ? "إيقاف" : "تشغيل",
                            style: ourStyle(color: controller.textColor.value),
                          ),
                        )
*/
