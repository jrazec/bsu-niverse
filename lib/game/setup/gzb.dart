import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

void setUpGzb(TiledComponent map) {
  // TODO: Implement GZB building portal setup
  // Add portals for GZB building
  List<Vector2> r = [Vector2(63, 163), Vector2(315, 163)];
  final List<Portal> gzbPortals = [
    Portal(
      map: map,
      destination: GoTo.map,
      startingPosition: Vector2(320, 1150),
      selection: FloorList(
        goOut: true
      ),
    ),

    // Floor 1
    Portal(
      map: map,
      destination: GoTo.canteen,
      startingPosition: r[0],
      selection: FloorList(
        floor1: RoomList.d1,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(320, 1150),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.canteen,
      startingPosition: r[1],
      selection: FloorList(
        floor1: RoomList.d2,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(510, 1150),
      ),
    ),


    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d1,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(320, 830),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d2,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(510, 830),
      ),
    ),

    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d3,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(575, 830),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d4,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(770, 830),
      ),
    ),

    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d5,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(835, 830),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d6,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(1025, 830),
      ),
    ),

    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d7,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(1090, 830),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d8,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(1280, 830),
      ),
    ),

    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d9,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(1345, 830),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d10,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(1535, 830),
      ),
    ),


    // 3rd Floor
    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d1,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(320, 510),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d2,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(510, 510),
      ),
    ),

    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d3,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(575, 510),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d4,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(770, 510),
      ),
    ),

    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d5,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(835, 510),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d6,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(1025, 510),
      ),
    ),

    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d7,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(1090, 510),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d8,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(1280, 510),
      ),
    ),

    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d9,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(1345, 510),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomGZB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d10,
        leaveRoomMap: GoTo.gzb,
        leaveRoomSpawnPoint: Vector2(1535, 510),
      ),
    ),
  ];

  loopThroughPortals(gzbPortals, map);
}
