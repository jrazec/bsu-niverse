import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/components/player_component.dart';
import 'package:bsuniverse/game/components/wall_component.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

class RoomScene extends FlameGame with HasCollisionDetection, HasGameReference<BSUniverseGame> {
  late PlayerComponent player;
  final JoystickComponent joystickComponent;
  late SpriteSheet mapComponent;
  late Viewport viewport;
  late CameraComponent cameraComponent;

  RoomScene(this.joystickComponent);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    joystickComponent.priority = 10;

    // Load the Tiled map
    final map = await TiledComponent.load(
      'bsu-map.tmx',
      Vector2(32, 32),
      priority: -1,
    );
    map.anchor = Anchor.center;
    add(map);

    final collisions = map.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisions != null) {
      for (final obj in collisions.objects) {
        map.add(
          WallComponent(Vector2(obj.x, obj.y), Vector2(obj.width, obj.height))
            ..debugMode = true,
        );
      }
    }
  }

  @override
  void onGameResize(Vector2 canvasSize) {
    super.onGameResize(canvasSize);
    // // Resize background to match screen size
    // if (background != null) {
    //   background.size = canvasSize;
    // }
  }

  @override
  void update(double dt) {
    super.update(dt);
  }
}
