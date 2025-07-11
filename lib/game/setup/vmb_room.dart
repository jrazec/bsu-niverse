import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

void setUpVmbRoom(TiledComponent map) {
 
    // Create exit portal that returns to the originating map and position
  final List<Portal> vmbRoom = [
    Portal(
      map: map,
      destination: lastMap ?? GoTo.map, 
      startingPosition: lastPortalPosition ?? Vector2(0, 0),
      selection: FloorList(goOut: true),
    ),
  ];

  loopThroughPortals(vmbRoom, map);
}
