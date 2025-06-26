import 'package:flutter/material.dart';

class DevCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;
  final List<String> links;
  final String description;
  final Color colorInput;
  const DevCard({
    super.key,
    required this.name,
    required this.role,
    required this.imagePath,
    required this.links,
    required this.description, 
    required this.colorInput,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      padding: const EdgeInsets.all(12),
      
      decoration: BoxDecoration(
        color: colorInput,
        image: DecorationImage(
          image: AssetImage('assets/images/card_texture.png'), // your AVIF file
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            colorInput, 
            BlendMode.multiply, 
          ),
        ),
        border: Border.all(color: Color.fromRGBO(110, 14, 21, 1.0), width: 3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.shade400,
            offset: const Offset(4, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row (Name + "HP"/Role)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontFamily: 'OrangeKid',
                  fontSize: 22,
                  color: Color.fromRGBO(110, 14, 21, 1.0),
                ),
              ),
              Text(
                role,
                style: const TextStyle(
                  fontFamily: 'OrangeKid',
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Image
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(color: const Color.fromRGBO(110, 14, 21, 1.0), width: 2),
            ),
            child: imagePath.isNotEmpty
                ? Image.asset(imagePath, fit: BoxFit.cover)
                : const Center(child: Text("Dev Avatar")),
          ),

          const SizedBox(height: 12),

          // "Abilities" = Links
          ...links.map(
            (linkText) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.star_rounded, size: 16, color: Color.fromARGB(255, 0, 0, 0)),
                  const SizedBox(width: 8),
                  Text(
                    linkText,
                    style: const TextStyle(
                      fontFamily: 'OrangeKid',
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Description Box 
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: 'OrangeKid',
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
