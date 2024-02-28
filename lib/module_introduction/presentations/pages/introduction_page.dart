part of 'pages.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pageviw = [
      PageViewModel(
        title: "Terhubung Dengan Mudah",
        body: "Berkirim pesan dengan mudah",
        image: const Center(
          child: Icon(Icons.waving_hand, size: 50.0),
        ),
      ),
      PageViewModel(
        title: "Cepat dan Gratis",
        body: "Tanpa batasan waktu dan menghabiskan uang.",
        image: const Center(
          child: Icon(Icons.waving_hand, size: 50.0),
        ),
      ),
    ];

    return Scaffold(
        body: IntroductionScreen(
      pages: pageviw,
      showSkipButton: true,
      skip: const Text("Skip"),
      next: const Text("Next"),
      done: const Text("Join Now"),
      onDone: () {
        Get.offAllNamed(AppRoutes.Auth);
        // When done button is press
      },
      baseBtnStyle: TextButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
      ),
      skipStyle: TextButton.styleFrom(foregroundColor: Colors.red),
      doneStyle: TextButton.styleFrom(foregroundColor: Colors.green),
      nextStyle: TextButton.styleFrom(foregroundColor: Colors.blue),
    ));
  }
}
