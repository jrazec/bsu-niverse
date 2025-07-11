import 'package:bsuniverse/game/bsuniverse.dart';
import 'package:bsuniverse/game/components/button_components.dart';
import 'package:bsuniverse/game/components/wall_component.dart';
import 'package:bsuniverse/game/sound_manager.dart';
import 'package:bsuniverse/game/widgets/quest_overlay.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
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
    if (player.runAnimation != null) {
      overlay =
          OverlayEffect(
              animation: player.runAnimation!,
              position: Vector2(-10, -10),
            )
            ..size = Vector2.all(51)
            ..priority = 10;
      player.add(overlay!);
    }
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
    if (player.titanAnimation != null) {
      overlay = OverlayEffect(
        animation: player.titanAnimation!,
        position: Vector2(-4, 4),
      )..priority = -10;
      player.add(overlay!);
    }
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
  List<RectangleHitbox> removedHitboxes = [];
  
  NoLimitsPowerupEffect(PlayerComponent player) : super(player);

  @override
  void activate() {
    if (isActive) return;
    isActive = true;
    if (player.noLimitsAnimation != null) {
      overlay =
          OverlayEffect(
              animation: player.noLimitsAnimation!,
              position: Vector2(-1, -2),
            )
            ..size = Vector2.all(35)
            ..opacity = 0.9;
      player.add(overlay!);
    }
    player.opacity = 0.8;
    
    // Store and remove existing hitboxes
    removedHitboxes = player.children.whereType<RectangleHitbox>().toList();
    removedHitboxes.forEach(player.remove);
    print("NoLimits activated: removed ${removedHitboxes.length} hitboxes");
  }

  @override
  void deactivate() {
    if (!isActive) return;
    isActive = false;
    overlay?.removeFromParent();
    overlay = null;
    player.opacity = 1.0;
    
    // Restore the original hitboxes, or add a default one if none were stored
    if (removedHitboxes.isNotEmpty) {
      removedHitboxes.forEach(player.add);
      print("NoLimits deactivated: restored ${removedHitboxes.length} hitboxes");
    } else {
      player.add(RectangleHitbox()..collisionType = CollisionType.active);
      print("NoLimits deactivated: added default hitbox");
    }
    removedHitboxes.clear();
  }
}

// FLICKER POWERUP (instant, not toggle)
class FlickerPowerupEffect extends PlayerPowerupEffect {
  FlickerPowerupEffect(PlayerComponent player) : super(player);

  @override
  void activate() {
    if (player.flickerAnimation != null && player.flickerAnimation2 != null) {
      final overlay = OverlayEffect(
        animation: player.flickerAnimation!,
        position: -player.moveDirection.normalized() * 70,
      )..size = Vector2.all(15);
      overlay.removeOnFinish = true;
      player.add(overlay);

      final overlay2 = OverlayEffect(
        animation: player.flickerAnimation2!,
        position: Vector2(player.moveDirection.x, player.moveDirection.y - 5),
      )..size = Vector2.all(32);
      player.add(overlay2);
    }

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

  SpriteAnimation? leftAnimation;
  SpriteAnimation? rightAnimation;
  SpriteAnimation? upAnimation;
  SpriteAnimation? downAnimation;
  SpriteAnimation? idleAnimation;
  SpriteAnimation? runAnimation;
  SpriteAnimation? titanAnimation;
  SpriteAnimation? flickerAnimation, flickerAnimation2;
  SpriteAnimation? noLimitsAnimation;

  bool _loadedAnimations = false;

  // Current sprite configuration - this will be set when sprites are loaded
  String currentSpriteSheet = 'boy_pe.png'; // Default, but will be dynamic
  
  // Method to get the current player sprite configuration for quest overlay
  PlayerSpriteConfig getCurrentSpriteConfig() {
    return PlayerSpriteConfig(
      imagePath: currentSpriteSheet,
      frameIndex: 3, // Frame 3 is always the dialogue/back-facing frame
      isSpriteSheet: true,
    );
  }
  
  // Method to change the player's sprite sheet (for future outfit system)
  Future<void> changeSpriteSheet(String newSpriteSheet) async {
    print("Changing sprite sheet from $currentSpriteSheet to $newSpriteSheet");
    
    if (currentSpriteSheet == newSpriteSheet) {
      print("Same sprite sheet, no change needed");
      return;
    }
    
    currentSpriteSheet = newSpriteSheet;
    
    // Store current powerup states before reloading (only if powerups are initialized)
    bool runActive = false;
    bool titanActive = false;
    bool noLimitsActive = false;
    
    if (_loadedAnimations) {
      runActive = runPowerup.isActive;
      titanActive = titanPowerup.isActive;
      noLimitsActive = noLimitsPowerup.isActive;
      
      // Deactivate all powerups temporarily
      if (runActive) runPowerup.deactivate();
      if (titanActive) titanPowerup.deactivate();
      if (noLimitsActive) noLimitsPowerup.deactivate();
    }
    
    // Check hitbox before removal
    int hitboxCountBefore = children.whereType<RectangleHitbox>().length;
    print("Hitboxes before component removal: $hitboxCountBefore");
    
    // Remove only specific components, not all children
    // Remove shadow components specifically (they have a specific priority)
    children.whereType<RectangleComponent>().where((comp) => comp.priority == -100).forEach(remove);
    children.whereType<OverlayEffect>().forEach(remove); // Remove any overlay effects
    
    // Check hitbox after removal
    int hitboxCountAfter = children.whereType<RectangleHitbox>().length;
    print("Hitboxes after component removal: $hitboxCountAfter");
    
    // Reset the loaded animations flag
    _loadedAnimations = false;
    
    // Reload animations with new sprite sheet
    await _loadAnimations();
    
    // Restore powerup states if they were active
    if (runActive) runPowerup.activate();
    if (titanActive) titanPowerup.activate();
    if (noLimitsActive) noLimitsPowerup.activate();
    
    // Final check on hitbox state
    int finalHitboxCount = children.whereType<RectangleHitbox>().length;
    print("Final hitbox count: $finalHitboxCount");
    
    print("Sprite sheet change completed successfully");
  }
  
  // Separate method for loading animations to avoid conflicts with onLoad
  Future<void> _loadAnimations() async {
    print("Loading animations for sprite sheet: $currentSpriteSheet");
    
    // SPRITESHEETS TO USE
    final spriteSheet = await game.images.load(currentSpriteSheet);
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

    // Set the current animation to idle
    animation = idleAnimation;

    // Ensure hitbox exists (critical for collision detection)
    if (children.whereType<RectangleHitbox>().isEmpty) {
      print("Adding missing hitbox during sprite change");
      add(RectangleHitbox()..collisionType = CollisionType.active);
    } else {
      print("Hitbox already exists, keeping it");
    }
    
    // Add shadow effect
    final shadowComponent = RectangleComponent(
      size: Vector2(size.x*0.5, size.y * 0.15),
      position: Vector2(size.x*0.25, size.y*0.75),
      paint: Paint()
        ..color = const Color.fromARGB(112, 0, 0, 0)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0),
    );
    shadowComponent.priority = -100;
    add(shadowComponent);

    // Always reinitialize powerup objects with new animations
    runPowerup = RunPowerupEffect(this);
    titanPowerup = TitanPowerupEffect(this);
    noLimitsPowerup = NoLimitsPowerupEffect(this);
    flickerPowerup = FlickerPowerupEffect(this);

    _loadedAnimations = true;
    print("Animations loaded successfully for: $currentSpriteSheet");
  }

  // Powerup objects
  late RunPowerupEffect runPowerup;
  late TitanPowerupEffect titanPowerup;
  late NoLimitsPowerupEffect noLimitsPowerup;
  late FlickerPowerupEffect flickerPowerup;

  PlayerComponent(this.joystick, this.buttons) : super(size: Vector2.all(32.0));

  @override
  Future<void> onLoad() async {
    if (_loadedAnimations) return;
    await _loadAnimations();
  }

  void setDirection(Vector2 direction) {
    moveDirection = direction;
  }

  Vector2 previousPosition = Vector2.zero();
  Vector2 attemptedPosition = Vector2.zero();

  @override
  void update(double dt) {
    super.update(dt);

    if (!_loadedAnimations || idleAnimation == null) return;

    // Disable movement when closet overlay is active
    if (game.isClosetActive) {
      animation = idleAnimation;
      moveDirection = Vector2.zero();
      playerDirection = PlayerDirection.none;
      return;
    }

    previousPosition.setFrom(position);

    // Handle keyboard movement (if no joystick input)
    if (joystick.relativeDelta.length == 0 && playerDirection != PlayerDirection.none) {
      double dirX = 0.0;
      double dirY = 0.0;
      
      switch (playerDirection) {
        case PlayerDirection.left:
          if (leftAnimation != null) animation = leftAnimation;
          dirX -= moveSpeed;
          break;
        case PlayerDirection.right:
          if (rightAnimation != null) animation = rightAnimation;
          dirX += moveSpeed;
          break;
        case PlayerDirection.up:
          if (upAnimation != null) animation = upAnimation;
          dirY -= moveSpeed;
          break;
        case PlayerDirection.down:
          if (downAnimation != null) animation = downAnimation;
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
    if (children.whereType<_Indicator>().isEmpty && idleAnimation != null) {
      final initialDirection = _dashDirection.isZero() ? Vector2(1, 0) : _dashDirection;
      final indicatorOffset = initialDirection.normalized() * 74;
      add(_Indicator(animation: idleAnimation!, offset: indicatorOffset));
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
