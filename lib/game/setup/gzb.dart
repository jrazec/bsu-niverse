import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';


void setUpGzb(TiledComponent map) {
  // TODO: Implement GZB building portal setup
  // Add portals for GZB building
   final List<Portal> gzbPortals = [
    Portal(
      map: map,
      destination: GoTo.genRoomLSB,
      startingPosition: Vector2(74, 163),
      selection: FloorList(floor1: RoomList.d1),
    ),
  ];

 loopThroughPortals(gzbPortals,map);
}
