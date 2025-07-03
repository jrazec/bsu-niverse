import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class WallComponent extends PositionComponent with CollisionCallbacks {
  WallComponent(Vector2 position, Vector2 size)
      : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    add(RectangleHitbox()
    ..collisionType = CollisionType.passive
    // ..debugMode = true
    ..debugColor =  Color.fromARGB(255, 0, 234, 255)
    );
  }
}
