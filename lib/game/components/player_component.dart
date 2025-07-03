import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/components/wall_component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlayerComponent extends SpriteAnimationComponent
    with CollisionCallbacks, KeyboardHandler, HasGameReference<BSUniverseGame> {
  final JoystickComponent joystick;
  Vector2 moveDirection = Vector2.zero();
  double moveSpeed = 50;

  late final SpriteAnimation leftAnimation;
  late final SpriteAnimation rightAnimation;
  late final SpriteAnimation upAnimation;
  late final SpriteAnimation downAnimation;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  late final SpriteAnimation titanAnimation;
  late final SpriteAnimation flickerAnimation;
  late final SpriteAnimation noLimitsAnimation;

  bool _loadedAnimations = false;

  PlayerComponent(this.joystick) : super(size: Vector2.all(32.0));

  @override
  Future<void> onLoad() async {
    if (_loadedAnimations) return;

    // SPRITESHEETS TO USE
    final spriteSheet = await game.images.load('boy_pe.png');
    final run = await game.images.load('run.png');
    final titan = await game.images.load('titan.png');
    final flicker = await game.images.load('run.png');
    final noLimits = await game.images.load('overlay.png');

    // DECLARING ITS SIZES ET AL
    final spriteSheetData = SpriteSheet(
      image: spriteSheet,
      srcSize: Vector2(32, 32),
    );

    final runData = SpriteSheet(image: run, srcSize: Vector2(64, 64));

    final titanData = SpriteSheet(image: titan, srcSize: Vector2(64, 64));

    final flickerData = SpriteSheet(image: flicker, srcSize: Vector2(64, 64));

    final noLimitsData = SpriteSheet(image: noLimits, srcSize: Vector2(32, 32));
    // WALKING ANIMATIONS
    leftAnimation = spriteSheetData.createAnimation(
      row: 0,
      stepTime: 0.15,
      from: 6,
      to: 8,
    );
    rightAnimation = spriteSheetData.createAnimation(
      row: 0,
      stepTime: 0.15,
      from: 8,
      to: 10,
    );
    upAnimation = spriteSheetData.createAnimation(
      row: 0,
      stepTime: 0.15,
      from: 0,
      to: 3,
    );
    downAnimation = spriteSheetData.createAnimation(
      row: 0,
      stepTime: 0.15,
      from: 3,
      to: 5,
    );
    idleAnimation = spriteSheetData.createAnimation(
      row: 0,
      stepTime: 0.1,
      from: 0,
      to: 1,
    );

    // RUNNING SKILL
    runAnimation = runData.createAnimation(
      row: 17,
      stepTime: 0.06,
      from: 0,
      to: 8,
    );

    // TITAN ANIMATION
    titanAnimation = titanData.createAnimation(
      row: 10,
      stepTime: 0.07,
      loop: false,
    );

    // FLICKER ANIMATION
    flickerAnimation = flickerData.createAnimation(
      row: 18,
      stepTime: 0.02,
      loop: false,
      from: 2,
      to: 9,
    );

    // NO LIMITS ANIMATION
    noLimitsAnimation = noLimitsData.createAnimation(
      row:6,
      stepTime: 0.1,
      from: 17,
      to: 20,
    );

    animation = idleAnimation;

    add(RectangleHitbox()..collisionType = CollisionType.active);

    _loadedAnimations = true;
  }

  void setDirection(Vector2 direction) {
    moveDirection = direction;
  }

  Vector2 previousPosition = Vector2.zero();
  Vector2 attemptedPosition = Vector2.zero();

  @override
  void update(double dt) {
    super.update(dt);

    if (!_loadedAnimations) return;

    previousPosition.setFrom(position);

    // Calculate attempted new position
    if (!moveDirection.isZero()) {
      Vector2 delta = moveDirection.normalized() * moveSpeed * dt;
      attemptedPosition.setFrom(position + delta);
      position += delta; // Tentatively apply movement
    }

    // Animation logic
    if (joystick.relativeDelta.length > 0) {
      if (joystick.relativeDelta.x.abs() > joystick.relativeDelta.y.abs()) {
        animation = joystick.relativeDelta.x > 0
            ? rightAnimation
            : leftAnimation;
      } else {
        animation = joystick.relativeDelta.y > 0 ? upAnimation : downAnimation;
      }
    } else {
      animation = idleAnimation;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is WallComponent) {
      // Attempt sliding: only block movement along the colliding axis
      Vector2 delta = attemptedPosition - previousPosition;

      // Test X-axis only
      position.setFrom(previousPosition + Vector2(delta.x, 0));
      if (isCollidingWith(other)) {
        position.setFrom(previousPosition); // Reset X
      } else {
        return; // Allow X movement
      }

      // Test Y-axis only
      position.setFrom(previousPosition + Vector2(0, delta.y));
      if (isCollidingWith(other)) {
        position.setFrom(previousPosition); // Reset Y
      }
    }

    super.onCollision(intersectionPoints, other);
    print('Player collided with ${other.runtimeType}');
  }

  bool isCollidingWith(PositionComponent other) {
    return toRect().overlaps(other.toRect());
  }

  bool holdA = false;
  bool holdB = false;
  bool holdC = false;
  bool holdD = false;
  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // [A] Key | THIS IS FOR THE RUNNING POWERUP
    if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
      holdA = !holdA;
      if (holdA) {
        showRunOverlay();
        moveSpeed = 150;
      } else {
        moveSpeed = 50;
        children.whereType<OverlayEffect>().forEach(remove);
      }
    }

    // [B] Key | THIS IS FOR THE TITAN POWERUP
    if (keysPressed.contains(LogicalKeyboardKey.keyB)) {
      holdB = !holdB;
      if (holdB) {
        add(ScaleEffect.by(Vector2.all(1.5), EffectController(duration: 0.07)));
        showTitanOverlay();
      } else {
        children.whereType<OverlayEffect>().forEach(remove);
        children.whereType<ScaleEffect>().forEach(remove);
        scale = Vector2.all(1.0);
      }
    }

    // [C] Key | THIS IS FOR THE WALL IGNORE POWERUP
    if (keysPressed.contains(LogicalKeyboardKey.keyC)) {
      print("C");
      holdC = !holdC;
      if (!holdC) {
        showNoLimitsOverlay();
        opacity = 0.6;
        children.whereType<RectangleHitbox>().forEach(remove);
      } else {
           opacity = 1.0;
        children.whereType<OverlayEffect>().forEach(remove);
        add(RectangleHitbox()..collisionType = CollisionType.active);
      }
    }

    // [D] Key | Indicator HOLD AND FLICKER RELEASE
    if (keysPressed.contains(LogicalKeyboardKey.keyD)) {
      if (!holdD && !moveDirection.isZero()) {
        holdD = true;
        final indicatorOffset = moveDirection.normalized() * 50;
        if (children.whereType<_Indicator>().isEmpty) {
          add(_Indicator(offset: indicatorOffset));
        }
      } else if (holdD && !moveDirection.isZero()) {
        // UPDATING INDICATOR WHILE MOVIN
        final indicator = children.whereType<_Indicator>().firstOrNull;
        if (indicator != null) {
          indicator.offset = moveDirection.normalized() * 74;
        }
      }
    } else {
      if (holdD) {
        // On D release: removes Indicator, then flickers
        holdD = false;
        position += moveDirection.normalized() * 50;
        children.whereType<_Indicator>().forEach(remove);
        if (!moveDirection.isZero()) {
          showFlickerOverlay();
        }
      }
    }

    return true;
  }

  // ANIMATIONS:
  void showRunOverlay() {
    final overlay = OverlayEffect(
      animation: runAnimation,
      position: Vector2(-8, -8),
    );
    add(overlay);
  }

  void showTitanOverlay() {
    final overlay = OverlayEffect(
      animation: titanAnimation,
      position: Vector2(-4, 4),
    );
    add(overlay);
  }

  void showFlickerOverlay() {
    final overlay = OverlayEffect(
      animation: flickerAnimation,
      position: -moveDirection.normalized() * 50,
    );

    add(
      SequenceEffect([
        for (var i = 0; i < 6; i++) ...[
          OpacityEffect.to(
            0.0,
            EffectController(duration: 0.05, curve: Curves.easeIn),
          ),
          OpacityEffect.to(
            1.0,
            EffectController(duration: 0.05, curve: Curves.easeOut),
          ),
        ],
      ]),
    );
    add(overlay);
  }

  void showNoLimitsOverlay() {
    final overlay = OverlayEffect(
      animation: noLimitsAnimation,
      position: Vector2(-8.5, -9),
    )..size = Vector2.all(50)
    ..opacity = 0.9;
    add(overlay);
  }
}

class OverlayEffect extends SpriteAnimationComponent {
  OverlayEffect({required SpriteAnimation animation, required Vector2 position})
    : super(
        animation: animation,
        position: position,
        size: Vector2.all(45),
        removeOnFinish: true,
      );
}

// Indicator rectangle
class _Indicator extends PositionComponent {
  Vector2 offset;
  _Indicator({required this.offset}) : super(size: Vector2(16, 16));

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color.fromARGB(102, 205, 11, 11);
    canvas.drawRect(size.toRect(), paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position = offset;
  }
}
