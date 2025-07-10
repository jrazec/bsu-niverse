import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/components/button_components.dart';
import 'package:bsuniverse/game/components/wall_component.dart';
import 'package:bsuniverse/game/sound_manager.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/rendering.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Powerup effect base class
abstract class PlayerPowerupEffect {
  final PlayerComponent player;
  bool isActive = false;

  PlayerPowerupEffect(this.player);

  void activate();
  void deactivate();
  void update(double dt) {}
}

// RUN POWERUP
class RunPowerupEffect extends PlayerPowerupEffect {
  OverlayEffect? overlay;

  RunPowerupEffect(PlayerComponent player) : super(player);

  @override
  void activate() {
    if (isActive) return;
    isActive = true;
    player.moveSpeed = 180;
    overlay =
        OverlayEffect(
            animation: player.runAnimation,
            position: Vector2(-10, -10),
          )
          ..size = Vector2.all(51)
          ..priority = 10;
    player.add(overlay!);
  }

  @override
  void deactivate() {
    if (!isActive) return;
    isActive = false;
    player.moveSpeed = 80;
    overlay?.removeFromParent();
    overlay = null;
  }
}

// TITAN POWERUP
class TitanPowerupEffect extends PlayerPowerupEffect {
  OverlayEffect? overlay;
  TitanPowerupEffect(PlayerComponent player) : super(player);

  @override
  void activate() {
    if (isActive) return;
    isActive = true;
    player.add(
      ScaleEffect.by(Vector2.all(1.5), EffectController(duration: 0.07)),
    );
    overlay = OverlayEffect(
      animation: player.titanAnimation,
      position: Vector2(-4, 4),
    )..priority = -10;
    player.add(overlay!);
  }

  @override
  void deactivate() {
    if (!isActive) return;
    isActive = false;
    overlay?.removeFromParent();
    overlay = null;
    player.children.whereType<ScaleEffect>().forEach(player.remove);
    player.scale = Vector2.all(1.0);
  }
}

// NO LIMITS POWERUP
class NoLimitsPowerupEffect extends PlayerPowerupEffect {
  OverlayEffect? overlay;
  NoLimitsPowerupEffect(PlayerComponent player) : super(player);

  @override
  void activate() {
    if (isActive) return;
    isActive = true;
    overlay =
        OverlayEffect(
            animation: player.noLimitsAnimation,
            position: Vector2(-1, -2),
          )
          ..size = Vector2.all(35)
          ..opacity = 0.9;
    player.add(overlay!);
    player.opacity = 0.8;
    player.children.whereType<RectangleHitbox>().forEach(player.remove);
  }

  @override
  void deactivate() {
    if (!isActive) return;
    isActive = false;
    overlay?.removeFromParent();
    overlay = null;
    player.opacity = 1.0;
    player.add(RectangleHitbox()..collisionType = CollisionType.active);
  }
}

// FLICKER POWERUP (instant, not toggle)
class FlickerPowerupEffect extends PlayerPowerupEffect {
  FlickerPowerupEffect(PlayerComponent player) : super(player);

  @override
  void activate() {
    final overlay = OverlayEffect(
      animation: player.flickerAnimation,
      position: -player.moveDirection.normalized() * 70,
    )..size = Vector2.all(15);
    overlay.removeOnFinish = true;
    player.add(overlay);

    final overlay2 = OverlayEffect(
      animation: player.flickerAnimation2,
      position: Vector2(player.moveDirection.x, player.moveDirection.y - 5),
    )..size = Vector2.all(32);
    player.add(overlay2);

    player.add(
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
  }

  @override
  void deactivate() {}
}

enum PlayerDirection { up, down, left, right, none }

// PlayerComponent with powerup objects
class PlayerComponent extends SpriteAnimationComponent
    with CollisionCallbacks, KeyboardHandler, HasGameReference<BSUniverseGame> {
  final JoystickComponent joystick;
  final List<StatusButtonComponent> buttons;
  Vector2 moveDirection = Vector2.zero();
  double moveSpeed = 80;
  PlayerDirection playerDirection = PlayerDirection.none;

  late final SpriteAnimation leftAnimation;
  late final SpriteAnimation rightAnimation;
  late final SpriteAnimation upAnimation;
  late final SpriteAnimation downAnimation;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runAnimation;
  late final SpriteAnimation titanAnimation;
  late final SpriteAnimation flickerAnimation, flickerAnimation2;
  late final SpriteAnimation noLimitsAnimation;

  bool _loadedAnimations = false;

  // Powerup objects
  late final RunPowerupEffect runPowerup;
  late final TitanPowerupEffect titanPowerup;
  late final NoLimitsPowerupEffect noLimitsPowerup;
  late final FlickerPowerupEffect flickerPowerup;

  PlayerComponent(this.joystick, this.buttons) : super(size: Vector2.all(32.0));

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
    downAnimation = spriteSheetData.createAnimation(
      row: 0,
      stepTime: 0.15,
      from: 0,
      to: 3,
    );
    upAnimation = spriteSheetData.createAnimation(
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
    flickerAnimation2 = flickerData.createAnimation(
      row: 19,
      stepTime: 0.02,
      loop: false,
      from: 2,
      to: 9,
    );

    // NO LIMITS ANIMATION
    noLimitsAnimation = noLimitsData.createAnimation(
      row: 1,
      stepTime: 0.1,
      from: 16,
      to: 20,
    );

    animation = idleAnimation;

    add(RectangleHitbox()..collisionType = CollisionType.active);
    
    // Add shadow effect using HasPaint mixin and custom rendering
    final shadowComponent = RectangleComponent(
      size: Vector2(size.x*0.5, size.y * 0.15),
      position: Vector2(size.x*0.25, size.y*0.75),
      paint: Paint()
        ..color = const Color.fromARGB(112, 0, 0, 0)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0),
    );
    shadowComponent.priority = -100;
    add(shadowComponent);

    // Initialize powerup objects
    runPowerup = RunPowerupEffect(this);
    titanPowerup = TitanPowerupEffect(this);
    noLimitsPowerup = NoLimitsPowerupEffect(this);
    flickerPowerup = FlickerPowerupEffect(this);

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

    // Handle keyboard movement (if no joystick input)
    if (joystick.relativeDelta.length == 0 && playerDirection != PlayerDirection.none) {
      double dirX = 0.0;
      double dirY = 0.0;
      
      switch (playerDirection) {
        case PlayerDirection.left:
          animation = leftAnimation;
          dirX -= moveSpeed;
          break;
        case PlayerDirection.right:
          animation = rightAnimation;
          dirX += moveSpeed;
          break;
        case PlayerDirection.up:
          animation = upAnimation;
          dirY -= moveSpeed;
          break;
        case PlayerDirection.down:
          animation = downAnimation;
          dirY += moveSpeed;
          break;
        case PlayerDirection.none:
          break;
      }
      
      moveDirection = Vector2(dirX, dirY);
    }

    // Calculate attempted new position
    if (!moveDirection.isZero()) {
      Vector2 delta = moveDirection.normalized() * moveSpeed * dt;
      attemptedPosition.setFrom(position + delta);
      position += delta; // Tentatively apply movement
      
      // Play movement sound (throttled to avoid spam)
      GameSoundManager().playMovementSound();
    }

    // Animation logic for joystick input
    if (joystick.relativeDelta.length > 0) {
      if (joystick.relativeDelta.x.abs() > joystick.relativeDelta.y.abs()) {
        animation = joystick.relativeDelta.x > 0
            ? rightAnimation
            : leftAnimation;
      } else {
        animation = joystick.relativeDelta.y > 0 ? downAnimation : upAnimation;
      }
    } else if (playerDirection == PlayerDirection.none) {
      animation = idleAnimation;
    }

    runPowerup.update(dt);
    titanPowerup.update(dt);
    noLimitsPowerup.update(dt);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Collision) {
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
  bool inCooldown = false;
  
  // Mini joystick for D button
  Vector2 _dashDirection = Vector2.zero();

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    // [A] Key | RUNNING POWERUP
    // if (event.logicalKey == LogicalKeyboardKey.keyA && event is KeyDownEvent) {
    //   holdA = !holdA;
    //   if (holdA) {
    //     runPowerup.activate();
    //   } else {
    //     runPowerup.deactivate();
    //     // Start cooldown when A is released/deactivated
    //     buttons.firstWhere((b) => b.label == 'A').startCooldownOnRelease();
    //   }
    // }

    // // [B] Key | TITAN POWERUP
    // if (event.logicalKey == LogicalKeyboardKey.keyB && event is KeyDownEvent) {
    //   holdB = !holdB;
    //   if (holdB) {
    //     titanPowerup.activate();
    //   } else {
    //     titanPowerup.deactivate();
    //     // Start cooldown when B is released/deactivated
    //     buttons.firstWhere((b) => b.label == 'B').startCooldownOnRelease();
    //   }
    // }

    // // [C] Key | WALL IGNORE POWERUP
    // if (event.logicalKey == LogicalKeyboardKey.keyC && event is KeyDownEvent) {
    //   holdC = !holdC;
    //   if (holdC) {
    //     noLimitsPowerup.activate();
    //   } else {
    //     noLimitsPowerup.deactivate();
    //     // Start cooldown when C is released/deactivated
    //     buttons.firstWhere((b) => b.label == 'C').startCooldownOnRelease();
    //   }
    // }

    // // [D] Key | Indicator HOLD AND FLICKER RELEASE
    // if (keysPressed.contains(LogicalKeyboardKey.keyD) && !inCooldown) {
    //   if (!holdD) {
    //     holdD = true;
    //     // Show indicator sprite
    //     _showIndicator();
    //   }
    //   // Update dash direction from current movement (arrow keys)
    //   if (playerDirection != PlayerDirection.none) {
    //     switch (playerDirection) {
    //       case PlayerDirection.up:
    //         _dashDirection = Vector2(0, -1);
    //         break;
    //       case PlayerDirection.down:
    //         _dashDirection = Vector2(0, 1);
    //         break;
    //       case PlayerDirection.left:
    //         _dashDirection = Vector2(-1, 0);
    //         break;
    //       case PlayerDirection.right:
    //         _dashDirection = Vector2(1, 0);
    //         break;
    //       case PlayerDirection.none:
    //         break;
    //     }
    //     _updateIndicatorPosition();
    //   }
    // } else if (event is KeyUpEvent &&
    //     event.logicalKey == LogicalKeyboardKey.keyD &&
    //     holdD) {
    //   // On D release: dash and remove indicator
    //   holdD = false;
    //   _executeDash();
    // }

    if (keysPressed.contains(LogicalKeyboardKey.arrowUp) || keysPressed.contains(LogicalKeyboardKey.keyW)) {
      playerDirection = PlayerDirection.up;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowDown)|| keysPressed.contains(LogicalKeyboardKey.keyS)) {
      playerDirection = PlayerDirection.down;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) || keysPressed.contains(LogicalKeyboardKey.keyA)) {
      playerDirection = PlayerDirection.left;
    } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight) || keysPressed.contains(LogicalKeyboardKey.keyD)) {
      playerDirection = PlayerDirection.right;
    } else {
      playerDirection = PlayerDirection.none;
    }

    return true;
  }

  // Method to handle button presses
  void handleButtonPress(String buttonLabel) {
    switch (buttonLabel) {
      case 'A':
        holdA = !holdA;
        if (holdA) {
          runPowerup.activate();
          GameSoundManager().playPowerUpActivateSound('run');
        } else {
          runPowerup.deactivate();
          GameSoundManager().playPowerUpDeactivateSound();
          // Start cooldown when button is released/deactivated
          buttons.firstWhere((b) => b.label == 'A').startCooldownOnRelease();
        }
        // Update button visual status
        buttons.firstWhere((b) => b.label == 'A').updateStatus(holdA);
        break;
      case 'B':
        holdB = !holdB;
        if (holdB) {
          titanPowerup.activate();
          GameSoundManager().playPowerUpActivateSound('titan');
        } else {
          titanPowerup.deactivate();
          GameSoundManager().playPowerUpDeactivateSound();
          // Start cooldown when button is released/deactivated
          buttons.firstWhere((b) => b.label == 'B').startCooldownOnRelease();
        }
        // Update button visual status
        buttons.firstWhere((b) => b.label == 'B').updateStatus(holdB);
        break;
      case 'C':
        holdC = !holdC;
        if (holdC) {
          noLimitsPowerup.activate();
          GameSoundManager().playPowerUpActivateSound('nolimits');
        } else {
          noLimitsPowerup.deactivate();
          GameSoundManager().playPowerUpDeactivateSound();
          // Start cooldown when button is released/deactivated
          buttons.firstWhere((b) => b.label == 'C').startCooldownOnRelease();
        }
        buttons.firstWhere((b) => b.label == 'C').updateStatus(holdC);
        break;
      case 'D':
        if (!inCooldown) {
          if (!holdD) {
            holdD = true;
            buttons.firstWhere((b) => b.label == 'D').enterJoystickMode();
            _showIndicator();
            buttons.firstWhere((b) => b.label == 'D').updateStatus(holdD);
          } else {
            holdD = false;
            _executeDash();
            buttons.firstWhere((b) => b.label == 'D').updateStatus(holdD);
          }
        }
        break;
    }
  }

  // Handle D button drag updates
  void handleDButtonDrag(String buttonLabel, Vector2 direction) {
    if (buttonLabel == 'D' && holdD) {
      _dashDirection = direction;
      // Update indicator position based on joystick direction
      _updateIndicatorPosition();
    }
  }

  // Handle D button release
  void handleDButtonRelease(String buttonLabel) {
    if (buttonLabel == 'D' && holdD) {
      holdD = false;
      _executeDash();
      buttons.firstWhere((b) => b.label == 'D').exitJoystickMode();
      buttons.firstWhere((b) => b.label == 'D').updateStatus(holdD);
    }
  }

  void _showIndicator() {
    if (children.whereType<_Indicator>().isEmpty) {
      final initialDirection = _dashDirection.isZero() ? Vector2(1, 0) : _dashDirection;
      final indicatorOffset = initialDirection.normalized() * 74;
      add(_Indicator(animation: idleAnimation, offset: indicatorOffset));
    }
  }
  
  void _updateIndicatorPosition() {
    final indicator = children.whereType<_Indicator>().firstOrNull;
    if (indicator != null && !_dashDirection.isZero()) {
      indicator.offset = _dashDirection.normalized() * 74;
    }
  }
  
  void _executeDash() {
    if (_dashDirection.isZero()) return;
    
    // Perform dash
    position += _dashDirection.normalized() * 70;
    
    // Add flicker effect
    flickerPowerup.activate();
    
    // Remove indicator
    children.whereType<_Indicator>().forEach(remove);
    
    // Start cooldown AFTER dash is executed
    inCooldown = true;
    
    // Pause movement after dash
    final prevMoveSpeed = moveSpeed;
    moveSpeed = 0;
      GameSoundManager().playPowerUpActivateSound('dash');
    Future.delayed(const Duration(milliseconds: 500), () {
      moveSpeed = prevMoveSpeed;
    });
    
    // Reset cooldown
    Future.delayed(const Duration(milliseconds: 1000), () {
      inCooldown = false;
    });
    
    // Reset dash direction
    _dashDirection = Vector2.zero();
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
class _Indicator extends SpriteAnimationComponent {
  Vector2 offset;
  _Indicator({required this.offset, required SpriteAnimation animation})
    : super(size: Vector2(32, 32), animation: animation);

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final rect = Rect.fromCenter(
      center: Offset(16, 25),
      width: 32 - 14,
      height: 5,
    );
    canvas.drawRect(rect, paint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position = offset;
  }
}
