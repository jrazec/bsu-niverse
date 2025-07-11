import 'package:bsuniverse/game/components/joystick_component.dart';
import 'package:bsuniverse/game/components/player_component.dart';
import 'package:bsuniverse/game/components/button_components.dart';
import 'package:bsuniverse/game/components/mute_button_component.dart';
import 'package:bsuniverse/game/components/sparta_coins_component.dart';
import 'package:bsuniverse/game/components/wall_component.dart';
import 'package:bsuniverse/game/setup/abb.dart';
import 'package:bsuniverse/game/sound_manager.dart';
import 'package:bsuniverse/game/data/popup_configs.dart';
import 'package:bsuniverse/game/data/player_data.dart';
// Setup imports
import 'package:bsuniverse/game/setup/facade.dart';
import 'package:bsuniverse/game/setup/bedroom.dart';
import 'package:bsuniverse/game/setup/lsb.dart';
import 'package:bsuniverse/game/setup/map_bsu.dart';
import 'package:bsuniverse/game/setup/vmb.dart';
import 'package:bsuniverse/game/setup/gzb.dart';
import 'package:bsuniverse/game/setup/gymn.dart';
import 'package:bsuniverse/game/setup/lsb_room.dart';
import 'package:bsuniverse/game/setup/com_lab_502_lsb.dart';
import 'package:bsuniverse/game/setup/com_lab_503_lsb.dart';
import 'package:bsuniverse/game/setup/vmb_room.dart';
import 'package:bsuniverse/game/setup/com_lab_301_vmb.dart';
import 'package:bsuniverse/game/setup/com_lab_302_vmb.dart';
import 'package:bsuniverse/game/setup/multimedia.dart';
import 'package:bsuniverse/game/setup/gymn_open_area.dart';
import 'package:bsuniverse/game/setup/gzb_room.dart';
import 'package:bsuniverse/game/setup/canteen.dart';
import 'package:bsuniverse/game/setup/abb_room.dart';
import 'package:bsuniverse/game/setup/library_room.dart';
import 'package:flame/collisions.dart';
import 'package:bsuniverse/game/widgets/quest_overlay.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/experimental.dart';
import 'package:flame/input.dart';
import 'package:flame/events.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// Color scheme
final Color pixelGold = Color.fromRGBO(255, 215, 0, 1.0);

/// Custom Menu Button Component matching the mute button and SpartaCoins styling
class MenuButtonComponent extends PositionComponent with HasGameReference, TapCallbacks {
  late final TextComponent _menuIcon;
  bool _isPressed = false;
  
  final Color _buttonColor = Colors.black54;
  final Color _borderColor = Colors.white;
  final Color _iconColor = Colors.white;
  final double _borderWidth = 2.0;
  
  VoidCallback? onPressed;

  MenuButtonComponent({
    Vector2? position,
    Vector2? size,
    this.onPressed,
  }) : super(
          position: position ?? Vector2.zero(),
          size: size ?? Vector2.all(50),
        ) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    // Create rectangular background using RectangleComponent
    final background = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = _buttonColor
        ..style = PaintingStyle.fill,
      anchor: Anchor.center,
      position: size / 2,
    );
    
    // Create border
    final border = RectangleComponent(
      size: size,
      paint: Paint()
        ..color = _borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _borderWidth,
      anchor: Anchor.center,
      position: size / 2,
    );
    
    add(background);
    add(border);
    
    // Create menu icon (hamburger menu)
    _menuIcon = TextComponent(
      text: '☰',
      textRenderer: TextPaint(
        style: TextStyle(
          color: _iconColor,
          fontSize: size.x * 0.5,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: size / 2,
    );
    
    add(_menuIcon);
  }

  @override
  bool onTapDown(TapDownEvent event) {
    _isPressed = true;
    _updateVisuals();
    return true;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    if (_isPressed) {
      _isPressed = false;
      _updateVisuals();
      onPressed?.call();
    }
    return true;
  }

  @override
  bool onTapCancel(TapCancelEvent event) {
    _isPressed = false;
    _updateVisuals();
    return true;
  }

  void _updateVisuals() {
    // Add visual feedback when pressed (optional - could make it slightly darker)
    if (_isPressed) {
      _menuIcon.textRenderer = TextPaint(
        style: TextStyle(
          color: _iconColor.withOpacity(0.7),
          fontSize: size.x * 0.5,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      _menuIcon.textRenderer = TextPaint(
        style: TextStyle(
          color: _iconColor,
          fontSize: size.x * 0.5,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  // Static method to get position for top-left corner
  static Vector2 getTopLeftPosition(Vector2 canvasSize, Vector2 buttonSize) {
    final margin = 20.0;
    return Vector2(
      margin + buttonSize.x / 2,
      margin + buttonSize.y / 2,
    );
  }
}

// Scene Configuration
final Map<String, Map<String, dynamic>> tmxConfig = {
  "facade": {"image": "facade.tmx", "zoom": 4.0, "w": 25, "h": 11},
  "bedroom": {"image": "Bedroom.tmx", "zoom": 4.0, "w": 3, "h": 5},
  "mapBsu": {"image": "bsu-map.tmx", "zoom": 3.7, "w": 30, "h": 40},
  "lsb": {"image": "cecs.tmx", "zoom": 4.0, "w": 57, "h": 39},
  "vmb": {"image": "hebuilding.tmx", "zoom": 4.0, "w": 45, "h": 44},
  "abb": {"image": "old_building.tmx", "zoom": 4.0, "w": 45, "h": 44},
  "gzb": {"image": "gzbuilding.tmx", "zoom": 4.0, "w": 59, "h": 41},
  "gymn": {"image": "Gym.tmx", "zoom": 4.0, "w": 13, "h": 9},
  "gymnOpenArea": {"image": "Gym.tmx", "zoom": 4.0, "w": 13, "h": 9},
  "multimedia": {"image": "multimedia.tmx", "zoom": 4.0, "w": 10, "h": 10},
  "lsbRoom": {"image": "classroom_cecs-heb.tmx", "zoom": 4.0, "w": 10, "h": 10},
  "comLab502Lsb": {
    "image": "Comlab502_cecs.tmx",
    "zoom": 4.0,
    "w": 10,
    "h": 10,
  },
  "comLab503Lsb": {
    "image": "Comlab503_cecs.tmx",
    "zoom": 4.0,
    "w": 10,
    "h": 10,
  },
  "comLab301Vmb": {"image": "ComlabHeb.tmx", "zoom": 4.0, "w": 10, "h": 10},
  "comLab302Vmb": {"image": "ComlabHeb.tmx", "zoom": 4.0, "w": 10, "h": 10},
  "vmbRoom": {"image": "classroom_cecs-heb.tmx", "zoom": 4.0, "w": 13, "h": 9},
  "abbRoom": {"image": "classroom-ob.tmx", "zoom": 4.0, "w": 10, "h": 10},
  "gzbRoom": {"image": "classroom-ldc.tmx", "zoom": 4.0, "w": 10, "h": 10},
  "libraryRoom": {"image": "Library.tmx", "zoom": 4.0, "w": 17, "h": 9},
  "canteen": {"image": "canteenldc.tmx", "zoom": 4.0, "w": 10, "h": 10},
};

class FloorList {
  RoomList? floor1, floor2, floor3, floor4, floor5;
  bool? goOut, goIn;
  Vector2? leaveRoomSpawnPoint;
  GoTo? leaveRoomMap;
  FloorList({
    this.floor1,
    this.floor2,
    this.floor3,
    this.floor4,
    this.floor5,
    this.goIn,
    this.goOut,
    this.leaveRoomSpawnPoint,
    this.leaveRoomMap,
  });

  List<String> getActivePortals() {
    if (goOut != null) {
      print("Out Triggered!GRRR");
      return ['out'];
    }
    if (goIn != null) {
      return ['in'];
    }
    if (floor1 != null &&
        floor2 == null &&
        floor3 == null &&
        floor4 == null &&
        floor5 == null) {
      return ['1st', _getRoom(floor1)];
    } else if (floor2 != null &&
        floor1 == null &&
        floor3 == null &&
        floor4 == null &&
        floor5 == null) {
      return ['2nd', _getRoom(floor2)];
    } else if (floor3 != null &&
        floor1 == null &&
        floor2 == null &&
        floor4 == null &&
        floor5 == null) {
      return ['3rd', _getRoom(floor3)];
    } else if (floor4 != null &&
        floor1 == null &&
        floor2 == null &&
        floor3 == null &&
        floor5 == null) {
      return ['4th', _getRoom(floor4)];
    } else if (floor5 != null &&
        floor1 == null &&
        floor2 == null &&
        floor3 == null &&
        floor4 == null) {
      return ['5th', _getRoom(floor5)];
    } else {
      return ['none', "none"];
    }
  }

  String _getRoom(RoomList? floor) {
    String room;
    switch (floor) {
      case RoomList.d1:
        room = "d1";
        break;
      case RoomList.d2:
        room = "d2";
        break;
      case RoomList.d3:
        room = "d3";
        break;
      case RoomList.d4:
        room = "d4";
        break;
      case RoomList.d5:
        room = "d5";
        break;
      case RoomList.d6:
        room = "d6";
        break;
      case RoomList.d7:
        room = "d7";
        break;
      case RoomList.d8:
        room = "d8";
        break;
      case RoomList.d9:
        room = "d9";
        break;
      case RoomList.d10:
        room = "d10";
        break;
      default:
        room = "";
        break;
    }
    return room;
  }
}

enum RoomList { d1, d2, d3, d4, d5, d6, d7, d8, d9, d10 }

enum GoTo {
  bedroom,
  lsb,
  vmb,
  gzb,
  abb,
  map,
  gymn,
  genRoomLSB,
  comLab502LSB,
  comLab503LSB,
  genRoomVMB,
  comLab301VMB,
  comLab302VMB,
  multimedia,
  gymnOpenArea,
  genRoomGZB,
  canteen,
  genRoomABB,
  library,
  facade,
}

// Portal system for tracking room transitions
Vector2? lastPortalPosition;
GoTo? lastMap;

// ---------------------MAIN GAME-----------------------
double height = 60;
double width = 60;
double mapHeight = height * 32;
double mapWidth = width * 32;
double zoomValue = 3.0;

class BSUniverseGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents {
  bool initialized = false;
  late final CameraComponent cameraComponent;
  late final PlayerComponent player;
  late final JoystickComponent joystick;
  late final GameSoundManager soundManager;
  Scene? currentScene;
  CameraComponent? currentCamera;

  // Player data management
  final PlayerData playerData = PlayerData();

  // Portal system for tracking room transitions
  Vector2? lastPortalPosition;
  GoTo? lastMap;
  FloorList? lastPortalSelection;

  // Button components
  late final StatusButtonComponent buttonA;
  late final StatusButtonComponent buttonB;
  late final StatusButtonComponent buttonC;
  late final StatusButtonComponent buttonD;
  late final MenuButtonComponent menuButton;
  late final MuteButtonComponent muteButton;
  
  // SpartaCoins system
  late final SpartaCoinsComponent spartaCoins;
  
  // Closet system - track unlocked outfits
  final Set<String> _unlockedOutfits = {'boy_uniform.png'}; // School uniform is unlocked by default

  // The whole Map is 30 x 40 Tiles where each tile is 32x32.
  // Bedroom 3 x 8
  // CECS Flor 39x38
  // GZB 57 x 39
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

      // Create menu button with consistent styling
      menuButton = MenuButtonComponent(
        size: Vector2.all(50),
        position: Vector2(30, 30), // Top left corner
        onPressed: showMenuScreen,
      );

      // Create mute button
      final muteButtonSize = Vector2.all(50);
      muteButton = MuteButtonComponent(
        position: MuteButtonComponent.getTopRightPosition(
          canvasSize,
          muteButtonSize,
        ),
        size: muteButtonSize,
      );

      // Initialize SpartaCoins with 10 initial coins
      spartaCoins = SpartaCoinsComponent(initialCoins: 10);

      // player.debugMode = true;
      player.debugColor = Colors.white;
      player.debugMode = true;

      debugMode = true;
      await changeScene(GoTo.bedroom, Vector2(104, 66));

      // Add UI components

      // Only add the scene returned by changeScene

      // Set up camera for the new scene

      initialized = true;
    } else {
      // Update button positions on resize
      updateButtonPositions(canvasSize);
    }
  }

  Future<void> changeScene(GoTo sceneName, Vector2 position) async {
    // Position Will Be removed as parameter and be set in here.
    // Remove current world/scene if any
    print("CURRENT SCENE $lastMap, $lastPortalPosition");
    if (currentScene != null) {
      remove(currentCamera!);
      remove(currentScene!); // Remove the entire old Scene (World) component
      currentScene = null; // Clear the reference
      currentCamera = null;
    }
    Vector2 playerSize = Vector2.all(32);
    dynamic playerSpeed = 80.0;
    if (sceneName == GoTo.map) {
      playerSpeed = 40.0;
    }
    Scene newScene = Scene(sceneName: sceneName, game: this);
    await newScene.initialize();
    print(newScene.sceneMap);
    currentScene = newScene;
    await add(currentScene!);
    await currentScene?.add(
      player
        ..size = playerSize
        ..moveSpeed = playerSpeed,
    );
    currentCamera = CameraComponent(world: currentScene)
      ..viewfinder.zoom = zoomValue
      ..viewfinder.anchor = Anchor.center
      ..follow(player..position = position);
    currentCamera?.viewport.add(joystick);
    currentCamera?.viewport.add(buttonD);
    currentCamera?.viewport.add(buttonC);
    currentCamera?.viewport.add(buttonB);
    currentCamera?.viewport.add(buttonA);
    currentCamera?.viewport.add(muteButton);
    currentCamera?.viewport.add(menuButton);
    currentCamera?.viewport.add(spartaCoins);
    currentCamera?.setBounds(
      Rectangle.fromCenter(
        center: Vector2.zero(),
        // Its zoomed in by 2,
        size: Vector2(mapWidth * 2.0, mapHeight * 2.0),
      ),
    );
    await add(currentCamera!);
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

    // Update menu button position
    menuButton.position = MenuButtonComponent.getTopLeftPosition(canvasSize, Vector2.all(50));

    // Update mute button position
    final muteButtonSize = Vector2.all(50);
    muteButton.position = MuteButtonComponent.getTopRightPosition(
      canvasSize,
      muteButtonSize,
    );
  }

  @override
  void update(double dt) async {
    if (isQuestActive || isClosetActive) return; // Pause game update when quest or closet is active
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

  // Handle quest completion (called from game screen)
  void completeCurrentQuest(int coinsEarned, int correctAnswers, int totalQuestions) {
    if (_currentActiveQuestId != null) {
      if (coinsEarned >= 0) {
        // Quest succeeded
        playerData.completeQuest(_currentActiveQuestId!, coinsEarned, correctAnswers, totalQuestions);
      } else {
        // Quest failed
        playerData.failQuest(_currentActiveQuestId!, -coinsEarned);
      }
      _currentActiveQuestId = null; // Clear current quest
    }
  }

  // Get current player coins for UI display
  int get playerCoins => playerData.coins;

  // Get player summary for menu display
  PlayerSummary get playerSummary => playerData.getSummary();

  // Quest state management
  void showQuestResultOverlay(bool isSuccess) {
    overlays.add(isSuccess ? 'QuestCompleted' : 'QuestFailed');
  }

  void hideQuestResultOverlay() {
    overlays.remove('QuestCompleted');
    overlays.remove('QuestFailed');
  }
  
  // Closet overlay management
  bool isClosetActive = false;
  
  void showClosetOverlay() {
    overlays.add('ClosetOverlay');
    isClosetActive = true;
  }

  void hideClosetOverlay() {
    print("Hiding closet overlay, isClosetActive was: $isClosetActive");
    overlays.remove('ClosetOverlay');
    isClosetActive = false;
    
    // Reset player movement state to ensure they can move again
    player.playerDirection = PlayerDirection.none;
    player.moveDirection = Vector2.zero();
    
    print("Closet overlay hidden, isClosetActive now: $isClosetActive");
  }
  
  Future<void> setPlayerOutfit(String newOutfit) async {
    print("setPlayerOutfit called with: $newOutfit");
    print("Current player outfit: ${player.currentSpriteSheet}");
    
    try {
      await player.changeSpriteSheet(newOutfit);
      print("Player outfit changed successfully to: $newOutfit");
      print("Player current sprite sheet is now: ${player.currentSpriteSheet}");
    } catch (e) {
      print("Error changing player outfit: $e");
    }
  }
  
  // SpartaCoins management methods
  
  /// Gets the current amount of SpartaCoins
  int getSpartaCoins() {
    return spartaCoins.coins;
  }
  
  /// Adds SpartaCoins to the player's total
  void addSpartaCoins(int amount) {
    spartaCoins.addCoins(amount);
  }
  
  /// Removes SpartaCoins from the player's total (won't go below 0)
  void removeSpartaCoins(int amount) {
    spartaCoins.removeCoins(amount);
  }
  
  /// Sets the SpartaCoins to a specific amount
  void setSpartaCoins(int amount) {
    spartaCoins.updateCoins(amount);
  }
  
  /// Gets the set of unlocked outfits
  Set<String> getUnlockedOutfits() {
    return Set.from(_unlockedOutfits);
  }
  
  /// Unlocks a new outfit (for future use - like rewards from quests)
  void unlockOutfit(String spriteFileName) {
    _unlockedOutfits.add(spriteFileName);
  }
  
  /// Handles coin rewards/deductions from quest completion
  void handleQuestCoinReward(int coinsEarned) {
    if (coinsEarned > 0) {
      addSpartaCoins(coinsEarned);
    } else if (coinsEarned < 0) {
      removeSpartaCoins(-coinsEarned); // Convert negative to positive for removal
    }
    // If coinsEarned is 0, no change is made
  }
  
  // Player sprite configuration - now gets it from the actual player component
  PlayerSpriteConfig getCurrentPlayerSprite() {
    // Get the sprite configuration from the actual player component
    return player.getCurrentSpriteConfig();
  }

  // NPC sprite configuration - to be updated when NPC interaction system is implemented
  NPCSpriteConfig getCurrentNPCSprite() {
    // TODO: Replace with actual NPC that the player is interacting with
    // For now, return default NPC sprite
    return NPCSpriteConfig.sirtNPC;
  }

  // Method to change player outfit (now functional!)
  Future<void> changePlayerOutfit(String spriteSheetName) async {
    await player.changeSpriteSheet(spriteSheetName);
  }

  // Examples of how to use the dynamic outfit system:
  // await game.changePlayerOutfit('boy_uniform.png');  // School uniform
  // await game.changePlayerOutfit('boy_pe.png');       // PE uniform
  // await game.changePlayerOutfit('boy_casual.png');   // Casual clothes
  // The quest overlay will automatically show the correct sprite!

  // Example methods for future implementation:

  // Method to start quest with specific NPC (to be implemented with NPC system)
  // void startQuestWithNPC(String npcId, String question, List<String> options, int correctAnswer) {
  //   // Get NPC sprite configuration based on npcId
  //   NPCSpriteConfig npcConfig;
  //   switch (npcId) {
  //     case 'teacher':
  //       npcConfig = NPCSpriteConfig.teacherNPC;
  //       break;
  //     case 'student':
  //       npcConfig = NPCSpriteConfig.studentNPC;
  //       break;
  //     case 'janitor':
  //       npcConfig = NPCSpriteConfig.janitorNPC;
  //       break;
  //     default:
  //       npcConfig = NPCSpriteConfig.sirtNPC;
  //   }
  //
  //   // Show quest overlay with the specific NPC and current player sprite
  //   showQuestOverlay();
  // }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyQ) {
      showQuestOverlay();
      return KeyEventResult.handled;
    }
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyM) {
      showMenuScreen();
      return KeyEventResult.handled;
    }
    
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.keyC) {
      if (!isClosetActive && !isQuestActive) {
        showClosetOverlay();
      }
      return KeyEventResult.handled;
    }
    
    return super.onKeyEvent(event, keysPressed);
  }

  // Menu screen overlay controls
  void showMenuScreen() {
    overlays.add('MenuScreen');
  }

  void hideMenuScreen() {
    overlays.remove('MenuScreen');
  }

  // Quest dialogue overlay controls
  void showQuestDialogue(PopupConfig questConfig) {
    overlays.add('QuestDialogue');
    // Store quest config for overlay access
    _currentQuestConfig = questConfig;
  }

  void hideQuestDialogue() {
    overlays.remove('QuestDialogue');
    _currentQuestConfig = null;
  }

  void onQuestAccepted(PopupConfig questConfig) {
    // Handle quest acceptance using player data system
    playerData.acceptQuest(
      questConfig.id,
      questConfig.questTitle,
      questConfig.location,
      questConfig.coinsReward,
      questConfig.coinsPenalty,
    );
    
    // Store the current quest ID for completion tracking
    _currentActiveQuestId = questConfig.id;
    
    hideQuestDialogue();
    
    // Start the actual quest with randomized questions
    showQuestOverlay();
  }

  void onQuestDeclined(PopupConfig questConfig) {
    // Handle quest decline using player data system
    playerData.declineQuest(questConfig.id);
    
    hideQuestDialogue();
  }

  // Task discovery notification
  void showTaskDiscoveryNotification(int taskCount) {
    overlays.add('TaskDiscovery');
    _discoveredTaskCount = taskCount;
  }

  void hideTaskDiscoveryNotification() {
    overlays.remove('TaskDiscovery');
    _discoveredTaskCount = 0;
  }

  // Store current quest config for overlay access
  PopupConfig? _currentQuestConfig;
  PopupConfig? get currentQuestConfig => _currentQuestConfig;

  // Store discovered task count
  int _discoveredTaskCount = 0;
  int get discoveredTaskCount => _discoveredTaskCount;

  // Store current active quest ID for completion tracking
  String? _currentActiveQuestId;
  String? get currentActiveQuestId => _currentActiveQuestId;
}

// Portal Component that handles scene transitions
class Portal extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BSUniverseGame> {
  final GoTo destination;
  final TiledComponent map;
  final Vector2 startingPosition;
  final FloorList selection;
  Portal({
    required this.map,
    required this.destination,
    required this.startingPosition,
    required this.selection,
  }) : super(paint: Paint()..color = const Color.fromARGB(255, 0, 0, 0));

  @override
  Future<void> onLoad() async {
    add(
      RectangleHitbox()
        ..collisionType = CollisionType.passive
        // ..debugMode = true
        ..debugColor = Color.fromARGB(255, 0, 234, 255),
    );
  }

  // void getNameTag
  // use SWITCH CASE

  @override
  Future<void> onCollision(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) async {
    super.onCollision(intersectionPoints, other);

    // Store portal information for return journey
    print("leave room spawnpoint ${selection.leaveRoomSpawnPoint}");
    lastPortalPosition = selection.leaveRoomSpawnPoint;
    lastMap = _getCurrentMap();

    await game.changeScene(destination, startingPosition);
  }

  GoTo _getCurrentMap() {
    // Determine current map based on the current scene
    if (game.currentScene?.sceneName != null) {
      return game.currentScene!.sceneName;
    }
    return GoTo.map; // fallback
  }
}

// Popup Component that handles NPC interactions
class Popup extends SpriteComponent
  with HasGameReference<BSUniverseGame>, CollisionCallbacks {
  final String location;
  final String dialogue;
  final String image;
  final String questTitle;
  final String questDescription;
  final int coinsReward;
  final int coinsPenalty;
  final VoidCallback onInteract;
  bool _hasTriggered = false;

  Popup({
  required Vector2 position,
  required Vector2 size,
  required this.location,
  required this.dialogue,
  required this.image,
  required this.questTitle,
  required this.questDescription,
  this.coinsReward = 5,
  this.coinsPenalty = 2,
  required this.onInteract,
  }) : super(
     position: position,
     size: size,
     );
  @override
  Future<void> onLoad() async {
  sprite = await Sprite.load(image);
  
  add(
    RectangleHitbox(
      size: size / 3,
      position: Vector2(size.x/2, 5),
      anchor: Anchor.center,
    )
    ..collisionType = CollisionType.passive
  );
  }

  @override
  Future<void> onCollision(
  Set<Vector2> intersectionPoints,
  PositionComponent other,
  ) async {
  super.onCollision(intersectionPoints, other);

  if (!_hasTriggered) {
    _hasTriggered = true;
    print('Popup triggered at $location');
    
    // Show quest dialogue instead of quest overlay
    onInteract();

    // Remove collision hitbox to prevent further triggers
    removeAll(children.whereType<RectangleHitbox>());
    sprite = null;
  }
  }
}

class Scene extends World {
  final GoTo sceneName;
  final BSUniverseGame game;
  TiledComponent? sceneMap;
  Vector2? playerSpawnPosition;
  double? zoom;
  int? width;
  int? height;
  Scene({required this.sceneName, required this.game});

  Future<void> initialize() async {
    switch (sceneName) {
      case GoTo.facade:
        sceneMap = await _setMap("facade");
        break;
      case GoTo.bedroom:
        sceneMap = await _setMap("bedroom");
        break;
      case GoTo.map:
        sceneMap = await _setMap("mapBsu");
        break;
      case GoTo.lsb:
        sceneMap = await _setMap("lsb");
        break;
      case GoTo.vmb:
        sceneMap = await _setMap("vmb");
        break;
      case GoTo.gzb:
        sceneMap = await _setMap("gzb");
        break;
      case GoTo.gymn:
        sceneMap = await _setMap("gymn");
        break;
      case GoTo.genRoomLSB:
        sceneMap = await _setMap("lsbRoom");
        break;
      case GoTo.comLab502LSB:
        sceneMap = await _setMap("comLab502Lsb");
        break;
      case GoTo.comLab503LSB:
        sceneMap = await _setMap("comLab503Lsb");
        break;
      case GoTo.genRoomVMB:
        sceneMap = await _setMap("vmbRoom");
        break;
      case GoTo.comLab301VMB:
        sceneMap = await _setMap("comLab301Vmb");
        break;
      case GoTo.comLab302VMB:
        sceneMap = await _setMap("comLab302Vmb");
        break;
      case GoTo.multimedia:
        sceneMap = await _setMap("multimedia");
        break;
      case GoTo.gymnOpenArea:
        sceneMap = await _setMap("gymnOpenArea");
        break;
      case GoTo.genRoomGZB:
        sceneMap = await _setMap("gzbRoom");
        break;
      case GoTo.canteen:
        sceneMap = await _setMap("canteen");
        break;
      case GoTo.abb:
        sceneMap = await _setMap("abb");
        break;
      case GoTo.genRoomABB:
        sceneMap = await _setMap("abbRoom");
        break;
      case GoTo.library:
        sceneMap = await _setMap("libraryRoom");
        break;
    }
    print(sceneName);
    add(sceneMap as Component);
  }

  Future<TiledComponent> _setMap(String map) async {
    TiledComponent mapTiled = await TiledComponent.load(
      tmxConfig[map]?["image"] ?? "",
      Vector2.all(32),
      priority: -1,
    );

    _setZoomCam(
      tmxConfig[map]?["zoom"],
      tmxConfig[map]?["w"],
      tmxConfig[map]?["h"],
    );
    _setUpCollisions(mapTiled);
    _setUpPortals(mapTiled, map);
    _setUpPopups(mapTiled);
    return mapTiled;
  }

  Future<void> _setZoomCam(double z, int w, int h) async {
    zoomValue = z;
    width = w;
    height = h;
    print(zoom);
    print(width);
    print(height);
  }

  Future<void> _setUpCollisions(TiledComponent map) async {
    final collisions = map.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisions != null) {
      for (final obj in collisions.objects) {
        map.add(
          Collision(
            Vector2(obj.x, obj.y),
            Vector2(obj.width, obj.height),
            ColType.back,
            GoTo.gzb,
          ),
        );
      }
    }
  }

  Future<void> _setUpPortals(TiledComponent map, String mapName) async {
    // Handles RoomPortals group folder, with subgroups 1st, 2nd, etc.
    print("I WAS ABLE TO LAYOUT ALL THE PORTALS!");
    switch (mapName) {
      case "facade":
        print("IM AT FACADE");
        setUpFacade(map);
        break;
      case "bedroom":
        setUpBedroom(map);
        break;
      case "mapBsu":
        setUpMapBsu(map);
        break;
      case "lsb":
        setUpLsb(map);
        break;
      case "vmb":
        setUpVmb(map);
        break;
      case "gzb":
        setUpGzb(map);
        break;
      case "gymn":
        setUpGymn(map);
        break;
      case "lsbRoom":
        setUpLsbRoom(map);
        break;
      case "comLab502Lsb":
        setUpComLab502Lsb(map);
        break;
      case "comLab503Lsb":
        setUpComLab503Lsb(map);
        break;
      case "vmbRoom":
        setUpVmbRoom(map);
        break;
      case "comLab301Vmb":
        setUpComLab301Vmb(map);
        break;
      case "comLab302Vmb":
        setUpComLab302Vmb(map);
        break;
      case "multimedia":
        setUpMultimedia(map);
        break;
      case "gymnOpenArea":
        setUpGymnOpenArea(map);
        break;
      case "gzbRoom":
        setUpGzbRoom(map);
        break;
      case "canteen":
        setUpCanteen(map);
        break;
      case "abb":
        setUpAbb(map);
        break;
      case "abbRoom":
        setUpAbbRoom(map);
        break;
      case "libraryRoom":
        setUpLibraryRoom(map);
        break;
      default:
        setUpLsb(map);
        break;
    }
  }

  Future<void> _setUpPopups(TiledComponent map) async {
    // Get the current scene name to determine popup count and type
    final sceneNameStr = sceneName.name.toLowerCase(); // Use .name to get enum string
    
    // Get popup configurations for this scene
    final popupConfigs = PopupConfigs.getPopupsForScene(sceneNameStr);
    
    // Get available popup positions from TMX file
    final popupsGroup = map.tileMap.getLayer<Group>('Popups');
    if (popupsGroup != null && popupConfigs.isNotEmpty) {
      final availablePositions = <TiledObject>[];
      
      // Collect all available popup positions
      for (final subGroup in popupsGroup.layers.whereType<ObjectGroup>()) {
        availablePositions.addAll(subGroup.objects);
      }
      
      if (availablePositions.isNotEmpty) {
        // Shuffle positions for randomness
        availablePositions.shuffle();
        
        // Create popups up to the number of available positions or configs
        final maxPopups = math.min(popupConfigs.length, availablePositions.length);
        
        for (int i = 0; i < maxPopups; i++) {
          final config = popupConfigs[i];
          final position = availablePositions[i];
          
          final popup = Popup(
            position: Vector2(position.x, position.y),
            size: Vector2(position.width, position.height),
            location: config.location,
            dialogue: config.dialogue,
            questTitle: config.questTitle,
            questDescription: config.questDescription,
            coinsReward: config.coinsReward,
            coinsPenalty: config.coinsPenalty,
            image: config.image,
            onInteract: () {
              // Show quest dialogue overlay
              game.showQuestDialogue(config);
            },
          );

          map.add(popup);
        }
        
        // Show task discovery notification
        if (maxPopups > 0) {
          game.showTaskDiscoveryNotification(maxPopups);
        }
      }
    }
  }
}
