import 'package:flutter_chat_app/module_account/presentations/binding/profile_binding.dart';
import 'package:flutter_chat_app/module_account/presentations/pages/pages.dart';
import 'package:flutter_chat_app/module_auth/presentations/binding/auth_binding.dart';
import 'package:flutter_chat_app/module_auth/presentations/pages/pages.dart';
import 'package:flutter_chat_app/module_home/presentations/binding/chat_room_binding.dart';
import 'package:flutter_chat_app/module_home/presentations/binding/home_binding.dart';
import 'package:flutter_chat_app/module_home/presentations/binding/search_view_binding.dart';
import 'package:flutter_chat_app/module_home/presentations/pages/pages.dart';
import 'package:flutter_chat_app/module_introduction/presentations/binding/introduction_binding.dart';
import 'package:flutter_chat_app/module_introduction/presentations/pages/pages.dart';
import 'package:get/route_manager.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.Home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.Auth,
      page: () => AuthPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.Intro,
      page: () => IntroductionPage(),
      binding: IntroductionBinding(),
    ),
    GetPage(
      name: _Paths.Profile,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.ChatRoom,
      page: () => ChatRoomPage(),
      binding: ChatRoom(),
    ),
    GetPage(
      name: _Paths.SearchView,
      page: () => SearchViewPage(),
      binding: SearchViewBinding(),
    ),
  ];
}
