import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/bsuniverse.dart';
import '../widgets/loading_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _gameLoaded = false;
  late BSUniverseGame _game;

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  Future<void> _loadGame() async {
    _game = BSUniverseGame();
    
    // Simulate loading time (you can remove this if you want faster loading)
    await Future.delayed(const Duration(seconds: 2));
    
    // Allow the game to initialize
    await Future.delayed(const Duration(milliseconds: 100));
    
    setState(() {
      _gameLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_gameLoaded) {
      return const SpartanLoadingScreen();
    }
    
    return GameWidget<BSUniverseGame>(
      game: _game,
      overlayBuilderMap: {
        // We'll add inventory and pause overlays later
      },
      initialActiveOverlays: const [],
    );
  }
}
