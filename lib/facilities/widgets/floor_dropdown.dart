import 'package:flutter/material.dart';
import '../data/facility_models.dart';

class FloorDropdown extends StatefulWidget {
  final Floor floor;
  final Function(Room) onRoomTap;

  const FloorDropdown({Key? key, required this.floor, required this.onRoomTap}) : super(key: key);

  @override
  _FloorDropdownState createState() => _FloorDropdownState();
}

class _FloorDropdownState extends State<FloorDropdown>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.red.shade500;
    final LinearGradient headerGradient = LinearGradient(
      colors: [Colors.red.shade400, Colors.orange.shade300],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor, width: 3),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.white, Colors.amber.shade50],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(17),
            onTap: _toggleExpand,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                gradient: headerGradient,
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.floor.name,
                      style: const TextStyle(
                        fontFamily: 'PressStart2P',
                        fontSize: 12,
                        color: Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.catching_pokemon,
                    color: Colors.white,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _animation,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(17)),
              child: Container(
                color: Colors.white.withOpacity(0.92),
                child: Column(
                  children: [
                    if (widget.floor.image != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 520,
                            maxHeight: 200,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(14),
                              topRight: Radius.circular(14),
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 6,
                              child: Image.asset(
                                widget.floor.image!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: primaryColor.withOpacity(0.1),
                                  child: Icon(Icons.photo, color: primaryColor, size: 48),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Column(
                        children: widget.floor.rooms
                            .map(
                              (room) => RoomItem(
                                room: room,
                                fallbackImage: widget.floor.image,
                                accentColor: primaryColor,
                                onTap: () => widget.onRoomTap(room),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoomItem extends StatelessWidget {
  final Room room;
  final String? fallbackImage;
  final VoidCallback onTap;
  final Color accentColor;

  const RoomItem({
    Key? key,
    required this.room,
    required this.onTap,
    required this.accentColor,
    this.fallbackImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? imagePath = room.image ?? fallbackImage;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: accentColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.meeting_room,
                    size: 36,
                    color: accentColor,
                  ),
                ),
              )
            else
              Icon(Icons.meeting_room, size: 36, color: accentColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                room.name,
                style: const TextStyle(
                  fontFamily: 'PixeloidSans',
                  fontSize: 14,
                  color: Color(0xFF2D3436),
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: accentColor),
          ],
        ),
      ),
    );
  }
}
