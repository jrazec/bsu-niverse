import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'dart:ui' as ui;

// Custom widget to render a full image (for NPCs that are single images, not sprite sheets)
class FlameImageWidget extends StatelessWidget {
  final FlameGame game;
  final String imagePath;
  final double width;
  final double height;

  const FlameImageWidget({
    Key? key,
    required this.game,
    required this.imagePath,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _loadImage(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomPaint(
            size: Size(width, height),
            painter: _SpriteFramePainter(snapshot.data!),
          );
        } else if (snapshot.hasError) {
          return Container(
            width: width,
            height: height,
            color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person, size: width * 0.3, color: Colors.white),
                Text('NPC', style: TextStyle(color: Colors.white, fontSize: width * 0.1)),
              ],
            ),
          );
        }
        return Container(
          width: width,
          height: height,
          color: Colors.grey.withOpacity(0.3),
          child: Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  Future<ui.Image> _loadImage() async {
    try {
      return await game.images.load(imagePath);
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }
}

// Custom widget to render a specific sprite frame from a sprite sheet
class SpriteFrameWidget extends StatelessWidget {
  final FlameGame game;
  final String imagePath;
  final int frameIndex;
  final double width;
  final double height;

  const SpriteFrameWidget({
    Key? key,
    required this.game,
    required this.imagePath,
    required this.frameIndex,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ui.Image>(
      future: _loadSpriteFrame(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CustomPaint(
            size: Size(width, height),
            painter: _SpriteFramePainter(snapshot.data!),
          );
        } else if (snapshot.hasError) {
          return Container(
            width: width,
            height: height,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.boy, size: width * 0.4, color: Colors.white),
                Text('PLAYER', style: TextStyle(color: Colors.white, fontSize: width * 0.1)),
              ],
            ),
          );
        }
        return Container(
          width: width,
          height: height,
          color: Colors.grey.withOpacity(0.3),
          child: Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  Future<ui.Image> _loadSpriteFrame() async {
    try {
      final image = await game.images.load(imagePath);
      
      // Calculate frame position in sprite sheet
      // Assuming 32x32 frames and the sprite sheet is arranged in rows
      final frameWidth = 32;
      final frameHeight = 32;
      final framesPerRow = image.width ~/ frameWidth;
      
      final sourceX = (frameIndex % framesPerRow) * frameWidth;
      final sourceY = (frameIndex ~/ framesPerRow) * frameHeight;
      
      // Create a new canvas to draw the specific frame
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      // Draw the specific frame from the sprite sheet
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(sourceX.toDouble(), sourceY.toDouble(), frameWidth.toDouble(), frameHeight.toDouble()),
        Rect.fromLTWH(0, 0, width, height),
        Paint(),
      );
      
      final picture = recorder.endRecording();
      return await picture.toImage(width.toInt(), height.toInt());
    } catch (e) {
      throw Exception('Failed to load sprite frame: $e');
    }
  }
}

class _SpriteFramePainter extends CustomPainter {
  final ui.Image image;
  
  _SpriteFramePainter(this.image);
  
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint(),
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class QuestOverlay extends StatelessWidget {
  final FlameGame game;
  final String question;
  final List<String> options;
  final void Function(int) onOptionSelected;
  final int hearts; // Number of hearts remaining
  

  const QuestOverlay({
    Key? key,
    required this.game,
    required this.question,
    required this.options,
    required this.onOptionSelected,
    this.hearts = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLandscape = screenWidth > screenHeight;
    
    // Calculate scaling factor based on screen size
    // Base sizes are optimized for mobile (~360-400dp width)
    final double baseWidth = 400.0;
    final double scaleFactor = (screenWidth / baseWidth).clamp(1.0, 2.5); // Cap at 2.5x for very large screens
    
    final double npcWidth = (isLandscape ? 95 : 150) * scaleFactor;
    final double npcHeight = (isLandscape ? 95 : 150) * scaleFactor;
    
    
    final double playerWidth = (isLandscape ? 120 : 240) * scaleFactor;
    final double playerHeight = (isLandscape ? 120 : 240) * scaleFactor;
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 225, 247, 255),
             Color.fromARGB(255, 201, 233, 244),
            Color.fromARGB(255, 225, 232, 173),
            Color.fromARGB(255, 198, 90, 76), 
          ],
        ),
      ),
      child: Stack(
        children: [
          // Hearts indicator (top left) - consistent size
          Positioned(
            top: 30,
            left: isLandscape ? screenWidth * 0.15 : 15,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 3,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    child: Text(
                      index < hearts ? '❤️' : '🖤',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }),
              ),
            ),
          ),
          
          // NPC sprite (top right) - responsive positioning
          Positioned(
            top: isLandscape ? 25 : screenHeight * 0.15,
            right: isLandscape ? screenWidth * 0.15 : 30,
            child: Container(
              width: npcWidth,
              height: npcHeight,
              child: FlameImageWidget(
                game: game,
                imagePath: 'sirt.png',
                width: npcWidth,
                height: npcHeight,
              ),
            ),
          ),
          
          // Player sprite (bottom left) - responsive positioning
          Positioned(
            bottom: isLandscape ? screenHeight * 0.20 : screenHeight * 0.40,
            left: isLandscape ? screenWidth * 0.15 : 15, // Better positioning in landscape
            child: Container(
              width: playerWidth,
              height: playerHeight,
              child: SpriteFrameWidget(
                game: game,
                imagePath: 'boy_pe.png',
                frameIndex: 3, // Frame 3 shows character facing back
                width: playerWidth,
                height: playerHeight,
              ),
            ),
          ),
          
          // Question box (bottom center) - responsive sizing
          Positioned(
            bottom: isLandscape ? screenHeight * 0.05 : screenHeight * 0.10,
            left: isLandscape ? screenWidth * 0.15 : 15,
            right: isLandscape ? screenWidth * 0.15 : 15,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: isLandscape ? screenHeight * 0.75 : screenHeight * 0.55,
              ),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF6E0E15), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(3, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Question text area - responsive sizing
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isLandscape ? 8 : 12),
                    margin: EdgeInsets.only(bottom: isLandscape ? 8 : 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey[400]!, width: 2),
                    ),
                    child: Text(
                      question,
                      style: TextStyle(
                        fontFamily: 'VT323',
                        fontSize: isLandscape ? 16 : 18,
                        color: Colors.black,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  
                  // Options grid (2x2) - responsive sizing
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    mainAxisSpacing: isLandscape ? 6 : 8,
                    crossAxisSpacing: isLandscape ? 6 : 8,
                    childAspectRatio: isLandscape ? 10.5 : 3.5,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(options.length, (index) {
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6E0E15),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: isLandscape ? 4 : 6,
                              vertical: isLandscape ? 2 : 4,
                            ),
                            elevation: 0,
                          ),
                          onPressed: () => onOptionSelected(index),
                          child: Text(
                            options[index],
                            style: TextStyle(
                              fontFamily: 'VT323',
                              fontSize: isLandscape ? 14 : 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
