import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/view/home/home_page.dart';

import 'package:zekr/view/quran/quran_kreem.dart';
import 'package:zekr/widgets/custom_page.dart';
import 'package:zekr/widgets/custom_text_field.dart';

class Quraa extends StatelessWidget {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.bgColor.value,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: controller.textColor.value,
        centerTitle: true,
        title: Text(
          "القرآء",
          style: ourStyle(size: 28, color: controller.textColor.value),
        ),
        leading: IconButton(
            onPressed: () {
              Get.offAll(() => HomePage());
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: controller.fetchQuraa(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "${snapshot.error}",
                  style: ourStyle(color: controller.textColor.value),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Column(
                children: [
                  CustomTextField(
                      searchText: "اكتب اسم الشيخ",
                      onChange: controller.runFilterQuraa),
                  Expanded(
                    child: Obx(() => controller.filteredQuraa.isEmpty
                        ? Center(
                            child: Text(
                              'لا توجد نتائج مطابقة',
                              style: ourStyle(
                                  size: 20, color: controller.textColor.value),
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.filteredQuraa.length,
                            itemBuilder: (context, index) {
                              return CustomPage(
                                text:
                                    "${controller.filteredQuraa[index]['name']}",
                                onTap: () {
                                  Get.to(() => QuranKreem(
                                      shikhName: controller.filteredQuraa[index]
                                          ['name'],
                                      url: controller.filteredQuraa[index]
                                          ['url']));
                                },
                                style: ourStyle(
                                    size: 20,
                                    color: controller.textColor.value),
                              );
                            },
                          )),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  //=====
}
