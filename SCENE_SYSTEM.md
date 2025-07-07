# BSUniverse Scene Management System Documentation

## Overview
The Scene system handles map loading, scene transitions, collisions, portals, and popup interactions in BSUniverse. It provides a robust framework for managing different areas of the campus.

## Scene Architecture

### Core Components
- **Scene**: Main class that manages map loading and scene transitions
- **Floor**: Configuration class that defines what elements are active per floor
- **Portal**: Interactive areas that trigger scene transitions
- **Popup**: Interactive areas that show dialogues and NPCs
- **tmxConfig**: Configuration mapping for all TMX map files

## Scene Configuration

### Available Maps
```dart
final Map<String, Map<String, dynamic>> tmxConfig = {
  "bedroom": {"image": "Bedroom.tmx", "w": 10, "h": 10},
  "mapBsu": {"image": "bsu-map.tmx", "w": 38, "h": 39},     // Main campus map
  "lsb": {"image": "cecs.tmx", "w": 10, "h": 10},            // LSB Building
  "vmb": {"image": "hebuilding.tmx", "w": 10, "h": 10},      // VMB Building
  "aab": {"image": "old_building.tmx", "w": 10, "h": 10},    // AAB Building
  "gzb": {"image": "gzbuilding.tmx", "w": 57, "h": 39},      // GZB Building
  "multimedia": {"image": "multimedia.tmx", "w": 10, "h": 10},
  // ... room configurations
};
```

## Floor System

### Floor Configuration
```dart
Floor currentFloor = Floor(
  activate: [
    {
      FloorList.f1: {
        RoomList.d1: GoToRoom.comLab201VMB,
        RoomList.d2: GoToRoom.genRoomLSB,
        RoomList.d3: GoToRoom.genRoomGZB,
      },
    },
  ],
  out: RoomList.d1,
);
```

### Enums
- **FloorList**: `f1, f2, f3, f4, f5` - Available floors
- **RoomList**: `d1, d2, d3, d4, d5, d6, d7, d8, d9, d10` - Available rooms
- **GoToRoom**: Specific room destinations (labs, library, canteen, etc.)

## Portal System

### TMX Integration
Portals are loaded from TMX files using the 'Portals' object layer:
- **Object Name**: Portal identifier (e.g., 'toLSB', 'toVMB')
- **Position**: X, Y coordinates in the map
- **Size**: Width, height of the portal area

### Portal Mapping
```dart
String _getPortalDestination(String portalId) {
  switch (portalId) {
    case 'toLSB': return 'lsb';
    case 'toVMB': return 'vmb';
    case 'toGZB': return 'gzb';
    case 'toAAB': return 'aab';
    case 'toBedroom': return 'bedroom';
    default: return 'mapBsu';
  }
}
```

## Popup System

### TMX Integration
Popups are loaded from TMX files using the 'Popups' object layer:
- **Object Name**: Popup identifier
- **Properties**:
  - `dialogue`: Text to display
  - `npcImage`: Image file for NPC
- **Position**: X, Y coordinates in the map
- **Size**: Width, height of the popup area

## Usage Examples

### Changing Scenes
```dart
// Change to a specific scene
await scene.changeScene("lsb");

// Change scene with player spawn position
await scene.changeScene("vmb", playerSpawnPosition: Vector2(100, 200));
```

### Updating Floor Configuration
```dart
Floor newFloor = Floor(
  activate: [
    {
      FloorList.f2: {
        RoomList.d4: GoToRoom.library,
        RoomList.d5: GoToRoom.canteen,
      },
    },
  ],
  out: RoomList.d4,
);

scene.setCurrentFloor(newFloor);
```

### Checking Portal Interactions
```dart
// Called from game update loop
scene.checkPortalInteractions(player.position, player.size);
```

## Collision System

### TMX Integration
Collisions are loaded from TMX files using the 'Collisions' object layer:
- Objects in this layer automatically become WallComponent instances
- No additional configuration needed

### Automatic Loading
```dart
Future<void> loadCollisions() async {
  final collisions = currentMap.tileMap.getLayer<ObjectGroup>('Collisions');
  if (collisions != null) {
    for (final obj in collisions.objects) {
      final wallComponent = WallComponent(
        Vector2(obj.x, obj.y),
        Vector2(obj.width, obj.height),
      );
      currentMap.add(wallComponent);
    }
  }
}
```

## Performance Features

### Map Caching
- Maps are cached after first load to improve performance
- Cached maps are reused when returning to previously visited scenes

### Smart Loading
- Only active elements (based on Floor configuration) are loaded
- Inactive portals and popups are not added to the scene

### Memory Management
- Previous scene elements are properly cleaned up before loading new ones
- Components are removed from both the scene and component lists

## Adding New Scenes

### 1. Add TMX Configuration
```dart
final Map<String, Map<String, dynamic>> tmxConfig = {
  // ...existing configs...
  "newBuilding": {"image": "new_building.tmx", "w": 20, "h": 25},
};
```

### 2. Add Portal Destinations
```dart
String _getPortalDestination(String portalId) {
  switch (portalId) {
    // ...existing cases...
    case 'toNewBuilding': return 'newBuilding';
    default: return 'mapBsu';
  }
}
```

### 3. Update Floor Configuration
```dart
Floor newFloor = Floor(
  activate: [
    {
      FloorList.f1: {
        RoomList.d6: GoToRoom.newRoom,
      },
    },
  ],
  out: RoomList.d6,
);
```

## Error Handling

### Robust Error Management
- Graceful handling of missing TMX files
- Fallback to default scenes if configuration errors occur
- Console logging for debugging scene loading issues

### Debug Output
- Scene change notifications
- Element loading counts (collisions, portals, popups)
- Error messages with specific failure details

## Integration with Game

### Game Setup
```dart
// In BSUniverseGame class
scene = Scene(joystick);
world = scene;
world.add(player);
```

### Player Integration
The scene system integrates with the player component to handle portal interactions and scene transitions automatically.

This scene management system provides a flexible, extensible foundation for managing all campus areas and interactions in BSUniverse!
