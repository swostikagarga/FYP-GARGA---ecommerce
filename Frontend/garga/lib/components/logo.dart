import 'package:flutter/material.dart';

class MyLogo extends StatelessWidget {
  const MyLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Image(
      height: 250,
      image: AssetImage("assets/garga.png"),
    );
  }
}
