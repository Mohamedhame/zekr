import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:zekr/controller/home_controller.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(HomeController());
  }
}
