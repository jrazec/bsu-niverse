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
  int _lastQuestCoins = 0;
  int _lastCorrectAnswers = 0;
  bool _lastQuestSuccess = false;

  @override
  void initState() {
    super.initState();
    game = BSUniverseGame();
  }

  void _handleQuestResult(int questionIndex, bool isCorrect, bool isQuestComplete, int coinsEarned, int correctAnswers) {
    if (isQuestComplete) {
      // Store quest results for the overlay
      _lastQuestCoins = coinsEarned;
      _lastCorrectAnswers = correctAnswers;
      _lastQuestSuccess = coinsEarned >= 0;
      
      // Hide the quest overlay first
      game.hideQuestOverlay();
      
      // Show the result overlay after a brief delay
      Future.delayed(const Duration(milliseconds: 300), () {
        game.showQuestResultOverlay(_lastQuestSuccess);
        // No auto-hide - player will close it manually with the X button
      });
    }
    // If quest is not complete, continue with next question (overlay stays open)
  }

  // Sample quest with 3 questions
  List<QuestQuestion> get sampleQuest => [
    QuestQuestion(
      question: 'What is the capital of the Philippines?',
      options: ['Manila', 'Cebu', 'Davao', 'Quezon City'],
      correctAnswerIndex: 0,
    ),
    QuestQuestion(
      question: 'Which university is BSU?',
      options: ['Bataan State University', 'Batangas State University', 'Bicol State University', 'Bukidnon State University'],
      correctAnswerIndex: 1,
    ),
    QuestQuestion(
      question: 'What does "IT" stand for?',
      options: ['Internet Technology', 'Information Technology', 'Integrated Technology', 'Interactive Technology'],
      correctAnswerIndex: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GameWidget<BSUniverseGame>(
      game: game,
      overlayBuilderMap: {
        'QuestOverlay': (context, game) => QuestOverlay(
              game: game,
              questions: sampleQuest,
              initialHearts: 3,
              onOptionSelected: _handleQuestResult,
              // Use helper methods to get current sprite configurations
              playerSprite: game.getCurrentPlayerSprite(),
              npcSprite: game.getCurrentNPCSprite(),
            ),
        'QuestCompleted': (context, game) => QuestResultOverlay(
              isSuccess: true,
              coinsEarned: _lastQuestCoins,
              correctAnswers: _lastCorrectAnswers,
              onDismiss: () => game.hideQuestResultOverlay(),
            ),
        'QuestFailed': (context, game) => QuestResultOverlay(
              isSuccess: false,
              coinsEarned: _lastQuestCoins,
              correctAnswers: _lastCorrectAnswers,
              onDismiss: () => game.hideQuestResultOverlay(),
            ),
      },
      initialActiveOverlays: const [],
    );
  }
}
