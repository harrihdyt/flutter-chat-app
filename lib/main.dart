import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/common/controller/auth_controller.dart';
import 'package:flutter_chat_app/common/routes/app_pages.dart';
import 'package:flutter_chat_app/utils/error_page.dart';
import 'package:flutter_chat_app/utils/loading_page.dart';
import 'package:flutter_chat_app/utils/splash_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final onboard = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ErroPage();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return FutureBuilder(
            future: Future.delayed(const Duration(seconds: 3)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Obx(
                  () => GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    initialRoute: onboard.isSkip.isTrue
                        ? onboard.isLogin.isTrue
                            ? AppRoutes.Home
                            : AppRoutes.Auth
                        : AppRoutes.Intro,
                    getPages: AppPages.routes,
                  ),
                );
              }
              return FutureBuilder(
                future: onboard.firstInitialized(),
                builder: (context, snapshot) => const SplashScreen(),
              );
            },
          );
        }

        return const LoadingPage();
      },
    );
  }
}
