import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/bsuniverse.dart';
import '../game/widgets/quest_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late BSUniverseGame game;

  @override
  void initState() {
    super.initState();
    game = BSUniverseGame();
  }

  void _handleQuestResult(int selectedIndex, bool isCorrect) {
    // Hide the quest overlay first
    game.hideQuestOverlay();
    
    // Show the result overlay after a brief delay
    Future.delayed(const Duration(milliseconds: 300), () {
      game.showQuestResultOverlay(isCorrect);
      
      // Auto-hide the result overlay after a few seconds
      Future.delayed(const Duration(seconds: 3), () {
        game.hideQuestResultOverlay();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget<BSUniverseGame>(
      game: game,
      overlayBuilderMap: {
        'QuestOverlay': (context, game) => QuestOverlay(
              game: game,
              question: 'What is the capital of the Philippines?',
              options: ['Manila', 'Cebu', 'Davao', 'Quezon City'],
              correctAnswerIndex: 0, // Manila is the correct answer
              initialHearts: 3,
              onOptionSelected: _handleQuestResult,
              // Use helper methods to get current sprite configurations
              playerSprite: game.getCurrentPlayerSprite(),
              npcSprite: game.getCurrentNPCSprite(),
            ),
        'QuestCompleted': (context, game) => QuestResultOverlay(
              isSuccess: true,
              onDismiss: () => game.hideQuestResultOverlay(),
            ),
        'QuestFailed': (context, game) => QuestResultOverlay(
              isSuccess: false,
              onDismiss: () => game.hideQuestResultOverlay(),
            ),
      },
      initialActiveOverlays: const [],
    );
  }
}
