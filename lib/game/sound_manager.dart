import 'package:audioplayers/audioplayers.dart';

class GameSoundManager {
  static final GameSoundManager _instance = GameSoundManager._internal();
  factory GameSoundManager() => _instance;
  GameSoundManager._internal();

  // Audio players
  late AudioPlayer _backgroundMusicPlayer;
  late AudioPlayer _sfxPlayer;
  late AudioPlayer _movementPlayer;

  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;
  double _musicVolume = 0.05; // Much lower background music volume
  double _sfxVolume = 0.6;

  // Initialize audio players
  Future<void> initialize() async {
    try {
      _backgroundMusicPlayer = AudioPlayer();
      _sfxPlayer = AudioPlayer();
      _movementPlayer = AudioPlayer();

      // Set initial volumes
      await _backgroundMusicPlayer.setVolume(_musicVolume);
      await _sfxPlayer.setVolume(_sfxVolume);
      await _movementPlayer.setVolume(_sfxVolume * 0.8); // Movement sounds slightly quieter but still audible
    } catch (e) {
      print('Error initializing audio players: $e');
      // Disable sound features if initialization fails
      _isMusicEnabled = false;
      _isSfxEnabled = false;
    }
  }

  // Background Music
  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled) return;
    
    try {
      await _backgroundMusicPlayer.play(
        AssetSource('audio/background_music.mp3'), // Replace with your audio file
      );
      await _backgroundMusicPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      print('Error playing background music: $e');
      // Don't throw error, just continue without music
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _backgroundMusicPlayer.stop();
  }

  Future<void> pauseBackgroundMusic() async {
    await _backgroundMusicPlayer.pause();
  }

  Future<void> resumeBackgroundMusic() async {
    await _backgroundMusicPlayer.resume();
  }


  // Movement Sound Effects
  Future<void> playMovementSound() async {
    if (!_isSfxEnabled) return;

    try {
      // Only play if not already playing to avoid spam
      if (_movementPlayer.state != PlayerState.playing) {
        await _movementPlayer.play(
          AssetSource('audio/footstep.mp3'),
          volume: 0.3);
      }
    } catch (e) {
      print('Error playing movement sound: $e');
      // Don't throw error, just continue without movement sound
    }
  }

  Future<void> stopMovementSound() async {
    await _movementPlayer.stop();
  }

  // Power-up Sound Effects
  Future<void> playPowerUpActivateSound(String powerUpType) async {
    if (!_isSfxEnabled) return;

    String soundFile;
    switch (powerUpType) {
      case 'run':
        soundFile = 'audio/powerup_speed.mp3';
        break;
      case 'titan':
        soundFile = 'audio/powerup_titan.mp3';
        break;
      case 'nolimits':
        soundFile = 'audio/powerup_nolimits.mp3';
        break;
      case 'dash':
        soundFile = 'audio/powerup_flicker.mp3';
        break;
      default:
        soundFile = 'audio/powerup_speed.mp3';
    }

    try {
      await _sfxPlayer.play(AssetSource(soundFile));
    } catch (e) {
      print('Error playing power-up sound: $e');
      // Don't throw error, just continue without power-up sound
    }
  }

  Future<void> playPowerUpDeactivateSound() async {
    if (!_isSfxEnabled) return;

    try {
      await _sfxPlayer.play(AssetSource('audio/powerup_deactivate.mp3'));
    } catch (e) {
      print('Error playing power-up deactivate sound: $e');
      // Don't throw error, just continue without deactivate sound
    }
  }

  // Quest Sound Effects
  Future<void> playQuestCorrectAnswerSound() async {
    if (!_isSfxEnabled) return;

    try {
      await _sfxPlayer.play(AssetSource('audio/correct_answer.mp3'));
    } catch (e) {
      print('Error playing quest correct answer sound: $e');
      // Don't throw error, just continue without sound
    }
  }

  Future<void> playQuestWrongAnswerSound() async {
    if (!_isSfxEnabled) return;

    try {
      await _sfxPlayer.play(AssetSource('audio/wrong_answer.mp3'));
    } catch (e) {
      print('Error playing quest wrong answer sound: $e');
      // Don't throw error, just continue without sound
    }
  }

  Future<void> playQuestCompleteSound() async {
    if (!_isSfxEnabled) return;

    try {
      await _sfxPlayer.play(AssetSource('audio/quest_complete.mp3'));
    } catch (e) {
      print('Error playing quest complete sound: $e');
      // Don't throw error, just continue without sound
    }
  }

  Future<void> playQuestFailedSound() async {
    if (!_isSfxEnabled) return;

    try {
      // Using button click sound as placeholder until you find appropriate quest failed sound
      await _sfxPlayer.play(AssetSource('audio/button_click.mp3'));
    } catch (e) {
      print('Error playing quest failed sound: $e');
      // Don't throw error, just continue without sound
    }
  }



  // Volume Controls
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 0.3);
    await _backgroundMusicPlayer.setVolume(_musicVolume);
  }

  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 0.5);
    await _sfxPlayer.setVolume(_sfxVolume);
    await _movementPlayer.setVolume(_sfxVolume * 0.5);
  }

  // Enable/Disable Controls
  void enableMusic(bool enabled) {
    _isMusicEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    } else {
      playBackgroundMusic();
    }
  }

  void enableSfx(bool enabled) {
    _isSfxEnabled = enabled;
    if (!enabled) {
      stopMovementSound();
    }
  }

  // Toggle mute controls
  void toggleMuteMusic() {
    enableMusic(!_isMusicEnabled);
  }

  void toggleMuteSfx() {
    enableSfx(!_isSfxEnabled);
  }

  void toggleMuteAll() {
    final shouldMute = _isMusicEnabled || _isSfxEnabled;
    enableMusic(!shouldMute);
    enableSfx(!shouldMute);
  }

  // Getters
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSfxEnabled => _isSfxEnabled;
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;
  bool get isAnyAudioEnabled => _isMusicEnabled || _isSfxEnabled;
  bool get isAllAudioMuted => !_isMusicEnabled && !_isSfxEnabled;

  // Dispose
  Future<void> dispose() async {
    await _backgroundMusicPlayer.dispose();
    await _sfxPlayer.dispose();
    await _movementPlayer.dispose();
  }
}
