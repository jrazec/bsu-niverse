import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../sound_manager.dart';

class MuteButtonComponent extends PositionComponent with HasGameReference, TapCallbacks {
  late final TextComponent _muteIcon;
  late final TextComponent _soundIcon;
  bool _isMuted = false;
  
  final Color _buttonColor = Colors.black54;
  final Color _activeColor = Colors.white;
  final Color _mutedColor = Colors.red;

  MuteButtonComponent({
    Vector2? position,
    Vector2? size,
  }) : super(
          position: position ?? Vector2.zero(),
          size: size ?? Vector2.all(50),
        ) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    // Create circular background using RectangleComponent
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
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
      anchor: Anchor.center,
      position: size / 2,
    );
    
    add(background);
    add(border);
    
    // Create text components for mute and sound icons
    _muteIcon = TextComponent(
     text: '🔊',
      textRenderer: TextPaint(
        style: TextStyle(
          color: _mutedColor,
          fontSize: size.x * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: size / 2,
    );
    
    _soundIcon = TextComponent(
      text: '🔊',
      textRenderer: TextPaint(
        style: TextStyle(
          color: _activeColor,
          fontSize: size.x * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
      position: size / 2,
    );
    
    _updateVisuals();
  }

  void _updateVisuals() {
    // Remove existing icons
    children.whereType<TextComponent>().forEach(remove);
    
    // Add appropriate icon based on mute state
    if (_isMuted) {
      add(_muteIcon);
    } else {
      add(_soundIcon);
    }
  }

  @override
  bool onTapUp(TapUpEvent event) {
    _isMuted = !_isMuted;
    
    // Toggle mute state
    if (_isMuted) {
      GameSoundManager().enableMusic(false);
    } else {
      GameSoundManager().enableMusic(true);
    }
    
    _updateVisuals();
    return true;
  }

  // Static method to get position for top-right corner
  static Vector2 getTopRightPosition(Vector2 canvasSize, Vector2 buttonSize) {
    final margin = 20.0;
    return Vector2(
      canvasSize.x - margin - buttonSize.x / 2,
      margin + buttonSize.y / 2,
    );
  }

  // Method to update mute state from external sources
  void updateMuteState(bool isMuted) {
    if (_isMuted != isMuted) {
      _isMuted = isMuted;
      _updateVisuals();
    }
  }
}
