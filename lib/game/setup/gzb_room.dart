import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

void setUpGzbRoom(TiledComponent map) {
    
  final List<Portal> gzbRoom = [
    Portal(
      map: map,
      destination: lastMap ?? GoTo.map, 
      startingPosition: lastPortalPosition ?? Vector2(0, 0),
      selection: FloorList(goOut: true),
    ),
  ];

  loopThroughPortals(gzbRoom, map);
}
