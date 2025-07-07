import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';


enum ColType {wall,portal,popup}
class Collision extends PositionComponent with CollisionCallbacks, HasGameReference<BSUniverseGame> {
  final ColType type;
  final GoTo sceneName;
  Collision(Vector2 position, Vector2 size, this.type, this.sceneName)
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox()
    ..collisionType = CollisionType.passive
    // ..debugMode = true
    ..debugColor =  Color.fromARGB(255, 0, 234, 255)
    );
  }

  @override
  Future<void> onCollision(Set<Vector2> intersectionPoints, PositionComponent other) async {
    super.onCollision(intersectionPoints, other);
    switch(type) {
      case ColType.wall:
        break;
      case ColType.portal:
        await game.changeScene(sceneName);
        break;
      case ColType.popup:
        break;
    }
  }

}
