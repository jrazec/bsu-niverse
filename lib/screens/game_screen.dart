import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/bsuniverse.dart';
import '../game/widgets/quest_overlay.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = BSUniverseGame();
    return GameWidget<BSUniverseGame>(
      game: game,
      overlayBuilderMap: {
        'QuestOverlay': (context, game) => QuestOverlay(
              game: game,
              question: 'What is the capital of the Philippines?',
              options: ['Manila', 'Cebu', 'Davao', 'Quezon City'],
              hearts: 3, // Start with 3 hearts
              onOptionSelected: (index) {
                game.hideQuestOverlay();
              },
            ),
        // We'll add inventory and pause overlays later
      },
      initialActiveOverlays: const [],
    );
  }
}
