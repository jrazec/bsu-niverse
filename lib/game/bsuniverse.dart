import 'package:bsuniverse/game/components/joystick_component.dart';
import 'package:bsuniverse/game/components/player_component.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/widgets.dart';
import 'package:flame/experimental.dart';

import 'scenes/bsu_map.dart';

class BSUniverseGame extends FlameGame with HasCollisionDetection {
  bool initialized = false;
  late final CameraComponent cameraComponent;
  late final PlayerComponent player;
  late final RoomScene roomScene;
  late final JoystickComponent joystick;

  // The whole Map is 30 x 40 Tiles where each tile is 32x32.
  final double mapHeight = 30 * 32;
  final double mapWidth = 40 * 32;

  @override
  void onGameResize(Vector2 canvasSize) async {
    super.onGameResize(canvasSize);
    if (!initialized) {
      // TO CREATE A COMPONENT PA THIS tinatamad pa
      joystick = Joystickiverse(await loadSprite('yey.png'),await loadSprite('bsuniverse_logo.png'),await loadSprite('joyv8.png')).createJoystick();
      
      roomScene = RoomScene(joystick);
      player = PlayerComponent(joystick);
      
    

      world = roomScene;
      world.add(player);

      initialized = true;
      final camera = CameraComponent(world: world)
        ..viewfinder.zoom = 3.0
        ..viewfinder.anchor = Anchor.center
        ..follow(player
        ..position=Vector2(296, 824));
      camera.viewport.add(joystick);
      camera.setBounds(
        Rectangle.fromCenter(
          center: Vector2.zero(),
          // Its zoomed in by 2,
          size: Vector2(mapWidth*2, mapHeight*2),
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
