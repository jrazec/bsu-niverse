import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/components/wall_component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class PlayerComponent extends SpriteAnimationComponent
    with CollisionCallbacks, HasGameReference<BSUniverseGame> {
  final JoystickComponent joystick;
  Vector2 moveDirection = Vector2.zero();
  double moveSpeed = 50;

  late final SpriteAnimation leftAnimation;
  late final SpriteAnimation rightAnimation;
  late final SpriteAnimation upAnimation;
  late final SpriteAnimation downAnimation;
  late final SpriteAnimation idleAnimation;

  bool _loadedAnimations = false;

  PlayerComponent(this.joystick) : super(size: Vector2.all(20.0));

  @override
  Future<void> onLoad() async {
    if (_loadedAnimations) return;

    final spriteSheet = await game.images.load('boy_pe.png');

    final spriteSheetData = SpriteSheet(
      image: spriteSheet,
      srcSize: Vector2(32, 32),
    );

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

  // Optional helper
  bool isCollidingWith(PositionComponent other) {
    return toRect().overlaps(other.toRect());
  }
}
