import 'package:flutter/material.dart';

class PixelCard extends StatelessWidget {
  final String title;
  final List<String> bullets;

  const PixelCard({
    super.key,
    required this.title,
    required this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 50,right: 50,top: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color.fromRGBO(201, 33, 30, 1.0), width: 4),
        borderRadius: BorderRadius.circular(0), // square edges, pixel style
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'OrangeKid',
              fontSize: 30,
              color: Color.fromRGBO(201, 33, 30, 1.0),
              height: 1.2,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          // Bullets
          ...bullets.map((text) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.arrow_right,
                      color: Color.fromRGBO(27, 27, 27, 1.0),
                    ),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(
                          fontSize: 20,
                          height: 1,
                          fontFamily: 'OrangeKid'
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
