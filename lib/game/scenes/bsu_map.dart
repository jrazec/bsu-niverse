import 'package:bsuniverse/game/components/player_component.dart';
import 'package:bsuniverse/game/components/wall_component.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';

class CampusMap extends World with HasCollisionDetection {
  late PlayerComponent player;
  final JoystickComponent joystickComponent;
  late SpriteSheet mapComponent;
  late Viewport viewport;
  late CameraComponent cameraComponent;
  late TiledComponent map;


  CampusMap(this.joystickComponent);

  Future<void> loadMap() async {
    // map = await TiledComponent.load(
    //   'bsu-map.tmx',
    //   Vector2(32, 32),
    //   priority: -1,
    // );
    map = await TiledComponent.load(
      'old_building.tmx',
      Vector2(32, 32),
      priority: -1,
    );
    add(map);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    joystickComponent.priority = 10;
    await loadMap();

    final collisions = map.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisions != null) {
      for (final obj in collisions.objects) {
        map.add(
          WallComponent(Vector2(obj.x, obj.y), Vector2(obj.width, obj.height))
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
