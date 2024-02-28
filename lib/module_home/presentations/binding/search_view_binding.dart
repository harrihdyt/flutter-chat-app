import 'package:flutter_chat_app/module_home/presentations/getx/search_controller.dart';
import 'package:get/get.dart';

class SearchViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SearchContactController(),
    );
  }
}
