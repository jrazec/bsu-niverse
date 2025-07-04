import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class MiniJoystickComponent extends PositionComponent with HasGameRef, DragCallbacks {
  late final CircleComponent _background;
  late final CircleComponent _knob;
  Vector2 _knobPosition = Vector2.zero();
  Vector2 _relativeDelta = Vector2.zero();
  final double _maxDistance;
  bool _isDragging = false;
  Function(Vector2)? onDirectionChanged;

  MiniJoystickComponent({
    required Vector2 position,
    required Vector2 size,
    this.onDirectionChanged,
  }) : _maxDistance = size.x / 2 - 10,
       super(
          position: position,
          size: size,
        ) {
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    final radius = size.x / 2;
    final knobRadius = radius * 0.4;

    _background = CircleComponent(
      radius: radius,
      paint: Paint()
        ..color = Colors.grey.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
      anchor: Anchor.center,
      position: size / 2,
    );

    _knob = CircleComponent(
      radius: knobRadius,
      paint: Paint()..color = Colors.orange.withOpacity(0.8),
      anchor: Anchor.center,
      position: size / 2,
    );

    _knobPosition = size / 2;

    add(_background);
    add(_knob);
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    if (!_isDragging) {
      // Return knob to center with smooth animation
      final centerPosition = size / 2;
      final direction = centerPosition - _knobPosition;
      
      if (direction.length > 1) {
        _knobPosition += direction.normalized() * 200 * dt;
        _knob.position = _knobPosition;
        
        // Update relative delta
        final deltaFromCenter = _knobPosition - centerPosition;
        _relativeDelta = deltaFromCenter.length > _maxDistance 
          ? deltaFromCenter.normalized() * _maxDistance 
          : deltaFromCenter;
        _relativeDelta = _relativeDelta / _maxDistance;
        
        onDirectionChanged?.call(_relativeDelta);
      } else {
        _knobPosition = centerPosition;
        _knob.position = _knobPosition;
        _relativeDelta = Vector2.zero();
        onDirectionChanged?.call(_relativeDelta);
      }
    }
  }

  @override
  bool onDragUpdate(DragUpdateEvent event) {
    _isDragging = true;
    
    final localPosition = event.localEndPosition;
    final centerPosition = size / 2;
    final deltaFromCenter = localPosition - centerPosition;
    
    if (deltaFromCenter.length <= _maxDistance) {
      _knobPosition = localPosition;
    } else {
      _knobPosition = centerPosition + deltaFromCenter.normalized() * _maxDistance;
    }
    
    _knob.position = _knobPosition;
    
    // Calculate relative delta (-1 to 1)
    final actualDelta = _knobPosition - centerPosition;
    _relativeDelta = actualDelta / _maxDistance;
    
    onDirectionChanged?.call(_relativeDelta);
    
    return true;
  }

  @override
  bool onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _isDragging = false;
    return true;
  }

  Vector2 get relativeDelta => _relativeDelta;
}
