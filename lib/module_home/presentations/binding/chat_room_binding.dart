import 'package:flutter_chat_app/module_home/presentations/getx/chat_room_controller.dart';
import 'package:get/get.dart';

class ChatRoom extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ChatRoomController(),
    );
  }
}
