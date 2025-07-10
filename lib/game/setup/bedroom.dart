import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

// Create a List Here which will contain the
// Label or Name of the Room, Their Destination Room, Their Starting Vector Position
// List of portals: each map contains the room label, destination, and starting vector position

// PORTALS

void setUpBedroom(TiledComponent map) {
  // TODO: Implement LSB portal setup
  // Add portals for LSB building

  // Portal(floorList:FloorList.f1,roomList: RoomList.d1,position: Vector2(obj.x, obj.y), size: Vector2(obj.width, obj.height), destination: GoTo.gzb)
  // ..position for obj.x and obj.y; same with size
  final List<Portal> bedroomPortals = [
    Portal(
      map: map,
      destination: GoTo.map,
      startingPosition: Vector2(448, 800),
      selection: FloorList(goOut: true),
    ),
  ];

  
 loopThroughPortals(bedroomPortals,map);
}

