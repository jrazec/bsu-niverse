import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

void setUpGymnOpenArea(TiledComponent map) {
    // Create exit portal that returns to the originating map and position
  final List<Portal> gymnOpenArea = [
    Portal(
      map: map,
      destination: GoTo.map, 
      startingPosition: Vector2(665, 482),
      selection: FloorList(goOut: true),
    ),
  ];

  loopThroughPortals(gymnOpenArea, map);
}
