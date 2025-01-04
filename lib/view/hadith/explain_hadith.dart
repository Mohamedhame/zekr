import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/database/hadith_database.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/view/hadith/hadith.dart';
import 'package:zekr/widgets/custom_padding.dart';
import 'package:zekr/widgets/custom_size.dart';

class ExplainHadith extends StatelessWidget {
  final String title;
  ExplainHadith({super.key, required this.title});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: controller.bgColor.value,
        appBar: AppBar(
          backgroundColor: controller.widgetColor.value,
          foregroundColor: controller.textColor.value,
          title: Text(
            "حديث $title",
            style: ourStyle(
                color: controller.textColor.value,
                fontWeight: FontWeight.bold,
                size: 20),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.offAll(() => Hadith());
                },
                icon: Icon(Icons.arrow_forward))
          ],
          leading: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: controller.widgetColor.value,
                  builder: (BuildContext context) {
                    return CustomSize(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.font_download)),
        ),
        body: FutureBuilder<List>(
          future: HadithDatabase.getHadithWithTitle(title),
          builder: (context, snapshot) {
            log(title);
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: ourStyle(color: controller.textColor.value, size: 22),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: controller.textColor.value,
                ),
              );
            } else {
              final data = snapshot.data!;
              return Container(
                decoration: BoxDecoration(
                  color: controller.widgetColor.value,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: controller.textColor.value),
                ),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                    child: Obx(
                  () => Column(
                    children: [
                      CustomPadding(
                        title: title,
                        style: ourStyle(
                            color: controller.textColor.value,
                            size: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Divider(color: controller.textColor.value),
                      customContainer("نص الحديث"),
                      CustomPadding(
                        title: data[0]['nuse'].toString(),
                        style: ourStyle(
                          color: controller.textColor.value,
                          size: controller.fontSize.value,
                        ),
                      ),
                      Divider(color: controller.textColor.value),
                      customContainer("شرح الحديث"),
                      CustomPadding(
                        title: data[0]['explain'].toString(),
                        style: ourStyle(
                          color: controller.textColor.value,
                          size: controller.fontSize.value,
                        ),
                      ),
                      Divider(color: controller.textColor.value),
                      customContainer("راوي الحديث"),
                      CustomPadding(
                        title: data[0]['rawy'].toString(),
                        style: ourStyle(
                          color: controller.textColor.value,
                          size: controller.fontSize.value,
                        ),
                      ),
                      Divider(color: controller.textColor.value),
                      CustomPadding(
                        title: data[0]['note'].toString(),
                        style: ourStyle(
                          color: controller.textColor.value,
                          size: controller.fontSize.value,
                        ),
                      ),
                    ],
                  ),
                )),
              );
            }
          },
        ),
      ),
    );
  }

  Container customContainer(String text) {
    return Container(
      decoration: BoxDecoration(
          color: controller.bgColor.value,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: controller.textColor.value)),
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.all(15),
      child: Text(
        text,
        style: ourStyle(size: 22, color: controller.textColor.value),
      ),
    );
  }
}
