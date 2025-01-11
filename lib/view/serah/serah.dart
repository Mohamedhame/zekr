import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:zekr/const/const.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/download/getPath_permisisson_anthor.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/view/quran/audio_play.dart';
import 'package:zekr/widgets/custom_page.dart';

class Serah extends StatelessWidget {
  final String shikhName;
  Serah({super.key, required this.shikhName});
  final HomeController controller = Get.find<HomeController>();

  //====
  Future<void> check() async {
    controller.isExit.clear();

    List<Future<void>> tasks = [];
    for (var i = 0; i < controller.filteredSerah.length; i++) {
      tasks.add(
        GetPathPermisissonAnthor.checkExist(
          dir: shikhName,
          fileName: "${controller.filteredSerah[i]['name']}",
        ).then((exists) {
          controller.isExit.add(exists);
          controller.update();
        }),
      );
    }

    await Future.wait(tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.bgColor.value,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: controller.textColor.value,
        centerTitle: true,
        title: Text(
          "السيرة النبوية",
          style: ourStyle(size: 28, color: controller.textColor.value),
        ),
      ),
      body: FutureBuilder(
        future: controller.fetchSerah().then((_) => check()),
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
            controller.filteredSerah.sort((a, b) => a['id'].compareTo(b['id']));
            return ListView.builder(
              itemCount: controller.filteredSerah.length,
              itemBuilder: (context, index) {
                return CustomPage(
                  text: "${controller.filteredSerah[index]['name']}",
                  style: ourStyle(
                    color: controller.textColor.value,
                    size: 22,
                  ),
                  onTap: () {},
                  icon: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            controller.isSerah.value = true;
                            controller.shikhName.value = shikhName;
                            controller.playSong(
                              startIndex: index,
                              myList: controller.filteredSerah,
                            );
                            Get.to(() => AudioPlay());
                          },
                          icon: Icon(Icons.headphones_rounded)),
                      controller.icons(
                          index,
                          shikhName,
                          "${controller.filteredSerah[index]['name']}",
                          "${controller.filteredSerah[index]['url']}",
                          textColor),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
