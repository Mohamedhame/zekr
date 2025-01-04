import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/azkar/data.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/view/home/home_page.dart';
import 'package:zekr/widgets/azkar/custom_body.dart';
import 'package:zekr/widgets/azkar/custom_bottom.dart';
import 'package:zekr/widgets/azkar/custom_date.dart';
import 'package:zekr/widgets/azkar/custom_row.dart';
import 'package:zekr/widgets/custom_size.dart';

class Azkar extends StatefulWidget {
  Azkar({super.key});

  @override
  State<Azkar> createState() => _AzkarState();
}

class _AzkarState extends State<Azkar> {
  final HomeController controller = Get.find<HomeController>();

  final Data data = Data();
  @override
  void dispose() {
    super.dispose();
    controller.audioPlayer.stop();
  }

  @override
  Widget build(BuildContext context) {
    controller.pageCount.value = controller.isMorning.value
        ? data.zekrGroup.length
        : data.zekrGrouMsaa.length;
    return Scaffold(
      backgroundColor: controller.bgColor.value,
      appBar: AppBar(
          backgroundColor: controller.widgetColor.value,
          foregroundColor: controller.textColor.value,
          title: Text(
            "أذكار الصباح و المساء",
            style: ourStyle(color: controller.textColor.value, size: 28),
          ),
          centerTitle: true,
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
          actions: [
            IconButton(
                onPressed: () {
                  Get.offAll(() => HomePage());
                },
                icon: Icon(Icons.arrow_forward)),
          ]),
      body: Column(
        children: [
          CustomRow(),
          CustomDate(),
          CustomBody(data: data),
          CustomBottom(),
        ],
      ),
    );
  }
}
