/// Player data management system for BSUniverse
/// Handles coins, quest progress, and player statistics

class PlayerData {
  static final PlayerData _instance = PlayerData._internal();
  factory PlayerData() => _instance;
  PlayerData._internal();

  // Player coins and rewards
  int _coins = 100; // Starting coins
  int get coins => _coins;

  // Quest tracking
  final Map<String, QuestProgress> _questProgress = {};
  final Set<String> _completedQuests = {};
  final Set<String> _declinedQuests = {};

  // Active quest tracking
  final Map<String, ActiveQuest> _activeQuests = {};
  Map<String, ActiveQuest> get activeQuests => Map.unmodifiable(_activeQuests);

  // Statistics
  int _totalQuestsCompleted = 0;
  int _totalQuestsDeclined = 0;
  int _totalCoinsEarned = 0;
  int _totalCoinsLost = 0;

  int get totalQuestsCompleted => _totalQuestsCompleted;
  int get totalQuestsDeclined => _totalQuestsDeclined;
  int get totalCoinsEarned => _totalCoinsEarned;
  int get totalCoinsLost => _totalCoinsLost;

  // Getters for quest statistics
  int get totalQuestsAttempted => _totalQuestsCompleted + _totalQuestsDeclined;
  double get questSuccessRate => totalQuestsAttempted > 0 ? _totalQuestsCompleted / totalQuestsAttempted : 0.0;

  /// Add coins to player balance
  void addCoins(int amount) {
    if (amount > 0) {
      _coins += amount;
      _totalCoinsEarned += amount;
    }
  }

  /// Remove coins from player balance (cannot go below 0)
  void removeCoins(int amount) {
    if (amount > 0) {
      final actualAmount = amount.clamp(0, _coins);
      _coins -= actualAmount;
      _totalCoinsLost += actualAmount;
    }
  }

  /// Accept a quest and track it
  void acceptQuest(String questId, String questTitle, String location, int coinsReward, int coinsPenalty) {
    if (!_activeQuests.containsKey(questId) && !_completedQuests.contains(questId)) {
      _activeQuests[questId] = ActiveQuest(
        id: questId,
        title: questTitle,
        location: location,
        coinsReward: coinsReward,
        coinsPenalty: coinsPenalty,
        acceptedAt: DateTime.now(),
      );
      
      _questProgress[questId] = QuestProgress(
        questId: questId,
        status: QuestStatus.accepted,
        acceptedAt: DateTime.now(),
      );
      
      print('Quest accepted: $questTitle ($questId)');
    }
  }

  /// Complete a quest successfully
  void completeQuest(String questId, int coinsEarned, int correctAnswers, int totalQuestions) {
    final quest = _activeQuests[questId];
    if (quest != null) {
      // Update quest progress
      _questProgress[questId] = QuestProgress(
        questId: questId,
        status: QuestStatus.completed,
        acceptedAt: quest.acceptedAt,
        completedAt: DateTime.now(),
        coinsEarned: coinsEarned,
        correctAnswers: correctAnswers,
        totalQuestions: totalQuestions,
      );

      // Add coins and update statistics
      addCoins(coinsEarned);
      _totalQuestsCompleted++;
      _completedQuests.add(questId);
      _activeQuests.remove(questId);

      print('Quest completed: ${quest.title} (+$coinsEarned coins)');
    }
  }

  /// Fail a quest
  void failQuest(String questId, int coinsPenalty) {
    final quest = _activeQuests[questId];
    if (quest != null) {
      // Update quest progress
      _questProgress[questId] = QuestProgress(
        questId: questId,
        status: QuestStatus.failed,
        acceptedAt: quest.acceptedAt,
        completedAt: DateTime.now(),
        coinsEarned: -coinsPenalty,
        correctAnswers: 0,
        totalQuestions: 3, // Default to 3 questions
      );

      // Remove coins and update statistics
      removeCoins(coinsPenalty);
      _totalQuestsDeclined++; // Count failed as declined for statistics
      _activeQuests.remove(questId);

      print('Quest failed: ${quest.title} (-$coinsPenalty coins)');
    }
  }

  /// Decline a quest
  void declineQuest(String questId) {
    _questProgress[questId] = QuestProgress(
      questId: questId,
      status: QuestStatus.declined,
      acceptedAt: DateTime.now(),
      completedAt: DateTime.now(),
    );

    _totalQuestsDeclined++;
    _declinedQuests.add(questId);
    _activeQuests.remove(questId);

    print('Quest declined: $questId');
  }

  /// Check if a quest has been completed
  bool isQuestCompleted(String questId) {
    return _completedQuests.contains(questId);
  }

  /// Check if a quest has been declined
  bool isQuestDeclined(String questId) {
    return _declinedQuests.contains(questId);
  }

  /// Check if a quest is currently active
  bool isQuestActive(String questId) {
    return _activeQuests.containsKey(questId);
  }

  /// Get quest progress for a specific quest
  QuestProgress? getQuestProgress(String questId) {
    return _questProgress[questId];
  }

  /// Get all completed quests with their progress
  List<QuestProgress> getCompletedQuests() {
    return _questProgress.values
        .where((progress) => progress.status == QuestStatus.completed)
        .toList();
  }

  /// Get active quests for a specific building/location
  List<ActiveQuest> getActiveQuestsForLocation(String location) {
    return _activeQuests.values
        .where((quest) => quest.location.toLowerCase().contains(location.toLowerCase()))
        .toList();
  }

  /// Clear all quest data (useful for testing or reset)
  void clearAllData() {
    _coins = 100;
    _questProgress.clear();
    _completedQuests.clear();
    _declinedQuests.clear();
    _activeQuests.clear();
    _totalQuestsCompleted = 0;
    _totalQuestsDeclined = 0;
    _totalCoinsEarned = 0;
    _totalCoinsLost = 0;
  }

  /// Get summary data for UI display
  PlayerSummary getSummary() {
    return PlayerSummary(
      coins: _coins,
      activeQuestCount: _activeQuests.length,
      completedQuestCount: _totalQuestsCompleted,
      totalQuestCount: totalQuestsAttempted,
      successRate: questSuccessRate,
      totalCoinsEarned: _totalCoinsEarned,
      totalCoinsLost: _totalCoinsLost,
    );
  }
}

/// Represents the progress of a specific quest
class QuestProgress {
  final String questId;
  final QuestStatus status;
  final DateTime acceptedAt;
  final DateTime? completedAt;
  final int? coinsEarned;
  final int? correctAnswers;
  final int? totalQuestions;

  QuestProgress({
    required this.questId,
    required this.status,
    required this.acceptedAt,
    this.completedAt,
    this.coinsEarned,
    this.correctAnswers,
    this.totalQuestions,
  });

  double? get successRate {
    if (correctAnswers != null && totalQuestions != null && totalQuestions! > 0) {
      return correctAnswers! / totalQuestions!;
    }
    return null;
  }
}

/// Status of a quest
enum QuestStatus {
  accepted,
  completed,
  failed,
  declined,
}

/// Represents an active quest
class ActiveQuest {
  final String id;
  final String title;
  final String location;
  final int coinsReward;
  final int coinsPenalty;
  final DateTime acceptedAt;

  ActiveQuest({
    required this.id,
    required this.title,
    required this.location,
    required this.coinsReward,
    required this.coinsPenalty,
    required this.acceptedAt,
  });

  String get building {
    final location = this.location.toLowerCase();
    if (location.contains('gzb') || location.contains('gonzalez')) return 'gzb';
    if (location.contains('abb') || location.contains('andres')) return 'abb';
    if (location.contains('lsb') || location.contains('life sciences')) return 'lsb';
    if (location.contains('vmb') || location.contains('vicente')) return 'vmb';
    return 'other';
  }
}

/// Summary data for UI display
class PlayerSummary {
  final int coins;
  final int activeQuestCount;
  final int completedQuestCount;
  final int totalQuestCount;
  final double successRate;
  final int totalCoinsEarned;
  final int totalCoinsLost;

  PlayerSummary({
    required this.coins,
    required this.activeQuestCount,
    required this.completedQuestCount,
    required this.totalQuestCount,
    required this.successRate,
    required this.totalCoinsEarned,
    required this.totalCoinsLost,
  });

  int get netCoins => totalCoinsEarned - totalCoinsLost;
}
