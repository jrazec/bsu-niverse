import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/bsuniverse.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget<BSUniverseGame>(
      game: BSUniverseGame(),
      overlayBuilderMap: {
        // We'll add inventory and pause overlays later
      },
      initialActiveOverlays: const [],
    );
  }
}
