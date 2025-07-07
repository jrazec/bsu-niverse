import 'package:bsuniverse/game/components/joystick_component.dart';
import 'package:bsuniverse/game/components/player_component.dart';
import 'package:bsuniverse/game/components/button_components.dart';
import 'package:bsuniverse/game/components/mute_button_component.dart';
import 'package:bsuniverse/game/components/wall_component.dart';
import 'package:bsuniverse/game/scenes/scene.dart';
import 'package:bsuniverse/game/sound_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

// Scene Configuration
final Map<String, Map<String, dynamic>> tmxConfig = {
  "bedroom": {"image": "Bedroom.tmx", "zoom": 3, "w": 3, "h": 8},
  "mapBsu": {"image": "bsu-map.tmx", "zoom": 3, "w": 30, "h": 40},
  "lsb": {"image": "cecs.tmx", "zoom": 3, "w": 57, "h": 39},
  "vmb": {"image": "hebuilding.tmx", "zoom": 3, "w": 10, "h": 10},
  "aab": {"image": "old_building.tmx", "zoom": 3, "w": 10, "h": 10},
  "gzb": {"image": "gzbuilding.tmx", "zoom": 3, "w": 57, "h": 39},
  "gymn": {"image": "gzbuilding.tmx", "zoom": 3, "w": 57, "h": 39},
  "gymnOpenArea": {"image": "gzbuilding.tmx", "zoom": 3, "w": 57, "h": 39},
  "multimedia": {"image": "multimedia.tmx", "zoom": 3, "w": 10, "h": 10},
  "lsbRoom": {"image": "classroom_cecs-heb.tmx", "zoom": 3, "w": 10, "h": 10},
  "comLab502Lsb": {
    "image": "classroom_cecs-heb.tmx",
    "zoom": 3,
    "w": 10,
    "h": 10,
  },
  "comLab503Lsb": {
    "image": "classroom_cecs-heb.tmx",
    "zoom": 3,
    "w": 10,
    "h": 10,
  },
  "comLab301Vmb": {
    "image": "classroom_cecs-heb.tmx",
    "zoom": 3,
    "w": 10,
    "h": 10,
  },
  "comLab302Vmb": {
    "image": "classroom_cecs-heb.tmx",
    "zoom": 3,
    "w": 10,
    "h": 10,
  },
  "vmbRoom": {"image": "classroom_cecs-heb.tmx", "zoom": 3, "w": 13, "h": 9},
  "aabRoom": {"image": "classroom_cecs-heb.tmx", "zoom": 3, "w": 10, "h": 10},
  "gzbRoom": {"image": "classroom_cecs-heb.tmx", "zoom": 3, "w": 10, "h": 10},
  "library": {"image": "classroom_cecs-heb.tmx", "zoom": 3, "w": 10, "h": 10},
  "canteen": {"image": "classroom_cecs-heb.tmx", "zoom": 3, "w": 10, "h": 10},
};

enum FloorList { f1, f2, f3, f4, f5 }

enum RoomList { d1, d2, d3, d4, d5, d6, d7, d8, d9, d10 }

enum GoTo {
  lsb,
  vmb,
  gzb,
  abb,
  map,
  gymn,
  genRoomLSB,
  comLab502LSB,
  comLab503LSB,
  genRoomVMB,
  comLab301VMB,
  comLab302VMB,
  multimedia,
  gymnOpenArea,
  genRoomGZB,
  canteen,
  genRoomABB,
  library,
}

// ---------------------MAIN GAME-----------------------

class BSUniverseGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  bool initialized = false;
  late final CameraComponent cameraComponent;
  late final PlayerComponent player;
  late final JoystickComponent joystick;
  late final GameSoundManager soundManager;
   Scene? currentScene; 
   CameraComponent? currentCamera;

  // Button components
  late final StatusButtonComponent buttonA;
  late final StatusButtonComponent buttonB;
  late final StatusButtonComponent buttonC;
  late final StatusButtonComponent buttonD;
  late final MuteButtonComponent muteButton;

  // The whole Map is 30 x 40 Tiles where each tile is 32x32.
  // Bedroom 3 x 8
  // CECS Flor 39x38
  // GZB 57 x 39
  late double height = 39;
  late double width = 38;
  late double mapHeight = height * 32;
  late double mapWidth = width * 32;
  late double zoomValue = 3.0;

  @override
  void onGameResize(Vector2 canvasSize) async {
    super.onGameResize(canvasSize);
    if (!initialized) {
      // TO CREATE A COMPONENT PA THIS tinatamad pa
      joystick = Joystickiverse(
        await loadSprite('yey.png'),
        await loadSprite('bsuniverse_logo.png'),
        await loadSprite('joyv8.png'),
      ).createJoystick();
      // Initialize buttons with responsive positioning
      final buttonSize = StatusButtonComponent.getResponsiveButtonSize(
        canvasSize,
      );

      buttonA = StatusButtonComponent(
        label: 'A',
        color: Colors.red, // This will be overridden by _getButtonColor()
        status: false,
        cooldownMs: 1000, // 1 second cooldown for run
        size: buttonSize,
        position: StatusButtonComponent.getButtonPosition(canvasSize, 0),
      );

      buttonB = StatusButtonComponent(
        label: 'B',
        color: Colors.blue, // This will be overridden by _getButtonColor()
        status: false,
        cooldownMs: 2000, // 2 second cooldown for titan
        size: buttonSize,
        position: StatusButtonComponent.getButtonPosition(canvasSize, 1),
      );

      buttonC = StatusButtonComponent(
        label: 'C',
        color: Colors.green, // This will be overridden by _getButtonColor()
        status: false,
        cooldownMs: 3000, // 3 second cooldown for no limits
        size: buttonSize,
        position: StatusButtonComponent.getButtonPosition(canvasSize, 2),
      );

      buttonD = StatusButtonComponent(
        label: 'D',
        color: Colors.orange, // This will be overridden by _getButtonColor()
        status: false,
        cooldownMs: 0, // No cooldown for D button (it's hold/release)
        size: buttonSize,
        position: StatusButtonComponent.getButtonPosition(canvasSize, 3),
      );

      player = PlayerComponent(joystick, [buttonA, buttonB, buttonC, buttonD]);

      // Initialize sound manager
      soundManager = GameSoundManager();
      await soundManager.initialize();

      // Start background music
      await soundManager.playBackgroundMusic();

      // Connect buttons to player after player is created
      buttonA.onPressed = player.handleButtonPress;
      buttonB.onPressed = player.handleButtonPress;
      buttonC.onPressed = player.handleButtonPress;
      buttonD.onPressed = player.handleButtonPress;

      // Connect D button joystick callbacks
      buttonD.onDragUpdateCallback = player.handleDButtonDrag;
      buttonD.onDragEndCallback = player.handleDButtonRelease;

      // Create mute button
      final muteButtonSize = Vector2.all(50);
      muteButton = MuteButtonComponent(
        position: MuteButtonComponent.getTopRightPosition(
          canvasSize,
          muteButtonSize,
        ),
        size: muteButtonSize,
      );

      // player.debugMode = true;
      player.debugColor = Colors.white;
      player.debugMode = true;

      debugMode = true;
      await changeScene(GoTo.lsb);



      // Add UI components

      // Only add the scene returned by changeScene

      // Set up camera for the new scene

      initialized = true;
    } else {
      // Update button positions on resize
      updateButtonPositions(canvasSize);
    }
  }

  Future<void> changeScene(GoTo sceneName) async {
    // Remove current world/scene if any
    if (currentScene != null) {
      remove(currentCamera!);
      remove(currentScene!); // Remove the entire old Scene (World) component
      currentScene = null; // Clear the reference
      currentCamera = null;
    }

    Scene newScene = Scene(sceneName: sceneName);
    await newScene.initialize();
    print(newScene.sceneMap);
    currentScene = newScene;
      await add(currentScene!);
      await currentScene?.add(player);
    currentCamera = CameraComponent(world: currentScene)
        ..viewfinder.zoom = 3.0
        ..viewfinder.anchor = Anchor.center
        ..follow(player..position = Vector2(60, 168));
      currentCamera?.viewport.add(joystick);
      currentCamera?.viewport.add(buttonD);
      currentCamera?.viewport.add(buttonC);
      currentCamera?.viewport.add(buttonB);
      currentCamera?.viewport.add(buttonA);
      currentCamera?.viewport.add(muteButton);
      currentCamera?.setBounds(
        Rectangle.fromCenter(
          center: Vector2.zero(),
          // Its zoomed in by 2,
          size: Vector2(
             mapWidth * 2.0,
             mapHeight * 2.0,
          ),
        ),
      );
      await add(currentCamera!);
  }

  Future<void> loadInitialScene() async {
    // Load the initial BSU map
    await changeScene(GoTo.map);
  }

  // Method to update button positions on screen resize
  void updateButtonPositions(Vector2 canvasSize) {
    if (!initialized) return;

    final buttonSize = StatusButtonComponent.getResponsiveButtonSize(
      canvasSize,
    );

    buttonA.size = buttonSize;
    buttonA.position = StatusButtonComponent.getButtonPosition(canvasSize, 0);

    buttonB.size = buttonSize;
    buttonB.position = StatusButtonComponent.getButtonPosition(canvasSize, 1);

    buttonC.size = buttonSize;
    buttonC.position = StatusButtonComponent.getButtonPosition(canvasSize, 2);

    buttonD.size = buttonSize;
    buttonD.position = StatusButtonComponent.getButtonPosition(canvasSize, 3);

    // Update mute button position
    final muteButtonSize = Vector2.all(50);
    muteButton.position = MuteButtonComponent.getTopRightPosition(
      canvasSize,
      muteButtonSize,
    );
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if (initialized) {
      camera.viewfinder.position.round();
      player.setDirection(joystick.relativeDelta);
      camera.renderContext;
    }
  }
}

// Portal Component that handles scene transitions
class Portal extends RectangleComponent with HasGameReference {
  final GoTo destination;

  Portal({
    required Vector2 position,
    required Vector2 size,
    required this.destination,
  }) : super(
         position: position,
         size: size,
         paint: Paint()..color = Colors.transparent,
       );
}

// Popup Component that handles NPC interactions
class Popup extends RectangleComponent with HasGameReference {
  final String location;
  final String dialogue;
  final String image;
  final VoidCallback onInteract;

  Popup({
    required Vector2 position,
    required Vector2 size,
    required this.location,
    required this.dialogue,
    required this.image,
    required this.onInteract,
  }) : super(
         position: position,
         size: size,
         paint: Paint()..color = Colors.blue.shade300,
       );
}

class Scene extends World {
  final GoTo sceneName;
  TiledComponent? sceneMap;
  Vector2? playerSpawnPosition;
  double? zoom;
  int? width;
  int? height;
  Scene({required this.sceneName});

  Future<void> initialize() async {
    switch (sceneName) {
      case GoTo.map:
        sceneMap = await _setMap("mapBsu");
        break;
      case GoTo.lsb:
        sceneMap = await _setMap("lsb");
        break;
      case GoTo.vmb:
        sceneMap = await _setMap("vmb");
        break;
      case GoTo.gzb:
        sceneMap = await _setMap("gzb");
        break;
      case GoTo.gymn:
        sceneMap = await _setMap("gymn");
        break;
      case GoTo.genRoomLSB:
        sceneMap = await _setMap("lsbRoom");
        break;
      case GoTo.comLab502LSB:
        sceneMap = await _setMap("comLab502Lsb");
        break;
      case GoTo.comLab503LSB:
        sceneMap = await _setMap("comLab503Lsb");
        break;
      case GoTo.genRoomVMB:
        sceneMap = await _setMap("vmbRoom");
        break;
      case GoTo.comLab301VMB:
        sceneMap = await _setMap("comLab301Vmb");
        break;
      case GoTo.comLab302VMB:
        sceneMap = await _setMap("comLab302Vmb");
        break;
      case GoTo.multimedia:
        sceneMap = await _setMap("multimedia");
        break;
      case GoTo.gymnOpenArea:
        sceneMap = await _setMap("gymnOpenArea");
        break;
      case GoTo.genRoomGZB:
        sceneMap = await _setMap("gzbRoom");
        break;
      case GoTo.canteen:
        sceneMap = await _setMap("canteen");
        break;
      case GoTo.genRoomABB:
        sceneMap = await _setMap("abbRoom");
        break;
      case GoTo.library:
        sceneMap = await _setMap("libraryRoom");
        break;
      default:
        sceneMap = await _setMap("lsb");
        break;
    }
    print(sceneName);
    add(sceneMap as Component);
  }

  Future<TiledComponent> _setMap(String map) async {
    TiledComponent mapTiled = await TiledComponent.load(
      tmxConfig[map]?["image"] ?? "",
      Vector2.all(32),
      priority: -1,
    );
    _setZoomCam(
      tmxConfig[map]?["zoom"],
      tmxConfig[map]?["w"],
      tmxConfig[map]?["h"],
    );
    _setUpCollisions(mapTiled);
    _setUpPortals(mapTiled);
    _setUpPopups(mapTiled);
    return mapTiled;
  }

  Future<void> _setZoomCam(double z, double w, double h) async {
    zoom = z;
    width = w?.toInt();
    height = h?.toInt();
    print(zoom);
    print(width);
    print(height);
  }

  Future<void> _setUpCollisions(TiledComponent map) async {
    final collisions = map.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisions != null) {
      for (final obj in collisions.objects) {
        map.add(
          Collision(Vector2(obj.x, obj.y), Vector2(obj.width, obj.height),ColType.wall,GoTo.gzb),
        );
      }
    }
  }

  Future<void> _setUpPortals(TiledComponent map) async {
    // Handles RoomPortals group folder, with subgroups 1st, 2nd, etc.
    final roomPortalsGroup = map.tileMap.getLayer<Group>('RoomPortals');
    if (roomPortalsGroup != null) {
      for (final subGroup in roomPortalsGroup.layers.whereType<ObjectGroup>()) {
        for (final obj in subGroup.objects) {
          // You may want to parse destination from obj.properties if available
          map.add(
            Collision(
              Vector2(obj.x, obj.y),
              Vector2(obj.width, obj.height), 
              ColType.portal,GoTo.genRoomVMB
            ),
          );
        }
      }
    }
  }

  Future<void> _setUpPopups(TiledComponent map) async {
    // Handles Popups group folder, with subgroups 1st, 2nd, etc.
    final popupsGroup = map.tileMap.getLayer<Group>('Popups');
    if (popupsGroup != null) {
      for (final subGroup in popupsGroup.layers.whereType<ObjectGroup>()) {
        for (final obj in subGroup.objects) {
          // You may want to parse popup data from obj.properties if available
          map.add(
            Collision(
              Vector2(obj.x, obj.y),
              Vector2(obj.width, obj.height),
              ColType.wall,GoTo.gzb
            ),
          );
        }
      }
    }
  }
}
