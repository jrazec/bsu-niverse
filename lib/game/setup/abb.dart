import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

void setUpAbb(TiledComponent map) {
  List<Vector2> r = [Vector2(63, 163), Vector2(315, 163)];
  final List<Portal> abbPortals = [
    // CHJANGE THIS, IT IS THE OUT, refer on my vv magandang drawinfg
    Portal(
      map: map,
      destination: GoTo.map,
      startingPosition: Vector2(225, 1300),
      selection: FloorList(
        goOut: true
      ),
    ),

    // Floor 1
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor1: RoomList.d2,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(225, 1250),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor1: RoomList.d3,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(415, 1250),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor1: RoomList.d4,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(480, 1250),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor1: RoomList.d5,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(670, 1250),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor1: RoomList.d6,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(735, 1250),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor1: RoomList.d7,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(925, 1250),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor1: RoomList.d8,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(990, 1250),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor1: RoomList.d9,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(1180, 1250),
      ),
    ),

    // Floor 2
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d2,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(415, 993),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d3,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(480, 993),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d4,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(670, 993),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d5,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(735, 993),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d6,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(925, 993),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d7,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(990, 993),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d8,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(1180, 993),
      ),
    ),
    // Floor 3
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d2,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(225, 735),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d3,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(415, 735),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d4,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(480, 735),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d5,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(670, 735),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d6,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(735, 735),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d7,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(925, 735),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d8,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(990, 735),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d9,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(1180, 735),
      ),
    ),

    // Floor 4
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor4: RoomList.d2,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(225, 480),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor4: RoomList.d3,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(415, 480),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor4: RoomList.d4,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(480, 480),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor4: RoomList.d5,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(670, 480),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor4: RoomList.d6,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(735, 480),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor4: RoomList.d7,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(925, 480),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[0],
      selection: FloorList(
        floor4: RoomList.d8,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(990, 480),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomABB,
      startingPosition: r[1],
      selection: FloorList(
        floor4: RoomList.d9,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(1180, 480),
      ),
    ),

    // Floor 5 - only d4 with library destination
    Portal(
      map: map,
      destination: GoTo.library,
      startingPosition: r[1],
      selection: FloorList(
        floor5: RoomList.d4,
        leaveRoomMap: GoTo.abb,
        leaveRoomSpawnPoint: Vector2(670, 225),
      ),
    ),
  ];

  loopThroughPortals(abbPortals, map);
}
