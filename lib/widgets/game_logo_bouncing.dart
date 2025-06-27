import 'package:flutter/material.dart';

class SpartanLogo extends StatefulWidget {
  const SpartanLogo({super.key});

  @override
  State<SpartanLogo> createState() => _SpartanLogoState();
}

class _SpartanLogoState extends State<SpartanLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final glowStrength = _controller.value;
        final scale = 1.0 + 0.05 * glowStrength;

        final glowShadows = [
          [0, 0, 0, 1.0, 200.0, 10.0],   // BLUCK
          [255, 255, 255, 0.9, 70.0, -20.0],   // White
          [255, 106, 0,    0.35, 100.0, -10.0], // Orange
          [201, 33, 30,    0.55, 150.0, 10.0],  // Red
        ].map((data) {
          return BoxShadow(
            color: Color.fromRGBO(
              data[0] as int,
              data[1] as int,
              data[2] as int,
              (data[3] as double) + (data[3] as double) * glowStrength,
            ),
            blurRadius: data[4] as double,
            spreadRadius: data[5] as double,
          );
        }).toList();

        return Transform.scale(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: glowShadows,
            ),
            child: Image.asset(
              'assets/images/bsuniverse_logo.png',
              width: 150,
              filterQuality: FilterQuality.none,
            ),
          ),
        );
      },
    );
  }
}
