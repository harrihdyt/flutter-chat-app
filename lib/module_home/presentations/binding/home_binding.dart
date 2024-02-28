import 'package:flutter_chat_app/module_home/presentations/getx/home_controller.dart';
import 'package:get/get.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(),
    );
  }
}
