import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:zekr/controller/home_controller.dart';

class CustomDropdownButton extends StatelessWidget {
  final TextStyle style;
  CustomDropdownButton({super.key, required this.style});
  final HomeController controller = Get.find<HomeController>();
  final List<String> items = [
    'سُبْحـانَ اللهِ وَبِحَمْـدِهِ',
    'لَا إلَه إلّا اللهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءِ قَدِيرِ',
    'أسْتَغْفِرُ اللهَ وَأتُوبُ إلَيْهِ',
    'سُبْحَانَ اللَّهِ',
    'الْحَمْدُ للّهِ',
    'الْلَّهُ أَكْبَرُ',
    'لا حَوْلَ وَلا قُوَّةَ إِلا بِاللَّهِ',
    'اللهم صلي علي نبينا محمد',
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => DropdownButton(
        style: style,
        value: controller.dropdownvalue.value,
        dropdownColor: controller.widgetColor.value,
        items: items.map((String item) {
          return DropdownMenuItem(
            value: item,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.65,
              child: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    item,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          controller.dropdownvalue.value = newValue!;
          controller.counter.value = 0;
        }));
  }
}
