import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class Joystickiverse extends SpriteComponent {
  final Sprite spriteIdle;
  final Sprite spriteActive;
  final Sprite backgroundImage;

  Joystickiverse(this.spriteIdle, this.spriteActive, this.backgroundImage);

  JoystickComponent createJoystick() {
    return _InteractiveJoystick(
      spriteIdle: spriteIdle,
      spriteActive: spriteActive,
      backgroundSprite: backgroundImage,
    );
  }
}

class _InteractiveJoystick extends JoystickComponent {
  final Sprite spriteIdle;
  final Sprite spriteActive;
  final Sprite backgroundSprite;
  bool isDragging = false;

  _InteractiveJoystick({
    required this.spriteIdle,
    required this.spriteActive,
    required this.backgroundSprite,
  }) : super(
          knob: SpriteComponent(
            sprite: spriteIdle,
            size: Vector2.all(100),
            
          ),
          background: SpriteComponent(
            sprite: backgroundSprite,
            size: Vector2.all(120),
          ),
          margin: const EdgeInsets.only(left: 60, bottom: 60),
          priority: 100,
        );

  @override
  void update(double dt) {
    super.update(dt);

    final isNowDragging = delta != Vector2.zero();

    if (isNowDragging != isDragging) {
      isDragging = isNowDragging;

      final knobSprite = (knob as SpriteComponent);
      knobSprite
        ..sprite = isDragging ? spriteActive : spriteIdle
        ..size = Vector2.all(isDragging ? 100 : 120); // Slight size change
    }
  }
}
