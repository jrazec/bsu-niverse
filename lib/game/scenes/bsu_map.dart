// import 'package:bsuniverse/game/components/player_component.dart';
// import 'package:bsuniverse/game/components/wall_component.dart';
// import 'package:bsuniverse/game/scenes/scene.dart';
// import 'package:flame/components.dart';
// import 'package:flame/game.dart';
// import 'package:flame/sprite.dart';
// import 'package:flame_tiled/flame_tiled.dart';
// import 'package:flutter/material.dart';

// class CampusMap extends World with HasCollisionDetection {
//   // Pullout Floors.
//   late Floor floors;
//   late List popups;
//   late List portals; 
//   late int height;
//   late int width;
//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();
//     floors = Floor(activate: [],out: RoomList.d1);
//   }

//   @override
//   void onGameResize(Vector2 canvasSize) {
//     super.onGameResize(canvasSize);
//     // // Resize background to match screen size
//     // if (background != null) {
//     //   background.size = canvasSize;
//     // }
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);
//   }
// }
