import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

void setUpComLab502Lsb(TiledComponent map) {
  // Get the game instance to access stored portal information
   final List<Portal> comLab502LSBRoom = [
    Portal(
      map: map,
      destination: lastMap ?? GoTo.map, 
      startingPosition: lastPortalPosition ?? Vector2(0, 0),
      selection: FloorList(goOut: true),
    ),
  ];

  loopThroughPortals(comLab502LSBRoom, map);
}
