part of 'pages.dart';

class AuthPage extends GetView<AuthController> {
  AuthPage({super.key});

  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.connect_without_contact_rounded,
                color: Colors.white,
                size: 100,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
          onPressed: () {
            authController.login();
          },
          child: const Text(
            'Sign In with Google',
          ),
        ),
      ],
    )));
  }
}
