import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/setup/get_arguments.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

void setUpVmb(TiledComponent map) {
  // TODO: Implement VMB building portal setup
  List<Vector2> r = [ Vector2(63, 163), Vector2(315, 163)];
  List<Portal> vmbPortals = [
    // GO TO MAP
    Portal(
      map: map,
      destination: GoTo.map,
      startingPosition: Vector2(480, 415),
      selection: FloorList(goOut: true),
    ),
    // GO TO MAP : NEAR GZB
    Portal(
      map: map,
      destination: GoTo.map,
      startingPosition: Vector2(512, 220),
      selection: FloorList(goIn: true),
    ),

    // 1st FLOOR ROOMS
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor1: RoomList.d1,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(285, 1120),
      ),
    ),
     Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor1: RoomList.d2,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(285, 1120),
      ),
    ),

    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor1: RoomList.d3,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(480, 1120),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor1: RoomList.d4,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(545, 1120),
      ),
    ),

    // GSO
     Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor1: RoomList.d5,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(285, 1120),
      ),
    ),

      Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor1: RoomList.d6,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1055, 1120),
      ),
    ),
     Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor1: RoomList.d7,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1245, 1120),
      ),
    ),

    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor1: RoomList.d3,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1315, 1120),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor1: RoomList.d4,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1505, 1120),
      ),
    ),

    // 2nd FLOOR ROOMS
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d1,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(285, 865),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d2,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(480, 865),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d3,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(545, 865),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d4,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(735, 865),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d5,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(800, 865),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d6,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(900, 865),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d7,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1055, 865),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d8,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1245, 865),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor2: RoomList.d9,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1315, 865),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor2: RoomList.d10,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1505, 865),
      ),
    ),

    // 3rd FLOOR ROOMS
    Portal(
      map: map,
      destination: GoTo.comLab301VMB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d1,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(285, 610),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.comLab301VMB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d2,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(480, 610),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.comLab302VMB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d3,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(545, 610),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.comLab302VMB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d4,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(735, 610),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d5,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(800, 610),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d6,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(900, 610),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d7,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1055, 610),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d8,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1245, 610),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor3: RoomList.d9,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1315, 610),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor3: RoomList.d10,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1505, 610),
      ),
    ),

    // 4th FLOOR ROOMS
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor4: RoomList.d1,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(285, 350),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor4: RoomList.d2,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(480, 350),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor4: RoomList.d3,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(545, 350),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor4: RoomList.d4,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(735, 350),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor4: RoomList.d5,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(800, 350),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor4: RoomList.d6,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(900, 350),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor4: RoomList.d7,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1055, 350),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor4: RoomList.d8,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1245, 350),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor4: RoomList.d9,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1315, 350),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor4: RoomList.d10,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1505, 350),
      ),
    ),

    // 5th FLOOR ROOMS
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor5: RoomList.d1,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(285, 95),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor5: RoomList.d2,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(480, 95),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor5: RoomList.d3,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(545, 95),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor5: RoomList.d4,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(735, 95),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor5: RoomList.d5,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(800, 95),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor5: RoomList.d6,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(900, 95),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[0],
      selection: FloorList(
        floor5: RoomList.d7,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1055, 95),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.genRoomVMB,
      startingPosition: r[1],
      selection: FloorList(
        floor5: RoomList.d8,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1245, 95),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.multimedia,
      startingPosition: Vector2(100, 163),
      selection: FloorList(
        floor5: RoomList.d9,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1315, 95),
      ),
    ),
    Portal(
      map: map,
      destination: GoTo.multimedia,
      startingPosition: Vector2(270, 163),
      selection: FloorList(
        floor5: RoomList.d10,
        leaveRoomMap: GoTo.vmb,
        leaveRoomSpawnPoint: Vector2(1505, 95),
      ),
    ),

    
  ];

  loopThroughPortals(vmbPortals, map);
}
