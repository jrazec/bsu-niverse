import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

void setUpMapBsu(TiledComponent map) {
  // TODO: Implement MapBsu portal setup
  // Add portals for main campus map
  final List<Portal> mapPortals = [
    // GOING FACADE: IN
    Portal(
      map: map,
      destination: GoTo.facade, //facade
      startingPosition: Vector2(320, 225),
      selection: FloorList(goIn: true),
    ),

    // GOING FACADE: OUT
    Portal(
      map: map,
      destination: GoTo.facade, //facade
      startingPosition: Vector2(320, 136),
      selection: FloorList(goOut: true),
    ),

    // BUILDINGS

    // LSB
    Portal(
      map: map,
      destination: GoTo.lsb,
      startingPosition: Vector2(267, 1144),
      selection: FloorList(floor1: RoomList.d1),
    ),
    Portal(
      map: map,
      destination: GoTo.lsb,
      startingPosition: Vector2(1167, 1144),
      selection: FloorList(floor1: RoomList.d2),
    ),

    // VMB
    Portal(
      map: map,
      destination: GoTo.vmb,
      startingPosition: Vector2(960, 1095),
      selection: FloorList(floor1: RoomList.d8),
    ),
    Portal(
      map: map,
      destination: GoTo.vmb,
      startingPosition: Vector2(960, 1120),
      selection: FloorList(floor1: RoomList.d3),
    ),

    // GZB
    Portal(
      map: map,
      destination: GoTo.gzb,
      startingPosition: Vector2(267, 1144),
      selection: FloorList(floor1: RoomList.d4),
    ),
    Portal(
      map: map,
      destination: GoTo.gzb,
      startingPosition: Vector2(267, 1144),
      selection: FloorList(floor1: RoomList.d5),
    ),
    
    // GYM
    Portal(
      map: map,
      destination: GoTo.gymn,
      startingPosition: Vector2(74, 163),
      selection: FloorList(floor1: RoomList.d6,leaveRoomMap: GoTo.map,leaveRoomSpawnPoint: Vector2(665, 482)),
    ),
    
    // ABB
    Portal(
      map: map,
      destination: GoTo.abb,
      startingPosition: Vector2(190, 1315),
      selection: FloorList(floor1: RoomList.d7),
    ),
  ];

  loopThroughPortals(mapPortals, map);
}
