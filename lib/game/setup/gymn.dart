import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

void setUpGymn(TiledComponent map) {
 
  final List<Portal> gym = [
    Portal(
      map: map,
      destination: GoTo.map, 
      startingPosition: Vector2(665, 482),
      selection: FloorList(goOut: true),
    ),
  ];

  loopThroughPortals(gym, map);
}
