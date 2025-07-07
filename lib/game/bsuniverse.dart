import 'package:bsuniverse/game/components/joystick_component.dart';
import 'package:bsuniverse/game/components/player_component.dart';
import 'package:bsuniverse/game/components/button_components.dart';
import 'package:bsuniverse/game/components/mute_button_component.dart';
import 'package:bsuniverse/game/sound_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'scenes/bsu_map.dart';

class BSUniverseGame extends FlameGame with HasCollisionDetection, HasKeyboardHandlerComponents {
  bool initialized = false;
  late final CameraComponent cameraComponent;
  late final PlayerComponent player;
  late final CampusMap campusMap;
  late final JoystickComponent joystick;
  late final GameSoundManager soundManager;

  // Button components
  late final StatusButtonComponent buttonA;
  late final StatusButtonComponent buttonB;
  late final StatusButtonComponent buttonC;
  late final StatusButtonComponent buttonD;
  late final MuteButtonComponent muteButton;

  // The whole Map is 30 x 40 Tiles where each tile is 32x32.
  // Bedroom 3 x 8
  // CECS Flor 39x38
  // GZB 57 x 39
  final double mapHeight = 39 * 32;
  final double mapWidth = 57 * 32;

  bool isQuestActive = false;

  @override
  void onGameResize(Vector2 canvasSize) async {
    super.onGameResize(canvasSize);
    if (!initialized) {
      // TO CREATE A COMPONENT PA THIS tinatamad pa
      joystick = Joystickiverse(
        await loadSprite('yey.png'),
        await loadSprite('bsuniverse_logo.png'),
        await loadSprite('joyv8.png'),
      ).createJoystick();
      // Initialize buttons with responsive positioning
      final buttonSize = StatusButtonComponent.getResponsiveButtonSize(
        canvasSize,
      );

      buttonA = StatusButtonComponent(
        label: 'A',
        color: Colors.red, // This will be overridden by _getButtonColor()
        status: false,
        cooldownMs: 1000, // 1 second cooldown for run
        size: buttonSize,
        position: StatusButtonComponent.getButtonPosition(canvasSize, 0),
      );

      buttonB = StatusButtonComponent(
        label: 'B',
        color: Colors.blue, // This will be overridden by _getButtonColor()
        status: false,
        cooldownMs: 2000, // 2 second cooldown for titan
        size: buttonSize,
        position: StatusButtonComponent.getButtonPosition(canvasSize, 1),
      );

      buttonC = StatusButtonComponent(
        label: 'C',
        color: Colors.green, // This will be overridden by _getButtonColor()
        status: false,
        cooldownMs: 3000, // 3 second cooldown for no limits
        size: buttonSize,
        position: StatusButtonComponent.getButtonPosition(canvasSize, 2),
      );

      buttonD = StatusButtonComponent(
        label: 'D',
        color: Colors.orange, // This will be overridden by _getButtonColor()
        status: false,
        cooldownMs: 0, // No cooldown for D button (it's hold/release)
        size: buttonSize,
        position: StatusButtonComponent.getButtonPosition(canvasSize, 3),
      );

      campusMap = CampusMap(joystick);
      player = PlayerComponent(joystick, [buttonA, buttonB, buttonC, buttonD]);
      
      // Initialize sound manager
      soundManager = GameSoundManager();
      await soundManager.initialize();
      
      // Start background music
      await soundManager.playBackgroundMusic();
      
      // Connect buttons to player after player is created
      buttonA.onPressed = player.handleButtonPress;
      buttonB.onPressed = player.handleButtonPress;
      buttonC.onPressed = player.handleButtonPress;
      buttonD.onPressed = player.handleButtonPress;
      
      // Connect D button joystick callbacks
      buttonD.onDragUpdateCallback = player.handleDButtonDrag;
      buttonD.onDragEndCallback = player.handleDButtonRelease;
      
      // Create mute button
      final muteButtonSize = Vector2.all(50);
      muteButton = MuteButtonComponent(
        position: MuteButtonComponent.getTopRightPosition(canvasSize, muteButtonSize),
        size: muteButtonSize,
      );
      
      // player.debugMode = true;
      player.debugColor = Colors.white;

      world = campusMap;
      world.add(player);

      initialized = true;
      final camera = CameraComponent(world: world)
        ..viewfinder.zoom = 3.0
        ..viewfinder.anchor = Anchor.center
        ..follow(player..position = Vector2(60, 168));
      camera.viewport.add(joystick);
      camera.viewport.add(buttonD);
      camera.viewport.add(buttonC);
      camera.viewport.add(buttonB);
      camera.viewport.add(buttonA);
      camera.viewport.add(muteButton);
      camera.setBounds(
        Rectangle.fromCenter(
          center: Vector2.zero(),
          // Its zoomed in by 2,
          size: Vector2(mapWidth * 2, mapHeight * 2),
        ),
      );
      add(camera);
    } else {
      // Update button positions on resize
      updateButtonPositions(canvasSize);
    }
  }

  // Method to update button positions on screen resize
  void updateButtonPositions(Vector2 canvasSize) {
    if (!initialized) return;

    final buttonSize = StatusButtonComponent.getResponsiveButtonSize(
      canvasSize,
    );

    buttonA.size = buttonSize;
    buttonA.position = StatusButtonComponent.getButtonPosition(canvasSize, 0);

    buttonB.size = buttonSize;
    buttonB.position = StatusButtonComponent.getButtonPosition(canvasSize, 1);

    buttonC.size = buttonSize;
    buttonC.position = StatusButtonComponent.getButtonPosition(canvasSize, 2);

    buttonD.size = buttonSize;
    buttonD.position = StatusButtonComponent.getButtonPosition(canvasSize, 3);
    
    // Update mute button position
    final muteButtonSize = Vector2.all(50);
    muteButton.position = MuteButtonComponent.getTopRightPosition(canvasSize, muteButtonSize);
  }

  @override
  void update(double dt) async {
    if (isQuestActive) return; // Pause game update when quest is active
    super.update(dt);
    if (initialized) {
      camera.viewfinder.position.round();
      player.setDirection(joystick.relativeDelta);
      camera.renderContext;
    }
  }

  void showQuestOverlay() {
    overlays.add('QuestOverlay');
    isQuestActive = true;
  }

  void hideQuestOverlay() {
    overlays.remove('QuestOverlay');
    isQuestActive = false;
  }

  @override
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyQ) {
      showQuestOverlay();
      return KeyEventResult.handled;
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
