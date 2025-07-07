// import 'package:bsuniverse/game/components/wall_component.dart';
// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flame_tiled/flame_tiled.dart';
// import 'package:flutter/material.dart';

// // Scene Configuration
// final Map<String, Map<String, dynamic>> tmxConfig = {
//   "bedroom": {"image": "Bedroom.tmx", "w": 10, "h": 10},
//   "mapBsu": {"image": "bsu-map.tmx", "w": 38, "h": 39},
//   "lsb": {"image": "cecs.tmx", "w": 10, "h": 10},
//   "vmb": {"image": "hebuilding.tmx", "w": 10, "h": 10},
//   "aab": {"image": "old_building.tmx", "w": 10, "h": 10},
//   "gzb": {"image": "gzbuilding.tmx", "w": 57, "h": 39},
//   "multimedia": {"image": "multimedia.tmx", "w": 10, "h": 10},
//   "lsbRoom": {"image": "classroom_cecs-heb.tmx", "w": 10, "h": 10},
//   "vmbRoom": {"image": "classroom_cecs-heb.tmx", "w": 10, "h": 10},
//   "aabRoom": {"image": "classroom_cecs-heb.tmx", "w": 10, "h": 10},
//   "gzbRoom": {"image": "classroom_cecs-heb.tmx", "w": 10, "h": 10},
//   "library": {"image": "classroom_cecs-heb.tmx", "w": 10, "h": 10},
//   "canteen": {"image": "classroom_cecs-heb.tmx", "w": 10, "h": 10},
// };

// enum FloorList { f1, f2, f3, f4, f5 }

// enum RoomList { d1, d2, d3, d4, d5, d6, d7, d8, d9, d10 }

// enum GoTo { lsb, vmb, gzb, abb, map, gymn }

// enum GoToRoom {
//   genRoomLSB,
//   comLab502LSB,
//   comLab503LSB,
//   genRoomVMB,
//   comLab201VMB,
//   comLab202VMB,
//   multimedia,
//   gymnOpenArea,
//   genRoomGZB,
//   canteen,
//   genRoomABB,
//   library,
// }

// // Portal Component that handles scene transitions
// class Portal extends RectangleComponent with HasGameReference {
//   final String destination;
//   final Function(String) onEnter;

//   Portal({
//     required Vector2 position,
//     required Vector2 size,
//     required this.destination,
//     required this.onEnter,
//   }) : super(
//           position: position,
//           size: size,
//           paint: Paint()..color = Colors.transparent,
//         );

// }

// // Popup Component that handles NPC interactions
// class Popup extends RectangleComponent with HasGameReference {
//   final String location;
//   final String dialogue;
//   final String npcImage;
//   final VoidCallback onInteract;

//   Popup({
//     required Vector2 position,
//     required Vector2 size,
//     required this.location,
//     required this.dialogue,
//     required this.npcImage,
//     required this.onInteract,
//   }) : super(
//           position: position,
//           size: size,
//           paint: Paint()..color = Colors.blue.shade300,
//         );

//   @override

// }

// class Scene extends World with HasCollisionDetection {
//   final JoystickComponent joystickComponent;
//   TiledComponent? currentMap;
//   late String newScene;
//   Floor? currentFloor;
  

//   Scene(this.joystickComponent);

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();
//     await loadInitialScene();
//   }

//   Future<void> loadInitialScene() async {
//     // Load the initial BSU map
//     await changeScene("lsb",Vector2(32,100));
    
//   }

//   Future<void> changeScene(String sceneName, Vector2 playerSpawnPosition) async {
//     newScene = getFloor(sceneName);
//     newScene
//   }




// }



// class Floor {
//   final List<Map<FloorList, Map<RoomList, GoToRoom>>> activate;
//   final RoomList out;

//   Floor({required this.activate, required this.out, Popup? popUp});
//   // Will Setup here the scenes

//   /*

//         activate: [ // rooms are activated here
//           {  
//            f1: {
//                  r1: goToRoomCECS
//                },    
//            }
//         ],
//         popUp: { // Will just use 1 popup per floor, only dialogues are avail
//           npcImage: "",
//           dialogue: 
//         },
//         out:d2,
//   */
//   List getActivatedPopUp() {
//     // Get the PopUp Component.
//     // Check the Tmx file and get their x and y what PopUps are activated each floor
//     // 
//     return [];
//   }

//   List getActivatedPortals() {
//     // Get the PopUp Component.
//     // Check the Tmx file and get their x and y what PopUps are activated each floor
//     // In, d1-d10. Also check it by floor. In looping, for each floor e.g. f1, iterate it through 1st floor in the tmx 
//     // just make 5 forloops for each building
//     return [];
//   }
// }
