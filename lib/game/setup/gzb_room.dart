import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

void setUpGzbRoom(TiledComponent map) {
  // TODO: Implement GZB room portal setup
  // Add portals for GZB general room
  final List<Portal> gzbRoomPortals = [
    Portal(
      map: map,
      destination: GoTo.gzb,
      startingPosition: Vector2(0, 0),
      selection: FloorList(goOut: true),
    ),
  ];

  loopThroughPortals(gzbRoomPortals, map);
}
