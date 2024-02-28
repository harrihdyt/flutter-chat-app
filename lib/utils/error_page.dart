import 'package:flutter/material.dart';

class ErroPage extends StatelessWidget {
  const ErroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 100,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Opps, Something Wrong!',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
