import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/components/wall_component.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class PlayerComponent extends SpriteAnimationComponent with CollisionCallbacks, HasGameReference<BSUniverseGame> {
  final JoystickComponent joystick;
  Vector2 moveDirection = Vector2.zero();
  double moveSpeed = 50;


  late final SpriteAnimation leftAnimation;
  late final SpriteAnimation rightAnimation;
  late final SpriteAnimation upAnimation;
  late final SpriteAnimation downAnimation;
  late final SpriteAnimation idleAnimation;

  bool _loadedAnimations = false;

  PlayerComponent(this.joystick) : super(size: Vector2.all(32.0));

  @override
  Future<void> onLoad() async {
    if (_loadedAnimations) return;

    final spriteSheet = await game.images.load('boy_pe.png');

    final spriteSheetData = SpriteSheet(
      image: spriteSheet,
      srcSize: Vector2(32, 32),
    );

    leftAnimation = spriteSheetData.createAnimation(row: 0, stepTime: 0.15, from: 6, to: 8);
    rightAnimation = spriteSheetData.createAnimation(row: 0, stepTime: 0.15, from: 8, to: 10);
    upAnimation = spriteSheetData.createAnimation(row: 0, stepTime: 0.15, from: 0, to: 3);
    downAnimation = spriteSheetData.createAnimation(row: 0, stepTime: 0.15, from: 3, to: 5);
    idleAnimation = spriteSheetData.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 1);

    animation = idleAnimation;

    add(
      RectangleHitbox()..collisionType = CollisionType.passive,
    );

    _loadedAnimations = true;
  }


Vector2 previousPosition = Vector2.zero();
  @override
  void update(double dt) {
    super.update(dt);

    previousPosition.setFrom(position); // Save before moving

    if (!_loadedAnimations) return;

    if (!moveDirection.isZero()) {
      position += moveDirection.normalized() * moveSpeed * dt;
    }

    if (joystick.relativeDelta.length > 0) {
      if (joystick.relativeDelta.x.abs() > joystick.relativeDelta.y.abs()) {
        animation = joystick.relativeDelta.x > 0 ? rightAnimation : leftAnimation;
      } else {
        animation = joystick.relativeDelta.y > 0 ? upAnimation : downAnimation;
      }
    } else {
      animation = idleAnimation;
    }
  }

  void setDirection(Vector2 direction) {
    moveDirection = direction;
  }
@override
void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
  if (other is ShapeHitbox || other is RectangleHitbox) {
    position.setFrom(previousPosition);
  }
  super.onCollision(intersectionPoints, other);
}
}
