import 'package:bsuniverse/game/components/joystick_component.dart';
import 'package:bsuniverse/game/components/player_component.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/experimental.dart';

import 'scenes/bsu_map.dart';

class BSUniverseGame extends FlameGame with HasCollisionDetection {
  bool initialized = false;
  late final CameraComponent cameraComponent;
  late final PlayerComponent player;
  late final RoomScene roomScene;
  late final JoystickComponent joystick;

  // The whole Map is 30 x 40 Tiles where each tile is 32x32.
  final int mapHeight = 30 * 32;
  final int mapWidth = 40 * 32;

  @override
  void onGameResize(Vector2 canvasSize) async {
    super.onGameResize(canvasSize);
    if (!initialized) {
      // TO CREATE A COMPONENT PA THIS tinatamad pa
      joystick = Joystickiverse(await loadSprite('pokebol.png'),await loadSprite('joyv8.png')).createJoystick();
      
      roomScene = RoomScene(joystick);
      player = PlayerComponent(joystick);
      
      player.debugMode = true;
      roomScene.debugMode = true;

      world.add(roomScene);
      world.add(player);

      initialized = true;
      final camera = CameraComponent(world: world)
        ..viewfinder.zoom = 2.0
        ..viewfinder.anchor = Anchor.center
        ..follow(player);
      camera.viewport.add(joystick);
      camera.setBounds(
        Rectangle.fromCenter(
          center: Vector2.zero(),
          // Its zoomed in by 2,
          size: Vector2(300, 480),
        ),
      );


      add(camera);
    }
  }

  @override
  void update(double dt) async {
    super.update(dt);
    if(initialized) {
      camera.viewfinder.position.round();
      player.setDirection(joystick.relativeDelta);
      camera.renderContext;
    }

  }
}
