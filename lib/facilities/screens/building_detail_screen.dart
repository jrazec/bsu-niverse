import 'package:flutter/material.dart';
import '../data/facility_models.dart';
import '../widgets/floor_dropdown.dart';
import 'room_detail_screen.dart';

class BuildingDetailScreen extends StatelessWidget {
  final Building building;

  const BuildingDetailScreen({Key? key, required this.building}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red.shade100, Colors.yellow.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -40,
                child: _BuildingBubble(color: Colors.red.shade200.withOpacity(0.35), size: 180),
              ),
              Positioned(
                bottom: -40,
                left: -20,
                child: _BuildingBubble(color: Colors.amber.shade200.withOpacity(0.3), size: 200),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
                    child: _BuildingHeader(building: building),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: building.floors.length,
                      itemBuilder: (context, index) {
                        final floor = building.floors[index];
                        return FloorDropdown(
                          floor: floor,
                          onRoomTap: (room) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RoomDetailScreen(
                                  building: building,
                                  floor: floor,
                                  room: room,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildingHeader extends StatelessWidget {
  final Building building;

  const _BuildingHeader({required this.building});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.amber.shade300, width: 2),
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    building.shortName,
                    style: const TextStyle(
                      fontFamily: 'PressStart2P',
                      fontSize: 12,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    building.name,
                    style: const TextStyle(
                      fontFamily: 'PixeloidSans-Bold',
                      fontSize: 16,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${building.floors.length} floors • Pokémon explorer approved',
                    style: const TextStyle(
                      fontFamily: 'PixeloidSans',
                      fontSize: 12,
                      color: Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

      ],
    );
  }
}

class _BuildingBubble extends StatelessWidget {
  final Color color;
  final double size;

  const _BuildingBubble({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
