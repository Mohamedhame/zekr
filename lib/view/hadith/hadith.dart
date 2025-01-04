import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/database/hadith_database.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/view/hadith/explain_hadith.dart';
import 'package:zekr/view/home/home_page.dart';
import 'package:zekr/widgets/custom_padding.dart';
import 'package:zekr/widgets/custom_size.dart';

class Hadith extends StatelessWidget {
  Hadith({super.key});
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
            "الحديث النبوي الشريف",
            style: ourStyle(
                color: controller.textColor.value,
                fontWeight: FontWeight.bold,
                size: 20),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Get.offAll(() => HomePage());
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
          future: HadithDatabase.getHadith(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                  style: ourStyle(color: controller.textColor.value),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  color: controller.textColor.value,
                ),
              );
            } else if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "لا يوجد بيانات لعرضها",
                  style: ourStyle(color: controller.textColor.value, size: 22),
                ),
              );
            } else {
              final List data = snapshot.data!;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.offAll(
                          () => ExplainHadith(title: data[index]['title']));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: controller.widgetColor.value,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: controller.textColor.value, width: 1),
                      ),
                      child: Column(
                        children: [
                          CustomPadding(
                              title: data[index]['title'],
                              style: ourStyle(
                                  color: controller.textColor.value,
                                  size: 22,
                                  fontWeight: FontWeight.bold)),
                          Divider(),
                          Obx(
                            () => CustomPadding(
                                title: data[index]['nuse'],
                                style: ourStyle(
                                  color: controller.textColor.value,
                                  size: controller.fontSize.value,
                                )),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
