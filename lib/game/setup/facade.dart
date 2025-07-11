

// 

import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';


void setUpFacade(TiledComponent map) {
   final List<Portal> facadePortals = [
    // GOING IN CAMPUS
    Portal(
      map: map,
      destination: GoTo.map, 
      startingPosition: Vector2(380, 800),
      selection: FloorList(goOut: true),
    ),

    // GOING OUT CAMPUS
    Portal(
      map: map,
      destination: GoTo.map, 
      startingPosition: Vector2(480, 700),
      selection: FloorList(goIn: true),
    ),
    
  ];
  print("SUCCESS");
 loopThroughPortals(facadePortals,map);
}
