import 'package:bsuniverse/game/components/joystick_component.dart';
import 'package:bsuniverse/game/components/player_component.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'scenes/bsu_map.dart';

class BSUniverseGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  bool initialized = false;
  late final CameraComponent cameraComponent;
  late final PlayerComponent player;
  late final CampusMap campusMap;
  late final JoystickComponent joystick;

  // The whole Map is 30 x 40 Tiles where each tile is 32x32.
  // Bedroom 3 x 8
  // CECS Flor 39x38
  final double mapHeight = 39 * 32;
  final double mapWidth = 38 * 32;

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

      campusMap = CampusMap(joystick);
      player = PlayerComponent(joystick);
      // player.debugMode = true;
      player.debugColor = Colors.white;


      world = campusMap;
      world.add(player);

      initialized = true;
      final camera = CameraComponent(world: world)
        ..viewfinder.zoom = 3.0
        ..viewfinder.anchor = Anchor.center
        ..follow(player..position = Vector2(60, 168));
      camera.viewport.add(joystick);
      camera.setBounds(
        Rectangle.fromCenter(
          center: Vector2.zero(),
          // Its zoomed in by 2,
          size: Vector2(mapWidth * 2, mapHeight * 2),
        ),
      );
      add(camera);
    }
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
