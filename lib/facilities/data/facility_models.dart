class Room {
  final String name;
  final String description;
  final String? image;

  const Room({
    required this.name,
    this.description = 'A cozy spot somewhere in BSU Universe.',
    this.image,
  });
}

class Floor {
  final String name;
  final String? image;
  final List<Room> rooms;

  const Floor({
    required this.name,
    this.image,
    required this.rooms,
  });
}

class Building {
  final String id;
  final String name;
  final String shortName;
  final String image;
  final List<Floor> floors;

  const Building({
    required this.id,
    required this.name,
    required this.shortName,
    required this.image,
    required this.floors,
  });
}
