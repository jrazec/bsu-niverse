import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Joystickiverse extends SpriteComponent{
  final dynamic spriteImage;
  final dynamic backgroundImage;

  Joystickiverse(this.spriteImage, this.backgroundImage);

  JoystickComponent createJoystick() {
    return JoystickComponent(
      knob: SpriteComponent(
        sprite: spriteImage,
        size: Vector2.all(60),
      ),
      background: SpriteComponent(
        sprite: backgroundImage,
        size: Vector2.all(120),
      ),
      margin: EdgeInsets.only(left: 40, bottom: 40),
      priority: 100,
    );
  }
}
