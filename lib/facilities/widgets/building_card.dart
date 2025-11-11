import 'package:flutter/material.dart';
import '../data/facility_models.dart';

class BuildingCard extends StatelessWidget {
  final Building building;
  final VoidCallback onTap;

  const BuildingCard({Key? key, required this.building, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.red.shade500;
    final Color accentColor = Colors.amber.shade300;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: primaryColor, width: 3),
          gradient: LinearGradient(
            colors: [Colors.red.shade50, Colors.yellow.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  building.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: primaryColor.withOpacity(0.1),
                    child: Icon(Icons.apartment, color: primaryColor, size: 48),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              building.shortName,
              style: const TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 14,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              building.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'PixeloidSans',
                fontSize: 14,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentColor, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stairs, size: 18, color: Colors.black87),
                  const SizedBox(width: 6),
                  Text(
                    '${building.floors.length} floors',
                    style: const TextStyle(
                      fontFamily: 'PixeloidSans',
                      fontSize: 12,
                      color: Color(0xFF2C3E50),
                    ),
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
