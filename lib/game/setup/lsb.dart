import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

// Create a List Here which will contain the
// Label or Name of the Room, Their Destination Room, Their Starting Vector Position
// List of portals: each map contains the room label, destination, and starting vector position

// PORTALS

void setUpLsb(TiledComponent map) {
  // TODO: Implement LSB portal setup
  // Add portals for LSB building

  // Portal(floorList:FloorList.f1,roomList: RoomList.d1,position: Vector2(obj.x, obj.y), size: Vector2(obj.width, obj.height), destination: GoTo.gzb)
  // ..position for obj.x and obj.y; same with size
  final List<Portal> lsbPortals = [
    // GO TO MAP: OUT
    Portal(
      map: map,
      destination: GoTo.map,
      startingPosition: Vector2(387, 481),
      selection: FloorList(goOut: true),
    ),
    Portal(
      map: map,
      destination: GoTo.map,
      startingPosition: Vector2(387, 672),
      selection: FloorList(goIn: true),
    ),

    // CHEMLAB
    Portal(
      map: map,
      destination: GoTo.genRoomLSB,
      startingPosition: Vector2(74, 163),
      selection: FloorList(
        floor5: RoomList.d2,
        leaveRoomSpawnPoint: Vector2(255, 95), // When leaving room, spawn here
        leaveRoomMap: GoTo.lsb, // Return to LSB map
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomLSB,
      startingPosition: Vector2(315, 163),
      selection: FloorList(
        floor5: RoomList.d3,
        leaveRoomSpawnPoint: Vector2(445, 95), // When leaving room, spawn here
        leaveRoomMap: GoTo.lsb, // Return to LSB map
      ),
    ),

    // COMLAB 1
    Portal(
      map: map,
      destination: GoTo.comLab502LSB,
      startingPosition: Vector2(74, 163),
      selection: FloorList(
        floor5: RoomList.d4,
        leaveRoomSpawnPoint: Vector2(570, 95), // When leaving room, spawn here
        leaveRoomMap: GoTo.lsb, // Return to LSB map
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.comLab502LSB,
      startingPosition: Vector2(315, 163),
      selection: FloorList(
        floor5: RoomList.d5,
        leaveRoomSpawnPoint: Vector2(705,95), // When leaving room, spawn here
        leaveRoomMap: GoTo.lsb, // Return to LSB map
      ),
    ),

    // COMLAB2
    Portal(
      map: map,
      destination: GoTo.comLab503LSB,
      startingPosition: Vector2(74, 163),
      selection: FloorList(
        floor5: RoomList.d6,
        leaveRoomSpawnPoint: Vector2(770, 95), // When leaving room, spawn here
        leaveRoomMap: GoTo.lsb, // Return to LSB map
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.comLab503LSB,
      startingPosition: Vector2(315, 163),
      selection: FloorList(
        floor5: RoomList.d7,
        leaveRoomSpawnPoint: Vector2(960,95), // When leaving room, spawn here
        leaveRoomMap: GoTo.lsb, // Return to LSB map
      ),
    ),
  ];

  loopThroughPortals(lsbPortals, map);
}
