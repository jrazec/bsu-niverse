import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import '../game/bsuniverse.dart';
import '../widgets/loading_screen.dart';
import '../game/widgets/quest_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _gameLoaded = false;
  late BSUniverseGame _game;
  int _lastQuestCoins = 0;
  int _lastCorrectAnswers = 0;
  bool _lastQuestSuccess = false;
  
  // Question randomization state
  List<int> _availableQuestionIndices = [];
  List<QuestQuestion> _currentQuestQuestions = [];

  @override
  void initState() {
    super.initState();
    _game = BSUniverseGame();
    _initializeQuestionPool();
    _generateRandomQuest();
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

  
  void _initializeQuestionPool() {
    _availableQuestionIndices = List.generate(allQuestions.length, (index) => index);
  }
  
  void _generateRandomQuest() {
    // If we don't have enough questions left, reset the pool
    if (_availableQuestionIndices.length < 3) {
      _initializeQuestionPool();
    }
    
    // Shuffle and take 3 random questions
    _availableQuestionIndices.shuffle();
    final selectedIndices = _availableQuestionIndices.take(3).toList();
    
    // Remove selected questions from available pool
    for (final index in selectedIndices) {
      _availableQuestionIndices.remove(index);
    }
    
    // Create the quest with selected questions
    _currentQuestQuestions = selectedIndices.map((index) => allQuestions[index]).toList();
  }
  
  // Method to get current quest questions (for external access if needed)
  List<QuestQuestion> getCurrentQuest() => _currentQuestQuestions;
  
  // Method to manually generate a new quest (useful for testing or player request)
  void generateNewQuest() {
    _generateRandomQuest();
  }

  void _handleQuestResult(int questionIndex, bool isCorrect, bool isQuestComplete, int coinsEarned, int correctAnswers) {
    if (isQuestComplete) {
      // Store quest results for the overlay
      _lastQuestCoins = coinsEarned;
      _lastCorrectAnswers = correctAnswers;
      _lastQuestSuccess = coinsEarned >= 0;
      
      // Generate new random quest for next time
      _generateRandomQuest();
      
      // Hide the quest overlay first
      _game.hideQuestOverlay();
      
      // Show the result overlay after a brief delay
      Future.delayed(const Duration(milliseconds: 300), () {
        _game.showQuestResultOverlay(_lastQuestSuccess);
        // No auto-hide - player will close it manually with the X button
      });
    }
    // If quest is not complete, continue with next question (overlay stays open)
  }

  // All BatStateU questions pool
  List<QuestQuestion> get allQuestions => [
    QuestQuestion(
      question: 'What was the former name of BatStateU Lipa Campus?',
      options: ['Don Benito Campus', 'Claro M. Recto Campus', 'Mabini Campus', 'Jose Rizal Campus'],
      correctAnswerIndex: 1,
    ),
    QuestQuestion(
      question: 'Approximately how many students are enrolled at the Lipa Campus?',
      options: ['1,000', '3,500', '5,000+', '10,000'],
      correctAnswerIndex: 2,
    ),
    QuestQuestion(
      question: 'What college offers degrees focusing on artificial intelligence and cybersecurity?',
      options: ['College of Arts and Sciences', 'College of Teacher Education', 'College of Informatics and Computing Sciences', 'College of Engineering'],
      correctAnswerIndex: 2,
    ),
    QuestQuestion(
      question: 'Which college is the oldest among those in BatStateU?',
      options: ['College of Engineering', 'College of Education', 'College of Engineering Technology', 'College of Business'],
      correctAnswerIndex: 2,
    ),
    QuestQuestion(
      question: 'Which organization is associated with CICS students?',
      options: ['JPIIE', 'AITS', 'JPCS', 'AFEG'],
      correctAnswerIndex: 2,
    ),
    QuestQuestion(
      question: 'What organization belongs to the College of Teacher Education?',
      options: ['TechIS', 'PCS', 'AFEG', 'iJE'],
      correctAnswerIndex: 2,
    ),
    QuestQuestion(
      question: 'What student group is linked to Psychology majors?',
      options: ['COPS', 'PASA', 'LEA', 'JME'],
      correctAnswerIndex: 0,
    ),
    QuestQuestion(
      question: 'What is the official student government of the campus?',
      options: ['JPCS', 'TechIS', 'SSC', 'ACASS'],
      correctAnswerIndex: 2,
    ),
    QuestQuestion(
      question: 'What does TechIS stand for?',
      options: ['Technical Information Students', 'Technology and Innovation Society', 'Tech Innovators Society', 'Technical Society for IT Students'],
      correctAnswerIndex: 2,
    ),
    QuestQuestion(
      question: 'What does AITS stand for?',
      options: ['Association of IT Specialists', 'Alliance of Industrial Technology Students', 'Allied Information Technology Society', 'Association of Industrial Tech Students'],
      correctAnswerIndex: 1,
    ),
    QuestQuestion(
      question: 'Which student org belongs to the College of Arts and Sciences?',
      options: ['TechIS', 'PCS', 'JPIIE', 'AITS'],
      correctAnswerIndex: 1,
    ),
    QuestQuestion(
      question: 'What organization caters to Business Administration students?',
      options: ['JME', 'AITS', 'JPCS', 'ACASS'],
      correctAnswerIndex: 0,
    ),
    QuestQuestion(
      question: 'Excerpt from University Vision:\n"A premier national university that develops ______ in the global knowledge economy."',
      options: ['teachers', 'leaders', 'workers', 'citizens'],
      correctAnswerIndex: 1,
    ),
    QuestQuestion(
      question: 'Excerpt from University Mission:\n"A university committed to producing leaders by providing a ______ century learning environment..."',
      options: ['20th', '19th', '21st', '18th'],
      correctAnswerIndex: 2,
    ),
    QuestQuestion(
      question: 'Excerpt from University Mission:\n"...through innovations in education, ______ research, and community and industry partnerships..."',
      options: ['scientific', 'modern', 'social', 'multidisciplinary'],
      correctAnswerIndex: 3,
    ),
    QuestQuestion(
      question: 'Excerpt from University Hymn:\n"Batangas State University,\nThe National Engineering University\nWe hail your great name,\nYour honor we ______."',
      options: ['respect', 'proclaim', 'memorize', 'defend'],
      correctAnswerIndex: 1,
    ),
    QuestQuestion(
      question: 'Excerpt from University Hymn:\n"Bearer of laurels, ______ of leaders,\nTower of wisdom, paragon of service"',
      options: ['provider', 'shaper', 'molder', 'bringer'],
      correctAnswerIndex: 2,
    ),
    QuestQuestion(
      question: 'Excerpt from University Hymn:\n"Leader of innovation, ______ of vision,\nTransforming lives, building the nation."',
      options: ['creator', 'achiever', 'driver', 'dreamer'],
      correctAnswerIndex: 1,
    ),
    QuestQuestion(
      question: 'Excerpt from University Hymn (Chorus):\n"Land, near or far, we conquer with dignity and ______."',
      options: ['strength', 'grace', 'unity', 'pride'],
      correctAnswerIndex: 3,
    ),
    QuestQuestion(
      question: 'Excerpt from University Hymn (Final Line):\n"Your great name shall stand \'til ______!"',
      options: ['forever', 'eternity', 'the end', 'tomorrow'],
      correctAnswerIndex: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (!_gameLoaded) {
      return const SpartanLoadingScreen();
    }
    
    return GameWidget<BSUniverseGame>(
      game: _game,
      overlayBuilderMap: {
        'QuestOverlay': (context, game) => QuestOverlay(
              game: game,
              questions: _currentQuestQuestions,
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
