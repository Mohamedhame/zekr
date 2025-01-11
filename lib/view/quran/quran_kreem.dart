import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zekr/const/const.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/download/getPath_permisisson_anthor.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/view/quran/audio_play.dart';
import 'package:zekr/widgets/custom_page.dart';
import 'package:zekr/widgets/custom_text_field.dart';

class QuranKreem extends StatelessWidget {
  final String shikhName;
  final String url;
  QuranKreem({super.key, required this.shikhName, required this.url});

  final HomeController controller = Get.find<HomeController>();

  //====
  Future<void> check() async {
    controller.isExit.clear();
    List<Future<void>> tasks = [];
    for (var i = 0; i < controller.filteredSurah.length; i++) {
      tasks.add(
        GetPathPermisissonAnthor.checkExist(
          dir: shikhName,
          fileName: "${controller.filteredSurah[i]['name']}",
        ).then((exists) {
          controller.isExit.add(exists);
          controller.update();
        }),
      );
    }

    await Future.wait(tasks);
  }

  //========
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.bgColor.value,
      appBar: AppBar(
        foregroundColor: controller.textColor.value,
        backgroundColor: controller.widgetColor.value,
        centerTitle: true,
        title: Text(
          shikhName,
          style: ourStyle(size: 28, color: controller.textColor.value),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: controller.fetchSurah(shikhName, url).then((_) => check()),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "${snapshot.error}",
                  style: ourStyle(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Obx(() {
                return Column(
                  children: [
                    CustomTextField(
                      searchText: "اكتب اسم السورة",
                      onChange: controller.runFilterSurah,
                    ),
                    Expanded(
                      child: controller.filteredSurah.isEmpty
                          ? Center(
                              child: Text(
                                'لا توجد نتائج مطابقة',
                                style: ourStyle(
                                  size: 20,
                                  color: controller.textColor.value,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: controller.filteredSurah.length,
                              itemBuilder: (context, index) {
                                return CustomPage(
                                  text:
                                      "${controller.filteredSurah[index]['name']}",
                                  onTap: () {},
                                  style: ourStyle(
                                    size: 22,
                                    color: controller.textColor.value,
                                  ),
                                  icon: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          controller.isSerah.value = false;
                                          controller.shikhName.value =
                                              shikhName;
                                          controller.playSong(
                                            startIndex: index,
                                            myList: controller.filteredSurah,
                                          );
                                          Get.to(() => AudioPlay());
                                        },
                                        icon: Icon(Icons.headphones_rounded),
                                      ),
                                      controller.icons(
                                          index,
                                          shikhName,
                                          "${controller.filteredSurah[index]['name']}",
                                          "${controller.filteredSurah[index]['url']}",
                                          textColor),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              });
            }
          },
        ),
      ),
    );
  }
}
