import 'dart:ui';

import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

// Create a List Here which will contain the
// Label or Name of the Room, Their Destination Room, Their Starting Vector Position
// List of portals: each map contains the room label, destination, and starting vector position

// PORTALS

void setUpBedroom(TiledComponent map) {
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

  final closet = map.tileMap.getLayer<ObjectGroup>('cabinet');
  map.add(
    ClosetPops(
      map: map)..position = Vector2(closet!.objects.first.x,closet.objects.first.y)
      ..size = Vector2(closet.objects.first.width, closet.objects.first.height)
  );

  loopThroughPortals(bedroomPortals, map);
}

class ClosetPops extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BSUniverseGame> {
  final TiledComponent map;
  ClosetPops({
    required this.map,
  }) : super(paint: Paint()..color = const Color.fromARGB(255, 0, 0, 0));

  @override
  Future<void> onLoad() async {
    add(
      RectangleHitbox()
     
        ..collisionType = CollisionType.passive
        // ..debugMode = true
        ..debugColor = Color.fromARGB(255, 0, 234, 255),
    );
  }

  // void getNameTag
  // use SWITCH CASE

  @override
  Future<void> onCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) async {
    super.onCollision(intersectionPoints, other);
    game.showClosetOverlay();
  }
}
