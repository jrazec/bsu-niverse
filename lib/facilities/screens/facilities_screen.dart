import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/building_card.dart';
import 'building_detail_screen.dart';
import '../data/facility_models.dart';
import 'room_detail_screen.dart';

class FacilitiesScreen extends StatefulWidget {
  @override
  _FacilitiesScreenState createState() => _FacilitiesScreenState();
}

class _FacilitiesScreenState extends State<FacilitiesScreen> {
  List<Building> _filteredBuildings = mockBuildings;
  List<Room> _allRooms = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allRooms = mockBuildings.expand((b) {
      return b.floors.expand((f) {
        return f.rooms;
      });
    }).toList();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      // This will trigger a rebuild and the UI will update based on the search text
    });
  }

  @override
  Widget build(BuildContext context) {
    final String query = _searchController.text.trim().toLowerCase();
    final List<Room> matchingRooms = query.isEmpty
        ? const []
        : _allRooms
            .where(
              (room) => room.name.toLowerCase().contains(query),
            )
            .toList();

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
                top: -40,
                right: -30,
                child: _Bubble(color: Colors.red.shade200.withOpacity(0.35), size: 160),
              ),
              Positioned(
                bottom: -30,
                left: -20,
                child: _Bubble(color: Colors.amber.shade200.withOpacity(0.35), size: 190),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                    child: _HeaderBadge(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _SearchField(controller: _searchController),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: query.isEmpty
                        ? _BuildingGrid(
                            buildings: _filteredBuildings,
                            onTap: (building) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BuildingDetailScreen(building: building),
                                ),
                              );
                            },
                          )
                        : _SearchResults(
                            rooms: matchingRooms,
                            onRoomTap: (building, floor, room) {
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

class _HeaderBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.shade300, width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade600.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: const [
          Icon(Icons.map, color: Colors.white, size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'BSUniverse Facilities',
              style: TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 12,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;

  const _SearchField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.red.shade200, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade100.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.red.shade400),
          hintText: 'Search a room or laboratory...',
          hintStyle: const TextStyle(fontFamily: 'PixeloidSans', fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}

class _BuildingGrid extends StatelessWidget {
  final List<Building> buildings;
  final ValueChanged<Building> onTap;

  const _BuildingGrid({required this.buildings, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 0.82,
      ),
      itemCount: buildings.length,
      itemBuilder: (context, index) {
        final building = buildings[index];
        return BuildingCard(
          building: building,
          onTap: () => onTap(building),
        );
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  final List<Room> rooms;
  final void Function(Building building, Floor floor, Room room) onRoomTap;

  const _SearchResults({required this.rooms, required this.onRoomTap});

  @override
  Widget build(BuildContext context) {
    final bool hasResults = rooms.isNotEmpty;

    if (!hasResults) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.search_off, size: 48, color: Colors.black54),
            SizedBox(height: 12),
            Text(
              'No rooms discovered... yet!',
              style: TextStyle(fontFamily: 'PixeloidSans', fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemBuilder: (context, index) {
        final room = rooms[index];
        final Building building = mockBuildings.firstWhere((b) => b.floors.any((f) => f.rooms.contains(room)));
        final Floor floor = building.floors.firstWhere((f) => f.rooms.contains(room));
        final String? thumbnail = room.image ?? floor.image ?? building.image;

        return GestureDetector(
          onTap: () => onRoomTap(building, floor, room),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.red.shade300, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.shade200.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: thumbnail != null
                        ? Image.asset(
                            thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              color: Colors.red.shade50,
                              child: Icon(Icons.class_, color: Colors.red.shade400),
                            ),
                          )
                        : Container(
                            color: Colors.red.shade50,
                            child: Icon(Icons.class_, color: Colors.red.shade400),
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        room.name,
                        style: const TextStyle(
                          fontFamily: 'PixeloidSans-Bold',
                          fontSize: 14,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${building.name} - ${floor.name}',
                        style: const TextStyle(
                          fontFamily: 'PixeloidSans',
                          fontSize: 12,
                          color: Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.red),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemCount: rooms.length,
    );
  }
}

class _Bubble extends StatelessWidget {
  final Color color;
  final double size;

  const _Bubble({required this.color, required this.size});

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
