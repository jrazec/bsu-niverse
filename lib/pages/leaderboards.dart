import 'package:bsuniverse/main.dart';
import 'package:bsuniverse/pages/home.dart' hide ashMaroon;
import 'package:flutter/material.dart';

class Leaderboards extends StatelessWidget {
  const Leaderboards({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboard = [
      {
        "rank": 1,
        "name": "jaise",
        "level": "Level 7",
        "points": 9875,
        "image": AssetImage("assets/images/razec.png"),
      },
      {
        "rank": 2,
        "name": "auclinn",
        "level": "Level 7",
        "points": 9240,
        "image": AssetImage("assets/images/berna.png"),
      },
      {
        "rank": 3,
        "name": "crls_brook",
        "level": "Level 7",
        "points": 9240,
        "image": AssetImage("assets/images/yajie.png"),
      },
      {
        "rank": 4,
        "name": "caspuur",
        "level": "Level 7",
        "points": 9240,
        "image": AssetImage("assets/images/puge.png"),
      },
      {
        "rank": 5,
        "name": "yuhhhh",
        "level": "Level 7",
        "points": 9240,
        "image": AssetImage("assets/images/yuhh.png"),
      },
    ];

    return SingleChildScrollView(
      child: Container(
      color: fineRed,
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
        Stack(
          alignment: Alignment.center,
          children: [
          Container(
            height: 40,
            width: 400,
            alignment: Alignment.center,
            decoration: BoxDecoration(
            color: ashMaroon,
            boxShadow: [
              BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 1),
              blurRadius: 10,
              spreadRadius: 2,
              ),
              BoxShadow(
              color: Color.fromRGBO(255, 215, 0, 1.0),
              offset: const Offset(0, -3), // upward
              blurRadius: 0,
              spreadRadius: 0.18,
              ),
              // Bottom shadow
              BoxShadow(
              color: Color.fromRGBO(255, 215, 0, 1.0),
              offset: const Offset(0, 3), // downward
              blurRadius: 0,
              spreadRadius: 0.18,
              ),
            ],
            ),
          ),
          Container(
            height: 60,
            width: 250,
            alignment: Alignment.center,
            decoration: BoxDecoration(
            color: ashMaroon,
            boxShadow: [
              BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 1),
              blurRadius: 5,
              spreadRadius: 2,
              ),
              BoxShadow(
              color: Color.fromRGBO(255, 215, 0, 1.0),
              offset: const Offset(0, -3), // upward
              blurRadius: 0,
              spreadRadius: 0.18,
              ),
              // Bottom shadow
              BoxShadow(
              color: Color.fromRGBO(255, 215, 0, 1.0),
              offset: const Offset(0, 3), // downward
              blurRadius: 0,
              spreadRadius: 0.18,
              ),
            ],
            ),
            child: Text(
            "LEADERBOARDS",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PixeloidSans-Bold',
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: Color.fromRGBO(240, 240, 22, 1),
            ),
            ),
          ),
          ],
        ),
        Divider(height: 40, color: Colors.white),

        // Leaderboard Cards
        ...leaderboard.map((user) {
          return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
            children: [
              CircleAvatar(
              backgroundColor: Colors.grey[200],
              radius: 18,
              child: Text(
                user["rank"].toString(),
                style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'PixeloidSans',
                ),
              ),
              ),
              const SizedBox(width: 10),
              CircleAvatar(
              backgroundImage: user["image"] as AssetImage,
              radius: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  user["name"] as String,
                  style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'VT323',
                  height: 1,
                  ),
                ),
                Text(
                  user["level"] as String,
                  style: const TextStyle(
                  color: Colors.grey,
                  fontFamily: 'VT323',
                  ),
                ),
                ],
              ),
              ),
              Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                user["points"].toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 16,
                  fontFamily: 'PixeloidSans',
                ),
                ),
                const Text(
                "points",
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'VT323',
                ),
                ),
              ],
              ),
            ],
            ),
          ),
          );
        }).toList(),

        const SizedBox(height: 20),

        // Your Rank Section
        Container(
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.redAccent, width: 1.5),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
          children: [
            const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                "Your Rank",
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                fontFamily: 'PixeloidSans',
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                CircleAvatar(
                  backgroundColor: Color.fromARGB(255, 222, 222, 222),
                  radius: 20,
                  child: Text(
                  "-",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                  "Start playing to see your rank!",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'VT323',
                  ),
                  ),
                ),
                ],
              ),
              ],
            ),
            ),
            Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                children: [
                Icon(Icons.trending_up, color: Colors.red, size: 16),
                SizedBox(width: 4),
                Text(
                  "Improve",
                  style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'VT323',
                  ),
                ),
                ],
              ),
              ),
              const SizedBox(height: 8),
              const Text(
              "0",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 16,
                fontFamily: 'PixeloidSans',
              ),
              ),
              const Text(
              "points",
              style: TextStyle(color: Colors.grey, fontFamily: 'VT323'),
              ),
            ],
            ),
          ],
          ),
        ),
        ],
      ),
      ),
    );
  }
}
