import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.blue,
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
    );
  }
}
