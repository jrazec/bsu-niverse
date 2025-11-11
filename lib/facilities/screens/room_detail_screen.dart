import 'package:flutter/material.dart';
import '../data/facility_models.dart';

class RoomDetailScreen extends StatelessWidget {
  final Building building;
  final Floor floor;
  final Room room;

  const RoomDetailScreen({
    Key? key,
    required this.building,
    required this.floor,
    required this.room,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? roomImage = room.image ?? floor.image ?? building.image;
    final Color primaryColor = Colors.red.shade600;
    final Color accentColor = Colors.amber.shade300;

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
              // Decorative bubbles to mimic Pokémon pop visuals
              Positioned(
                top: -40,
                right: -20,
                child: _AccentBubble(color: accentColor.withOpacity(0.35), size: 140),
              ),
              Positioned(
                bottom: -30,
                left: -10,
                child: _AccentBubble(color: primaryColor.withOpacity(0.25), size: 160),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                    child: _PoketopBar(title: room.name),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 720),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.92),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: primaryColor, width: 3),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.25),
                                  blurRadius: 18,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 520,
                                      maxHeight: 260,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: roomImage != null
                                            ? Image.asset(
                                                roomImage,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => _MissingImagePlaceholder(color: primaryColor),
                                              )
                                            : _MissingImagePlaceholder(color: primaryColor),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    room.name,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'PressStart2P',
                                      fontSize: 16,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      _LocationBadge(
                                        icon: Icons.apartment,
                                        label: building.name,
                                        color: primaryColor,
                                      ),
                                      _LocationBadge(
                                        icon: Icons.layers,
                                        label: floor.name,
                                        color: Colors.orange.shade400,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    room.description,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'PixeloidSans',
                                      fontSize: 14,
                                      height: 1.6,
                                      color: Color(0xFF2C3E50),
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                  _PokeDivider(color: accentColor),
                                  const SizedBox(height: 18),
                                  Text(
                                    'Trainers say this room is perfect for discoveries!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'VT323',
                                      fontSize: 20,
                                      color: primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton.icon(
                                    onPressed: () => Navigator.pop(context),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        side: BorderSide(color: accentColor, width: 2),
                                      ),
                                      elevation: 6,
                                    ),
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text(
                                      'Return to Map',
                                      style: TextStyle(fontFamily: 'PressStart2P', fontSize: 10),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
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

class _PoketopBar extends StatelessWidget {
  final String title;

  const _PoketopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.shade300, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade600.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 12,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _LocationBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _LocationBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'PixeloidSans',
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _AccentBubble extends StatelessWidget {
  final Color color;
  final double size;

  const _AccentBubble({required this.color, required this.size});

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

class _PokeDivider extends StatelessWidget {
  final Color color;

  const _PokeDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

class _MissingImagePlaceholder extends StatelessWidget {
  final Color color;

  const _MissingImagePlaceholder({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color.withOpacity(0.1),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: color,
          size: 48,
        ),
      ),
    );
  }
}
