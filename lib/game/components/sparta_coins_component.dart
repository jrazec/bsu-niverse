import 'package:flutter/material.dart';
import 'package:flame/components.dart';

/// SpartaCoins UI Component - A HUD element that displays the player's coin count
/// 
/// This component provides a consistent UI indicator that shows the current
/// amount of SpartaCoins the player has. It's designed to be visible across
/// all game scenes and matches the visual style of the hearts mechanic in
/// the quest overlay.
/// 
/// Features:
/// - Responsive positioning that adapts to different screen sizes
/// - Animated updates when coin count changes
/// - Clean, pixel-art style design consistent with the game's aesthetic
/// - Always visible HUD element positioned to the left of the mute button

class SpartaCoinsComponent extends PositionComponent with HasGameRef {
  static const double _baseFontSize = 16.0;
  static const double _basePadding = 8.0;
  static const double _borderWidth = 2.0;
  static const double _componentHeight = 50.0; // Match mute button height
  static const Color _backgroundColor = Colors.black54; // Translucent background like mute button
  static const Color _borderColor = Colors.white; // White border like mute button
  static const Color _textColor = Colors.white; // White text for contrast
  
  int _coins = 0;
  late TextComponent _coinText;
  late RectangleComponent _background;
  Vector2 _screenSize = Vector2.zero();
  
  /// Creates a new SpartaCoins component with the specified initial coin count
  SpartaCoinsComponent({int initialCoins = 10}) : _coins = initialCoins;
  
  @override
  Future<void> onLoad() async {
    // Create background container
    _background = RectangleComponent(
      paint: Paint()..color = _backgroundColor,
    );
    
    // Create coin text display
    _coinText = TextComponent(
      text: _formatCoinText(),
      textRenderer: TextPaint(
        style: const TextStyle(
          fontFamily: 'VT323',
          fontSize: _baseFontSize,
          fontWeight: FontWeight.bold,
          color: _textColor,
        ),
      ),
    );
    
    add(_background);
    add(_coinText);
    
    // Update positioning
    _updateLayout();
  }
  
  @override
  void onGameResize(Vector2 gameSize) {
    super.onGameResize(gameSize);
    _screenSize = gameSize;
    _updateLayout();
  }
  
  /// Updates the coin count and refreshes the display
  void updateCoins(int newAmount) {
    _coins = newAmount;
    _coinText.text = _formatCoinText();
    _updateLayout(); // Recalculate size in case text length changed
  }
  
  /// Adds coins to the current amount
  void addCoins(int amount) {
    updateCoins(_coins + amount);
  }
  
  /// Removes coins from the current amount (won't go below 0)
  void removeCoins(int amount) {
    updateCoins((_coins - amount).clamp(0, double.infinity).toInt());
  }
  
  /// Gets the current coin count
  int get coins => _coins;
  
  /// Formats the coin display text
  String _formatCoinText() {
    return '🪙 $_coins';
  }
  
  /// Updates the layout and positioning of the component
  void _updateLayout() {
    if (_screenSize == Vector2.zero) return;
    
    // Calculate responsive scaling
    final scaleFactor = (_screenSize.x / 400.0).clamp(0.8, 2.0);
    final fontSize = _baseFontSize * scaleFactor;
    final padding = _basePadding * scaleFactor;
    
    // Update text renderer with new size
    _coinText.textRenderer = TextPaint(
      style: TextStyle(
        fontFamily: 'VT323',
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: _textColor,
      ),
    );
    
    // Update text content to ensure proper measurement
    _coinText.text = _formatCoinText();
    
    // Calculate component dimensions - fixed height to match mute button
    final estimatedCharWidth = fontSize * 0.6; // Rough estimation for VT323 font
    final estimatedTextWidth = _coinText.text.length * estimatedCharWidth;
    
    final componentWidth = estimatedTextWidth + (padding * 2) + (_borderWidth * 2);
    final componentHeight = _componentHeight; // Fixed height to match mute button
    
    // Position the component to the left of the mute button (top-right area)
    // Mute button uses Anchor.center and positions at margin + size/2 from edges
    // We need to match this positioning logic for proper alignment
    final muteButtonWidth = 50.0; // Standard mute button size
    final muteButtonMargin = 20.0; // Same margin as mute button uses
    final componentGap = 10.0; // Gap between our component and mute button
    
    final componentX = _screenSize.x - muteButtonMargin - muteButtonWidth - componentGap - componentWidth;
    // Align Y with mute button center: margin + buttonHeight/2 - ourHeight/2
    final muteButtonCenterY = muteButtonMargin + (muteButtonWidth / 2);
    final componentY = muteButtonCenterY - (componentHeight / 2);
    
    // Update component position and size first
    position = Vector2(componentX, componentY);
    size = Vector2(componentWidth, componentHeight);
    
    // Update background to fill the entire component with translucent style
    _background.position = Vector2.zero(); // Relative to component
    _background.size = Vector2(componentWidth, componentHeight);
    _background.paint = Paint()
      ..color = _backgroundColor
      ..style = PaintingStyle.fill;
    
    // Create white border
    final border = RectangleComponent(
      position: Vector2.zero(),
      size: Vector2(componentWidth, componentHeight),
      paint: Paint()
        ..color = _borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _borderWidth,
    );
    
    // Clear and rebuild background with new style
    _background.removeAll(_background.children);
    _background.add(border);
    
    // Position the text inside the component (relative to component position)
    // Center the text vertically within the fixed height
    final textY = (componentHeight - fontSize) / 2;
    _coinText.position = Vector2(
      _borderWidth + padding,
      textY,
    );
  }
  
  /// Gets the optimal position for the coins component (to the left of mute button)
  static Vector2 getOptimalPosition(Vector2 screenSize, Vector2 componentSize) {
    final muteButtonWidth = 50.0;
    final muteButtonMargin = 20.0; // Same margin as mute button
    final componentGap = 10.0;
    
    final componentX = screenSize.x - muteButtonMargin - muteButtonWidth - componentGap - componentSize.x;
    // Align Y with mute button center
    final muteButtonCenterY = muteButtonMargin + (muteButtonWidth / 2);
    final componentY = muteButtonCenterY - (componentSize.y / 2);
    
    return Vector2(componentX, componentY);
  }
  
  /// Creates a formatted string for displaying large coin amounts
  static String formatLargeNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
