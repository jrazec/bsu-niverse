import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart' hide Image;
// Color scheme from home.dart
final Color championWhite = Color.fromRGBO(250, 249, 246, 1.0);
final Color pixelGold = Color.fromRGBO(255, 215, 0, 1.0);
final Color lavanderGray = Color.fromRGBO(197, 197, 214, 1.0);
final Color blazingOrange = Color.fromRGBO(255, 106, 0, 1.0);
final Color charcoalBlack = Color.fromRGBO(27, 27, 27, 1.0);
final Color ashMaroon = Color.fromRGBO(110, 14, 21, 1.0);
final Color fineRed = Color.fromRGBO(201, 33, 30, 1.0);

class StatusButtonComponent extends PositionComponent with HasGameRef, TapCallbacks, DragCallbacks {
  final String label;
  final Color color;
  final int cooldownMs;
  bool status;
  bool _isOnCooldown = false;
  double _cooldownTimer = 0.0;
  late final TextComponent _textComponent;
  late final TextComponent _cooldownText;
  late final CircleComponent _background;
  late final CircleComponent _cooldownOverlay;
  Function(String)? onPressed;
  Function(String, Vector2)? onDragUpdateCallback; // For D button joystick
  Function(String)? onDragEndCallback; // For D button release
  
  // D button joystick properties
  bool _isJoystickMode = false;
  late final CircleComponent _joystickKnob;
  Vector2 _knobPosition = Vector2.zero();
  Vector2 _relativeDelta = Vector2.zero();
  final double _maxDistance = 25; // Distance knob can move from center
  bool _isDragging = false;

  StatusButtonComponent({
    required this.label,
    required this.color,
    required this.status,
    this.cooldownMs = 1000, // Default 1 second cooldown
    Vector2? size,
    Vector2? position,
    this.onPressed,
    this.onDragUpdateCallback,
    this.onDragEndCallback,
  }) : super(
          size: size ?? Vector2.all(60),
          position: position ?? Vector2.zero(),
        ) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    final radius = size.x / 2;
    
    _background = CircleComponent(
      radius: radius,
      paint: Paint()..color = _getBackgroundColor(),
      anchor: Anchor.center,
      position: size / 2,
    );

    // Cooldown overlay (red semi-transparent circle)
    _cooldownOverlay = CircleComponent(
      radius: radius,
      paint: Paint()..color = charcoalBlack.withOpacity(0.8),
      anchor: Anchor.center,
      position: size / 2,
    );

    _textComponent = TextComponent(
      text: label,
      textRenderer: TextPaint(
        style: TextStyle(
          color: championWhite,
          fontSize: radius * 0.5,
          fontWeight: FontWeight.bold,
          fontFamily: 'PixeloidSans-Bold',
        ),
      ),
      anchor: Anchor.center,
      position: size / 2,
    );

    // Cooldown timer text
    _cooldownText = TextComponent(
      text: '',
      textRenderer: TextPaint(
        style: TextStyle(
          color: championWhite,
          fontSize: radius * 0.25,
          fontWeight: FontWeight.bold,
          fontFamily: 'PixeloidSans-Bold',
        ),
      ),
      anchor: Anchor.center,
      position: Vector2(size.x / 2, size.y / 2 + radius * 0.4),
    );

    // Joystick knob (initially hidden)
    _joystickKnob = CircleComponent(
      radius: radius * 0.4,
      paint: Paint()..color = championWhite.withOpacity(0.9),
      anchor: Anchor.center,
      position: size / 2,
    );
    _knobPosition = size / 2;

    add(_background);
    add(_textComponent);
    add(_cooldownText);
  }

  void updateStatus(bool newStatus) {
    status = newStatus;
    _updateVisuals();
  }


  static Vector2 getResponsiveButtonSize(Vector2 canvasSize) {
    // Scale button size based on screen size
    final baseSizeRatio = 0.08; // 8% of screen width
    final buttonSize = canvasSize.x * baseSizeRatio;
    return Vector2.all(buttonSize.clamp(50.0, 100.0)); // Min 50, Max 80
  }

  static Vector2 getButtonPosition(Vector2 canvasSize, int buttonIndex) {
    // Get responsive button size
    final buttonSize = getResponsiveButtonSize(canvasSize);
    
    // Base margins as percentages of screen size
    final rightMargin = canvasSize.x * 0.1; // 10% from right
    final bottomMargin = canvasSize.y * 0.15; // 15% from bottom
    
    // Button spacing
    final spacing = buttonSize.x * 0.3; // 30% of button size
    
    // Calculate positions in a 2x2 grid pattern (like GameBoy)
    final baseX = canvasSize.x - rightMargin;
    final baseY = canvasSize.y - bottomMargin;
    
    switch (buttonIndex) {
      case 3: // Button A - bottom right
        return Vector2(baseX, baseY);
      case 2: // Button B - bottom left  
        return Vector2(baseX - buttonSize.x - spacing, baseY);
      case 1: // Button C - top right
        return Vector2(baseX, baseY - buttonSize.y - spacing);
      case 0: // Button D - top left
        return Vector2(baseX - buttonSize.x - spacing, baseY - buttonSize.y - spacing);
      default:
        return Vector2(baseX, baseY);
    }
  }

  // FIR IT TO INITIALLY ALIGN EVERYTHING UP
  void alignRight(double parentWidth, double topPadding) {
    position = Vector2(parentWidth - size.x, topPadding);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (_isOnCooldown) {
      _cooldownTimer -= dt;
      if (_cooldownTimer <= 0) {
        _isOnCooldown = false;
        _cooldownTimer = 0.0;
        _cooldownText.text = '';
        _cooldownOverlay.removeFromParent();
        _updateVisuals();
      } else {
        // Update cooldown display
        final remainingMs = (_cooldownTimer * 1000).ceil();
        _cooldownText.text = '${remainingMs}ms';
      }
    }
    
    // Handle joystick knob return to center when not dragging
    if (_isJoystickMode && !_isDragging) {
      final centerPosition = size / 2;
      final direction = centerPosition - _knobPosition;
      
      if (direction.length > 1) {
        _knobPosition += direction.normalized() * 200 * dt;
        _joystickKnob.position = _knobPosition;
        
        // Update relative delta
        final deltaFromCenter = _knobPosition - centerPosition;
        _relativeDelta = deltaFromCenter.length > _maxDistance 
          ? deltaFromCenter.normalized() * _maxDistance 
          : deltaFromCenter;
        _relativeDelta = _relativeDelta / _maxDistance;
        
        onDragUpdateCallback?.call(label, _relativeDelta);
      } else {
        _knobPosition = centerPosition;
        _joystickKnob.position = _knobPosition;
        _relativeDelta = Vector2.zero();
        onDragUpdateCallback?.call(label, _relativeDelta);
      }
    }
  }

  Color _getBackgroundColor() {
    if (_isOnCooldown) {
      return lavanderGray.withOpacity(0.8);
    }
    if (_isJoystickMode) {
      return _getButtonColor().withOpacity(0.3); // Dimmed for joystick mode
    }
    return status ? _getButtonColor() : _getButtonColor().withOpacity(0.3);
  }

  Color _getButtonColor() {
    switch (label) {
      case 'A':
        return ashMaroon;
      case 'B':
        return blazingOrange;
      case 'C':
        return pixelGold;
      case 'D':
        return fineRed;
      default:
        return Colors.grey;
    }
  }

  void _updateVisuals() {
    _background.paint.color = _getBackgroundColor();
  }

  void _startCooldown() {
    _isOnCooldown = true;
    _cooldownTimer = cooldownMs / 1000.0; // Convert to seconds
    add(_cooldownOverlay);
    _updateVisuals();
  }

  @override
  bool onTapUp(TapUpEvent event) {
    if (!_isOnCooldown) {
      // Play button click sound
      onPressed?.call(label);
      // No cooldown starts here - cooldown will start when button is released/deactivated
    }
    return true;
  }

  // Method to start cooldown when button is deactivated
  void startCooldownOnRelease() {
    if (label != 'D' && !_isOnCooldown) { // D button doesn't have cooldown since it's hold/release
      _startCooldown();
    }
  }

  void enterJoystickMode() {
    if (label == 'D' && !_isJoystickMode) {
      _isJoystickMode = true;
      _textComponent.text = '';
      add(_joystickKnob);
      _updateVisuals();
    }
  }
  
  void exitJoystickMode() {
    if (label == 'D' && _isJoystickMode) {
      _isJoystickMode = false;
      _textComponent.text = label;
      _joystickKnob.removeFromParent();
      _knobPosition = size / 2;
      _joystickKnob.position = _knobPosition;
      _relativeDelta = Vector2.zero();
      _isDragging = false;
      _updateVisuals();
    }
  }
  
  @override
  bool onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    if (label == 'D' && _isJoystickMode) {
      _isDragging = true;
      return true;
    }
    return false;
  }
  
  @override
  bool onDragUpdate(DragUpdateEvent event) {
    if (label == 'D' && _isJoystickMode && _isDragging) {
      final localPosition = event.localEndPosition;
      final centerPosition = size / 2;
      final deltaFromCenter = localPosition - centerPosition;
      
      if (deltaFromCenter.length <= _maxDistance) {
        _knobPosition = localPosition;
      } else {
        _knobPosition = centerPosition + deltaFromCenter.normalized() * _maxDistance;
      }
      
      _joystickKnob.position = _knobPosition;
      
      // Calculate relative delta (-1 to 1)
      final actualDelta = _knobPosition - centerPosition;
      _relativeDelta = actualDelta / _maxDistance;
      
      onDragUpdateCallback?.call(label, _relativeDelta);
      
      return true;
    }
    return false;
  }
  
  @override
  bool onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    if (label == 'D' && _isJoystickMode && _isDragging) {
      _isDragging = false;
      onDragEndCallback?.call(label);
      return true;
    }
    return false;
  }

  Vector2 get relativeDelta => _relativeDelta;
}