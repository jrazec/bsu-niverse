import 'package:flutter/material.dart';
import 'game_logo_bouncing.dart'; 

class SpartanLoadingScreen extends StatelessWidget {
  const SpartanLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SpartanLogo(),
      ),
    );
  }
}
