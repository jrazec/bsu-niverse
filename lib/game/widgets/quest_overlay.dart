import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:bsuniverse/game/sound_manager.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

/// Quest Overlay System with Configurable Sprites and Rich Animations
/// 
/// This system provides a complete quest interaction experience with:
/// - Dynamic player and NPC sprite rendering (supports both sprite sheets and single images)
/// - Heart-based life system with animated feedback
/// - 3-question quest flow with shared lives across questions
/// - Rich visual feedback: sparkles for correct answers, anger/sweat reactions for wrong answers
/// - Responsive design that adapts to different screen sizes
/// - Coin reward system based on performance
/// 
/// Sprite Configuration Examples:
/// 
/// 1. For sprite sheet characters (like player):
///    PlayerSpriteConfig(
///      imagePath: 'player_spritesheet.png',
///      frameIndex: 3, // Frame number for dialogue pose
///      isSpriteSheet: true,
///    )
/// 
/// 2. For single image NPCs:
///    NPCSpriteConfig(
///      imagePath: 'npc_image.png',
///      isSpriteSheet: false,
///    )
/// 
/// 3. For sprite sheet NPCs:
///    NPCSpriteConfig(
///      imagePath: 'npc_spritesheet.png',
///      frameIndex: 0, // Frame number for standing pose
///      isSpriteSheet: true,
///    )
/// 
/// Future Implementation:
/// - Connect to player outfit system by updating getCurrentPlayerSprite()
/// - Connect to NPC interaction system by updating getCurrentNPCSprite()
/// - Add dynamic quest parameters based on interacted NPC

// Custom widget to render a full image (for NPCs that are single images, not sprite sheets)
class FlameImageWidget extends StatelessWidget {
  final FlameGame game;
  final String imagePath;
  final double width;
  final double height;

  const FlameImageWidget({
    Key? key,
    required this.game,
    required this.imagePath,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _loadImage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomPaint(
            size: Size(width, height),
            painter: _SpriteFramePainter(snapshot.data!),
          );
        } else if (snapshot.hasError) {
          return Container(
            width: width,
            height: height,
            color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: width * 0.3, color: Colors.white),
                Text('NPC', style: TextStyle(color: Colors.white, fontSize: width * 0.1)),
              ],
            ),
          );
        }
        return Container(
          width: width,
          height: height,
          color: Colors.grey.withOpacity(0.3),
          child: Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  Future<ui.Image> _loadImage() async {
    try {
      return await game.images.load(imagePath);
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }
}

// Custom widget to render a specific sprite frame from a sprite sheet
class SpriteFrameWidget extends StatelessWidget {
  final FlameGame game;
  final String imagePath;
  final int frameIndex;
  final double width;
  final double height;

  const SpriteFrameWidget({
    Key? key,
    required this.game,
    required this.imagePath,
    required this.frameIndex,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _loadSpriteFrame(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomPaint(
            size: Size(width, height),
            painter: _SpriteFramePainter(snapshot.data!),
          );
        } else if (snapshot.hasError) {
          return Container(
            width: width,
            height: height,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.boy, size: width * 0.4, color: Colors.white),
                Text('PLAYER', style: TextStyle(color: Colors.white, fontSize: width * 0.1)),
              ],
            ),
          );
        }
        return Container(
          width: width,
          height: height,
          color: Colors.grey.withOpacity(0.3),
          child: Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  Future<ui.Image> _loadSpriteFrame() async {
    try {
      final image = await game.images.load(imagePath);
      
      // Calculate frame position in sprite sheet
      // Assuming 32x32 frames and the sprite sheet is arranged in rows
      final frameWidth = 32;
      final frameHeight = 32;
      final framesPerRow = image.width ~/ frameWidth;
      
      final sourceX = (frameIndex % framesPerRow) * frameWidth;
      final sourceY = (frameIndex ~/ framesPerRow) * frameHeight;
      
      // Create a new canvas to draw the specific frame
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // Draw the specific frame from the sprite sheet
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(sourceX.toDouble(), sourceY.toDouble(), frameWidth.toDouble(), frameHeight.toDouble()),
        Rect.fromLTWH(0, 0, width, height),
        Paint(),
      );
      
      final picture = recorder.endRecording();
      return await picture.toImage(width.toInt(), height.toInt());
    } catch (e) {
      throw Exception('Failed to load sprite frame: $e');
    }
  }
}

class _SpriteFramePainter extends CustomPainter {
  final ui.Image image;
  
  _SpriteFramePainter(this.image);
  
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


// Configuration class for player sprite data
class PlayerSpriteConfig {
  final String imagePath;
  final int frameIndex;
  final bool isSpriteSheet;

  const PlayerSpriteConfig({
    required this.imagePath,
    required this.frameIndex,
    this.isSpriteSheet = true,
  });
}

// Configuration class for NPC sprite data
class NPCSpriteConfig {
  final String imagePath;
  final bool isSpriteSheet;
  final int frameIndex; // Only used if isSpriteSheet is true

  const NPCSpriteConfig({
    required this.imagePath,
    this.isSpriteSheet = false,
    this.frameIndex = 0,
  });
  
  // Current NPC configuration (referenced in BSUniverseGame)
  static const NPCSpriteConfig sirtNPC = NPCSpriteConfig(
    imagePath: 'sirt.png',
    isSpriteSheet: false,
  );
}

// Data class for quest questions
class QuestQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  const QuestQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuestOverlay extends StatefulWidget {
  final FlameGame game;
  final List<QuestQuestion> questions; // List of all questions in the quest
  final void Function(int, bool, bool, int, int) onOptionSelected; // questIndex, isCorrect, isQuestComplete, coinsEarned, correctAnswers
  final int initialHearts; // Initial hearts count
  final PlayerSpriteConfig playerSprite; // Player sprite configuration
  final NPCSpriteConfig npcSprite; // NPC sprite configuration
  

  const QuestOverlay({
    Key? key,
    required this.game,
    required this.questions,
    required this.onOptionSelected,
    required this.playerSprite,
    required this.npcSprite,
    this.initialHearts = 3,
  }) : super(key: key);

  @override
  State<QuestOverlay> createState() => _QuestOverlayState();
}

class _QuestOverlayState extends State<QuestOverlay> with TickerProviderStateMixin {
  // Animation constants
  static const int _sparkleCount = 6;
  static const int _baseAnimationDuration = 1000;
  static const int _animationDurationVariation = 400;
  static const int _minSparkleDelay = 50;
  static const int _maxSparkleDelayVariation = 150;
  static const double _baseScaleFactor = 400.0;
  static const double _maxScaleFactor = 2.5;
  
  // UI constants
  static const Duration _feedbackDisplayDuration = Duration(milliseconds: 3000);
  static const Duration _animationResetDelay = Duration(milliseconds: 100);
  static const int _totalQuestions = 3;
  static const int _maxHearts = 3;
  
  // Coin reward constants
  static const int _perfectScoreReward = 5;  // 3 hearts remaining
  static const int _goodScoreReward = 3;     // 2 hearts remaining  
  static const int _passScoreReward = 1;     // 1 heart remaining
  static const int _failurePenalty = -2;     // Quest failed
  
  late int hearts;
  late int currentQuestionIndex;
  late int correctAnswers; // Track number of correct answers
  int? selectedAnswerIndex; // Track which answer was selected
  bool isAnswerSelected = false; // Prevent multiple selections
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  late AnimationController _heartBreakController;
  late Animation<double> _heartBreakFadeAnimation;
  late Animation<double> _heartBreakMoveAnimation;
  int? breakingHeartIndex; // Track which heart is breaking
  
  // NPC and Player reaction animations
  late AnimationController _npcReactionController;
  late Animation<double> _npcShakeAnimation;
  late AnimationController _playerReactionController;
  late Animation<double> _playerDropFadeAnimation;
  late Animation<double> _playerDropMoveAnimation;
  
  // Individual sparkle controllers for randomized animations
  late List<AnimationController> _sparkleControllers;
  late List<Animation<double>> _sparkleScaleAnimations;
  late List<Animation<double>> _sparkleOpacityAnimations;
  late ValueNotifier<bool> _sparkleVisibilityNotifier; // Use ValueNotifier to avoid rebuilds
  
  bool showNpcAnger = false;
  bool showPlayerSweat = false;

  @override
  void initState() {
    super.initState();
    hearts = widget.initialHearts;
    currentQuestionIndex = 0;
    correctAnswers = 0;
    _sparkleVisibilityNotifier = ValueNotifier<bool>(false);
    
    // Initialize shake animation for wrong answers
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.elasticIn,
    ));
    
    // Initialize heart break animation
    _heartBreakController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _heartBreakFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _heartBreakController,
      curve: Curves.easeOut,
    ));
    _heartBreakMoveAnimation = Tween<double>(
      begin: 0.0,
      end: 30.0,
    ).animate(CurvedAnimation(
      parent: _heartBreakController,
      curve: Curves.easeOut,
    ));
    
    // Initialize NPC reaction animation (anger shake)
    _npcReactionController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _npcShakeAnimation = Tween<double>(
      begin: 0,
      end: 8,
    ).animate(CurvedAnimation(
      parent: _npcReactionController,
      curve: Curves.elasticInOut,
    ));
    
    // Initialize Player reaction animation (sweat drop)
    _playerReactionController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _playerDropFadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _playerReactionController,
      curve: Curves.easeOut,
    ));
    _playerDropMoveAnimation = Tween<double>(
      begin: 0.0,
      end: 25.0,
    ).animate(CurvedAnimation(
      parent: _playerReactionController,
      curve: Curves.easeOut,
    ));
    
    // Initialize individual sparkle animations for randomized effects
    _initializeSparkleAnimations();
  }
  
  void _initializeSparkleAnimations() {
    final random = math.Random();
    
    // Initialize controllers with randomized durations
    _sparkleControllers = List.generate(_sparkleCount, (index) {
      return AnimationController(
        duration: Duration(milliseconds: (_baseAnimationDuration + random.nextInt(_animationDurationVariation)).round()),
        vsync: this,
      );
    });
    
    // Create scale animations with randomized curves and values
    _sparkleScaleAnimations = _sparkleControllers.map((controller) {
      return _createSparkleScaleAnimation(controller, random);
    }).toList();
    
    // Create opacity animations
    _sparkleOpacityAnimations = _sparkleControllers.map((controller) {
      return _createSparkleOpacityAnimation(controller);
    }).toList();
  }
  
  Animation<double> _createSparkleScaleAnimation(AnimationController controller, math.Random random) {
    final minScale = 0.3 + random.nextDouble() * 0.2; // 0.3-0.5 (more stable range)
    final maxScale = 1.0 + random.nextDouble() * 0.5; // 1.0-1.5 (more controlled range)
    final curves = [Curves.elasticOut, Curves.bounceOut];
    final curve = curves[random.nextInt(curves.length)];
    
    return Tween<double>(
      begin: minScale,
      end: maxScale,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: curve,
    ));
  }
  
  Animation<double> _createSparkleOpacityAnimation(AnimationController controller) {
    return TweenSequence<double>([
      // Rapid appearance
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeIn)),
        weight: 10,
      ),
      // Sparkle/flicker effect
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.3).chain(CurveTween(curve: Curves.ease)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.3, end: 1.0).chain(CurveTween(curve: Curves.ease)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.5).chain(CurveTween(curve: Curves.ease)),
        weight: 15,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.0).chain(CurveTween(curve: Curves.ease)),
        weight: 15,
      ),
      // Final fade out
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
    ]).animate(controller);
  }
  
  void _startSparkleAnimations() {
    final random = math.Random();
    int completedAnimations = 0;
    
    // Start each sparkle with a random delay for natural effect
    for (int i = 0; i < _sparkleControllers.length; i++) {
      final delay = Duration(milliseconds: (_minSparkleDelay + random.nextInt(_maxSparkleDelayVariation)).round());
      Future.delayed(delay, () {
        if (mounted) {
          _sparkleControllers[i].forward().then((_) {
            if (mounted) {
              _sparkleControllers[i].reset();
              completedAnimations++;
              
              // Hide sparkles when all animations complete
              if (completedAnimations >= _sparkleControllers.length) {
                Future.delayed(_animationResetDelay, () {
                  if (mounted) {
                    // Only update sparkle visibility without triggering a full rebuild
                    _sparkleVisibilityNotifier.value = false;
                    // No setState call here to avoid flickering
                  }
                });
              }
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _heartBreakController.dispose();
    _npcReactionController.dispose();
    _playerReactionController.dispose();
    _sparkleVisibilityNotifier.dispose();
    // Dispose all sparkle controllers
    for (final controller in _sparkleControllers) {
      controller.dispose();
    }
    super.dispose();
  }
  
  // Constants for sparkle positioning and styling
  static const List<Map<String, dynamic>> _sparkleConfigs = [
    {'top': 50.0, 'left': 30.0, 'scale': 1.0, 'opacity': 1.0, 'fontSize': 40.0},
    {'top': 80.0, 'right': 50.0, 'scale': 0.8, 'opacity': 0.9, 'fontSize': 36.0},
    {'topPercent': 0.4, 'right': 20.0, 'scale': 0.9, 'opacity': 0.8, 'fontSize': 38.0},
    {'bottomPercent': 0.25, 'left': 40.0, 'scale': 0.7, 'opacity': 0.85, 'fontSize': 34.0},
    {'bottomPercent': 0.3, 'right': 35.0, 'scale': 0.6, 'opacity': 0.7, 'fontSize': 32.0},
    {'topPercent': 0.35, 'left': 15.0, 'scale': 0.75, 'opacity': 0.8, 'fontSize': 35.0},
  ];
  
  Widget _buildSparkle(int index, double screenHeight) {
    // Bounds checking to prevent index out of range errors
    if (index >= _sparkleConfigs.length || 
        index >= _sparkleControllers.length ||
        index >= _sparkleScaleAnimations.length ||
        index >= _sparkleOpacityAnimations.length) {
      return const SizedBox.shrink(); // Return empty widget if index is out of bounds
    }
    
    final config = _sparkleConfigs[index];
    
    // Safe positioning calculations
    final topPosition = config['top']?.toDouble() ?? 
        (config['topPercent'] != null ? (config['topPercent']! as double) * screenHeight : null);
    final bottomPosition = config['bottom']?.toDouble() ?? 
        (config['bottomPercent'] != null ? (config['bottomPercent']! as double) * screenHeight : null);
    
    return Positioned(
      top: topPosition,
      bottom: bottomPosition,
      left: config['left']?.toDouble(),
      right: config['right']?.toDouble(),
      child: Transform.scale(
        scale: _sparkleScaleAnimations[index].value * (config['scale']! as double),
        child: Opacity(
          opacity: _sparkleOpacityAnimations[index].value * (config['opacity']! as double),
          child: Text(
            '✨',
            style: TextStyle(
              fontSize: (config['fontSize']! as double),
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  QuestQuestion get currentQuestion => widget.questions[currentQuestionIndex];

  void _handleOptionSelected(int index) async {
    if (isAnswerSelected) return; // Prevent multiple selections
    
    final isCorrect = index == currentQuestion.correctAnswerIndex;
    
    // Update state immediately to show color feedback
    setState(() {
      selectedAnswerIndex = index;
      isAnswerSelected = true;
    });
    
    if (isCorrect) {
      // Correct answer - increment counter and show sparkles
      // Play correct answer sound effect
      GameSoundManager().playQuestCorrectAnswerSound();
      
      // Batch state updates and start animations immediately to reduce rebuilds
      correctAnswers++;
      _sparkleVisibilityNotifier.value = true;
      
      // Start individual sparkle animations with random delays without setState
      _startSparkleAnimations();
      
      // Only trigger one setState for UI feedback
      setState(() {
        // State already updated above
      });
    } else {
      // Wrong answer - lose a heart, show anger/sweat animations
      // Play wrong answer sound effect
      GameSoundManager().playQuestWrongAnswerSound();
      
      setState(() {
        breakingHeartIndex = hearts - 1; // Set which heart is breaking (0-based index)
        hearts--;
        showNpcAnger = true;
        showPlayerSweat = true;
      });
      _shakeController.forward().then((_) => _shakeController.reset());
      
      // Start heart break animation
      _heartBreakController.forward().then((_) {
        // Reset the heart break animation and clear the breaking heart index
        _heartBreakController.reset();
        setState(() {
          breakingHeartIndex = null;
        });
      });
      
      // Start NPC anger animation
      _npcReactionController.forward().then((_) {
        _npcReactionController.reset();
        setState(() {
          showNpcAnger = false;
        });
      });
      
      // Start player sweat animation
      _playerReactionController.forward().then((_) {
        _playerReactionController.reset();
        setState(() {
          showPlayerSweat = false;
        });
      });
    }
    
    // Wait for 3 seconds to show the feedback colors and animations
    await Future.delayed(_feedbackDisplayDuration);
    
    // Check if quest should end (either no hearts left or last question completed)
    final bool isQuestComplete;
    final int coinsEarned;
    
    if (hearts <= 0) {
      // Quest failed - no hearts left
      isQuestComplete = true;
      coinsEarned = _failurePenalty;
      // Play quest failed sound effect
      GameSoundManager().playQuestFailedSound();
    } else if (currentQuestionIndex >= widget.questions.length - 1) {
      // Last question completed with hearts remaining
      isQuestComplete = true;
      // Play quest complete sound effect
      GameSoundManager().playQuestCompleteSound();
      
      // Calculate coin reward based on hearts remaining
      switch (hearts) {
        case 3:
          coinsEarned = _perfectScoreReward;
          break;
        case 2:
          coinsEarned = _goodScoreReward;
          break;
        case 1:
          coinsEarned = _passScoreReward;
          break;
        default:
          coinsEarned = 0;
      }
    } else {
      // Move to next question
      isQuestComplete = false;
      coinsEarned = 0;
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null; // Reset for next question
        isAnswerSelected = false;
      });
    }
    
    widget.onOptionSelected(currentQuestionIndex, isCorrect, isQuestComplete, coinsEarned, correctAnswers);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLandscape = screenWidth > screenHeight;
    
    // Calculate scaling factor based on screen size
    // Base sizes are optimized for mobile (~360-400dp width)
    final double scaleFactor = (screenWidth / _baseScaleFactor).clamp(1.0, _maxScaleFactor);
    
    final double npcWidth = (isLandscape ? 95 : 150) * scaleFactor;
    final double npcHeight = (isLandscape ? 95 : 150) * scaleFactor;
    
    
    final double playerWidth = (isLandscape ? 120 : 240) * scaleFactor;
    final double playerHeight = (isLandscape ? 120 : 240) * scaleFactor;
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 225, 247, 255),
             Color.fromARGB(255, 201, 233, 244),
            Color.fromARGB(255, 225, 232, 173),
            Color.fromARGB(255, 198, 90, 76), 
          ],
        ),
      ),
      child: Stack(
        children: [
          // Sparkles animation for correct answers - positioned around entire overlay
          // Using ValueListenableBuilder to prevent character sprite rebuilds
          ValueListenableBuilder<bool>(
            valueListenable: _sparkleVisibilityNotifier,
            builder: (context, showSparkles, child) {
              return AnimatedBuilder(
                animation: Listenable.merge(_sparkleControllers),
                builder: (context, child) {
                  if (!showSparkles || _sparkleControllers.isEmpty || 
                      _sparkleScaleAnimations.isEmpty || _sparkleOpacityAnimations.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  
                  return Stack(
                    children: List.generate(
                      math.min(_sparkleControllers.length, _sparkleConfigs.length), 
                      (index) => _buildSparkle(index, screenHeight)
                    ),
                  );
                },
              );
            },
          ),
          
          // Hearts and progress indicator (top left) - consistent size
          Positioned(
            top: 30,
            left: isLandscape ? screenWidth * 0.15 : 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hearts indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 3,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_maxHearts, (index) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Regular heart (filled or empty)
                            Text(
                              index < hearts ? '❤️' : '🖤',
                              style: TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            // Breaking heart animation overlay
                            if (breakingHeartIndex == index)
                              AnimatedBuilder(
                                animation: _heartBreakController,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _heartBreakMoveAnimation.value),
                                    child: Opacity(
                                      opacity: _heartBreakFadeAnimation.value,
                                      child: Text(
                                        '💔',
                                        style: TextStyle(
                                          fontSize: 20,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(height: 8),
                // Question progress indicator
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                  child: Text(
                    'Q ${currentQuestionIndex + 1}/$_totalQuestions',
                    style: TextStyle(
                      fontFamily: 'VT323',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // NPC sprite (top right) - responsive positioning
          // Wrapped in RepaintBoundary to prevent unnecessary rebuilds
          Positioned(
            top: isLandscape ? 25 : screenHeight * 0.15,
            right: isLandscape ? screenWidth * 0.15 : 30,
            child: RepaintBoundary(
              child: Stack(
                children: [
                  Container(
                    width: npcWidth,
                    height: npcHeight,
                    child: widget.npcSprite.isSpriteSheet
                        ? SpriteFrameWidget(
                            game: widget.game,
                            imagePath: widget.npcSprite.imagePath,
                            frameIndex: widget.npcSprite.frameIndex,
                            width: npcWidth,
                            height: npcHeight,
                          )
                        : FlameImageWidget(
                            game: widget.game,
                            imagePath: widget.npcSprite.imagePath,
                            width: npcWidth,
                            height: npcHeight,
                          ),
                  ),
                  // NPC anger animation (💢)
                  if (showNpcAnger)
                    Positioned(
                      top: 25,
                      right: 25,
                      child: AnimatedBuilder(
                        animation: _npcReactionController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                              _npcShakeAnimation.value * ((_npcReactionController.value * 10).round() % 2 == 0 ? 1 : -1),
                              0,
                            ),
                            child: Text(
                              '💢',
                              style: TextStyle(
                                fontSize: 36,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Player sprite (bottom left) - responsive positioning
          // Wrapped in RepaintBoundary to prevent unnecessary rebuilds
          Positioned(
            bottom: isLandscape ? screenHeight * 0.20 : screenHeight * 0.40,
            left: isLandscape ? screenWidth * 0.15 : 15, // Better positioning in landscape
            child: RepaintBoundary(
              child: Stack(
                children: [
                  Container(
                    width: playerWidth,
                    height: playerHeight,
                    child: widget.playerSprite.isSpriteSheet
                        ? SpriteFrameWidget(
                            game: widget.game,
                            imagePath: widget.playerSprite.imagePath,
                            frameIndex: widget.playerSprite.frameIndex,
                            width: playerWidth,
                            height: playerHeight,
                          )
                        : FlameImageWidget(
                            game: widget.game,
                            imagePath: widget.playerSprite.imagePath,
                            width: playerWidth,
                            height: playerHeight,
                          ),
                  ),
                  // Player sweat drop animation (💧)
                  if (showPlayerSweat)
                    Positioned(
                      top: playerHeight * 0.1,
                      right: playerWidth * 0.2,
                      child: AnimatedBuilder(
                        animation: _playerReactionController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _playerDropMoveAnimation.value),
                            child: Opacity(
                              opacity: _playerDropFadeAnimation.value,
                              child: Text(
                                '💧',
                                style: TextStyle(
                                  fontSize: 36,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // Question box (bottom center) - responsive sizing
          Positioned(
            bottom: isLandscape ? screenHeight * 0.05 : screenHeight * 0.10,
            left: isLandscape ? screenWidth * 0.15 : 15,
            right: isLandscape ? screenWidth * 0.15 : 15,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: isLandscape ? screenHeight * 0.75 : screenHeight * 0.55,
              ),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF6E0E15), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Question text area - responsive sizing
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isLandscape ? 8 : 12),
                    margin: EdgeInsets.only(bottom: isLandscape ? 8 : 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[400]!, width: 2),
                    ),
                    child: Text(
                      currentQuestion.question,
                      style: TextStyle(
                        fontFamily: 'VT323',
                        fontSize: isLandscape ? 16 : 18,
                        color: Colors.black,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  
                  // Options grid (2x2) - responsive sizing
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: isLandscape ? 6 : 8,
                    crossAxisSpacing: isLandscape ? 6 : 8,
                    childAspectRatio: isLandscape ? 10.5 : 3.5,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(currentQuestion.options.length, (index) {
                      // Determine button color based on selection and correctness
                      Color buttonColor = Colors.grey[300]!; // Default gray
                      Color textColor = Colors.black; // Default black text
                      
                      if (selectedAnswerIndex != null) {
                        if (index == currentQuestion.correctAnswerIndex) {
                          // Always show correct answer in green
                          buttonColor = Colors.green;
                          textColor = Colors.white;
                        } else if (index == selectedAnswerIndex && index != currentQuestion.correctAnswerIndex) {
                          // Show selected wrong answer in red
                          buttonColor = Colors.red;
                          textColor = Colors.white;
                        }
                      }
                      
                      Widget buttonWidget = Container(
                        decoration: BoxDecoration(
                          color: buttonColor, // This will now properly show the background color
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent, // Make Material transparent so Container color shows
                          child: InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: isAnswerSelected ? null : () => _handleOptionSelected(index),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isLandscape ? 3 : 4,
                                vertical: isLandscape ? 2 : 4,
                              ),
                              child: Center(
                                child: Text(
                                  currentQuestion.options[index],
                                  style: TextStyle(
                                    fontFamily: 'VT323',
                                    fontSize: isLandscape ? 14 : 16,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                      
                      // Add shake animation for wrong selected answer
                      if (selectedAnswerIndex == index && index != currentQuestion.correctAnswerIndex) {
                        return AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_shakeAnimation.value * (index % 2 == 0 ? 1 : -1), 0),
                              child: buttonWidget,
                            );
                          },
                        );
                      }
                      
                      return buttonWidget;
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Quest Result Overlay for showing completion/failure messages
class QuestResultOverlay extends StatefulWidget {
  final bool isSuccess;
  final int coinsEarned;
  final int correctAnswers; // Number of correct answers (0-3)
  final int totalQuestions; // Total number of questions (usually 3)
  final VoidCallback onDismiss;

  const QuestResultOverlay({
    Key? key,
    required this.isSuccess,
    required this.coinsEarned,
    required this.correctAnswers,
    this.totalQuestions = 3,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<QuestResultOverlay> createState() => _QuestResultOverlayState();
}

class _QuestResultOverlayState extends State<QuestResultOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: widget.isSuccess ? const Color.fromARGB(255, 52, 106, 54) : const Color.fromARGB(255, 121, 46, 41),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  clipBehavior: Clip.none, // Allow elements to extend beyond container bounds
                  children: [
                    // Main content
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0), // Add top padding to make room for close button
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.isSuccess ? Icons.check_circle : Icons.cancel,
                            size: 60,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.isSuccess ? 'QUEST COMPLETED!' : 'QUEST FAILED!',
                            style: const TextStyle(
                              fontFamily: 'VT323',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          // Correct answers display
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue[700],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.quiz,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '${widget.correctAnswers}/${widget.totalQuestions} Correct',
                                  style: TextStyle(
                                    fontFamily: 'VT323',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Coin reward/penalty display
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: widget.coinsEarned >= 0 ? const Color.fromARGB(255, 123, 105, 27) : const Color.fromARGB(255, 111, 26, 26),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '🪙',
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  widget.coinsEarned >= 0 ? '+${widget.coinsEarned}' : '${widget.coinsEarned}',
                                  style: TextStyle(
                                    fontFamily: 'VT323',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (!widget.isSuccess) ...[
                            const SizedBox(height: 8),
                            const Text(
                              'No hearts remaining',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Close button (X) in top right corner
                    Positioned(
                      top: -15,
                      right: -15,
                      child: GestureDetector(
                        onTap: widget.onDismiss,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.close,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
