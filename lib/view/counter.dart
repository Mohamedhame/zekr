import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:zekr/const/text_style.dart';
import 'package:zekr/controller/home_controller.dart';
import 'package:zekr/widgets/counter/custom_counter.dart';
import 'package:zekr/widgets/counter/custom_dropdown_button.dart';

class Counter extends StatelessWidget {
  Counter({super.key});
  final HomeController controller = Get.find<HomeController>();
  final TextEditingController number = TextEditingController(text: "33");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: controller.bgColor.value,
      appBar: AppBar(
        backgroundColor: controller.widgetColor.value,
        foregroundColor: controller.textColor.value,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //==============
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 40, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                      ),
                      alignment: Alignment.center,
                      child: CustomDropdownButton(
                        style: ourStyle(color: controller.textColor.value),
                      ),
                    ),
                  ),
                  //=======
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: ourStyle(color: controller.textColor.value),
                      onSubmitted: (newV) {
                        controller.counter.value = 0;
                      },
                      onChanged: (value) {},
                      controller: number,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          labelText: "العدد",
                          labelStyle:
                              ourStyle(color: controller.textColor.value)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            InkWell(
              onTap: increas,
              child: CustomCounter(),
            ),
          ],
        ),
      ),
    );
  }

  //=================
  void increas() {
    if (number.text.isEmpty) {
      // Fluttertoast.showToast(msg: "ادخل العدد");
      Get.snackbar("العدد", "ادخل العدد",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: controller.widgetColor.value);
    } else {
      controller.total.value = int.parse(number.text);
      if (controller.counter.value == controller.total.value) {
        controller.counter.value = 0;
      } else {
        controller.counter.value++;
      }
    }
  }
}
