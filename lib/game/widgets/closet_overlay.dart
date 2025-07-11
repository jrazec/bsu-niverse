import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'dart:ui' as ui;

/// Closet Overlay System for Character Outfit Customization
/// 
/// This system provides a character outfit selection interface with:
/// - Visual closet background with outfit selection area
/// - 2x2 grid layout for outfit buttons with preview images
/// - Outfit selection with visual feedback (highlighting)
/// - Confirmation/Cancel buttons to save or discard changes
/// - Player movement disabled while overlay is active
/// 
/// Available Outfits:
/// - PE Uniform (boy_pe.png)
/// - JPCS Set (boy_jpcs.png) 
/// - TechIS Set (boy_techis.png)
/// - School Uniform (boy_uniform.png)

class OutfitConfig {
  final String displayName;
  final String spriteFileName;
  final String previewImagePath;
  
  const OutfitConfig({
    required this.displayName,
    required this.spriteFileName,
    required this.previewImagePath,
  });
}

class ClosetOverlay extends StatefulWidget {
  final FlameGame game;
  final Future<void> Function(String) onOutfitSelected; // Called when outfit is confirmed
  final void Function() onClosed; // Called when overlay is closed
  final String currentOutfit; // Current player outfit sprite filename
  
  // Available outfits configuration
  static const List<OutfitConfig> availableOutfits = [
    OutfitConfig(
      displayName: 'School Uniform',
      spriteFileName: 'boy_uniform.png',
      previewImagePath: 'men_school_unif.png',
    ),
    OutfitConfig(
      displayName: 'PE Uniform',
      spriteFileName: 'boy_pe.png',
      previewImagePath: 'pe_uniform.png',
    ),
    OutfitConfig(
      displayName: 'JPCS Set',
      spriteFileName: 'boy_jpcs.png', 
      previewImagePath: 'jpcs_set.png',
    ),
    OutfitConfig(
      displayName: 'TechIS Set',
      spriteFileName: 'boy_techis.png',
      previewImagePath: 'tech_is_set.png',
    ),
  ];

  const ClosetOverlay({
    Key? key,
    required this.game,
    required this.onOutfitSelected,
    required this.onClosed,
    required this.currentOutfit,
  }) : super(key: key);

  @override
  State<ClosetOverlay> createState() => _ClosetOverlayState();
}

class _ClosetOverlayState extends State<ClosetOverlay> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  
  String? selectedOutfit;
  bool _isClosing = false;
  
  @override
  void initState() {
    super.initState();
    
    // Set current outfit as initially selected
    selectedOutfit = widget.currentOutfit;
    
    // Fade animation for overlay appearance
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    // Scale animation for content
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    // Start animations
    _fadeController.forward();
    _scaleController.forward();
  }
  
  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
  
  void _closeOverlay() {
    if (_isClosing) return;
    _isClosing = true;
    
    _fadeController.reverse().then((_) {
      widget.onClosed();
    });
  }
  
  Future<void> _confirmSelection() async {
    print("Confirm selection called with selectedOutfit: $selectedOutfit");
    if (selectedOutfit != null && selectedOutfit != widget.currentOutfit) {
      print("Calling onOutfitSelected with: $selectedOutfit");
      try {
        await widget.onOutfitSelected(selectedOutfit!);
        print("onOutfitSelected completed successfully");
      } catch (e) {
        print("Error in onOutfitSelected: $e");
      }
    }
    print("Closing overlay after confirmation");
    _closeOverlay();
  }
  
  Widget _buildOutfitButton(OutfitConfig outfit) {
    final bool isSelected = selectedOutfit == outfit.spriteFileName;
    final bool isCurrent = widget.currentOutfit == outfit.spriteFileName;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOutfit = outfit.spriteFileName;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.yellow : Colors.white,
            width: isSelected ? 3 : 1, // Thinner borders for mobile
          ),
          borderRadius: BorderRadius.circular(8), // Smaller border radius
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.yellow.withOpacity(0.5),
              blurRadius: 6, // Smaller shadow for mobile
              spreadRadius: 1, // Smaller shadow spread
            ),
          ] : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6), // Smaller border radius
          child: Stack(
            children: [
              // Background
              Container(
                color: Colors.black54,
              ),
              // Outfit preview image
              FutureBuilder<ui.Image>(
                future: _loadImage(outfit.previewImagePath),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CustomPaint(
                      size: Size.infinite,
                      painter: _OutfitImagePainter(snapshot.data!),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                },
              ),
              // Current outfit indicator
              if (isCurrent)
                Positioned(
                  top: 2, // Smaller position offset
                  right: 2, // Smaller position offset
                  child: Container(
                    padding: const EdgeInsets.all(2), // Smaller padding
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4), // Smaller border radius
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 10, // Much smaller icon for mobile
                    ),
                  ),
                ),
              // Outfit name
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4), // Smaller padding
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(6), // Smaller border radius
                      bottomRight: Radius.circular(6), // Smaller border radius
                    ),
                  ),
                  child: Text(
                    outfit.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8, // Much smaller font for mobile - reduced from 10 to 8
                      fontWeight: FontWeight.bold,
                      fontFamily: 'VT323',
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<ui.Image> _loadImage(String path) async {
    final imageData = await widget.game.images.load(path);
    return imageData;
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final overlayWidth = screenSize.width * 0.95; // Reverted back to original size
    final overlayHeight = screenSize.height * 0.9; // Reverted back to original size
    
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            width: screenSize.width,
            height: screenSize.height,
            color: Colors.black.withOpacity(0.7),
            child: Center(
              child: AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: overlayWidth,
                      height: overlayHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          children: [
                            // Closet background
                            FutureBuilder<ui.Image>(
                              future: _loadImage('closet.jpg'),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return CustomPaint(
                                    size: Size(overlayWidth, overlayHeight),
                                    painter: _ClosetBackgroundPainter(snapshot.data!),
                                  );
                                }
                                return Container(color: Colors.brown);
                              },
                            ),
                            
                            // Content overlay
                            Container(
                              padding: const EdgeInsets.all(8), // Reverted back to original padding
                              child: Column(
                                children: [
                                  // Title
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), // Reverted back to original padding
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(10), // Reverted back to original border radius
                                      border: Border.all(color: Colors.white, width: 2), // Reverted back to original border
                                    ),
                                    child: const Text(
                                      'CHOOSE YOUR OUTFIT',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16, // Reverted back to original font size
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'VT323',
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 6), // Keep smaller spacing
                                  
                                  // Outfit selection area (2x2 grid)
                                  Expanded(
                                    flex: 6, // Keep increased flex for more grid space
                                    child: Center( // Center the entire grid container
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.8, // Limit width to 80% of screen
                                          maxHeight: MediaQuery.of(context).size.height * 0.6, // Limit height to 60% of screen
                                        ),
                                        padding: const EdgeInsets.all(20), // More padding to center the smaller buttons
                                        child: GridView.count(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 20, // More spacing between smaller buttons
                                          mainAxisSpacing: 20, // More spacing between smaller buttons
                                          childAspectRatio: 2.5, // Much higher ratio to make buttons very small and wide
                                          shrinkWrap: true, // Allow grid to take only needed space
                                          children: ClosetOverlay.availableOutfits.map((outfit) {
                                            return _buildOutfitButton(outfit);
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 6), // Keep smaller spacing
                                  
                                  // Action buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Cancel button
                                      ElevatedButton(
                                        onPressed: _closeOverlay,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16, // Reverted back to original padding
                                            vertical: 6, // Keep smaller vertical padding
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Reverted back to original border radius
                                          ),
                                        ),
                                        child: const Text(
                                          'CANCEL',
                                          style: TextStyle(
                                            fontSize: 12, // Keep smaller font
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'VT323',
                                          ),
                                        ),
                                      ),
                                      
                                      // Confirm button
                                      ElevatedButton(
                                        onPressed: selectedOutfit == widget.currentOutfit 
                                          ? _closeOverlay 
                                          : _confirmSelection,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: selectedOutfit == widget.currentOutfit 
                                            ? Colors.grey 
                                            : Colors.green,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16, // Reverted back to original padding
                                            vertical: 6, // Keep smaller vertical padding
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8), // Reverted back to original border radius
                                          ),
                                        ),
                                        child: Text(
                                          selectedOutfit == widget.currentOutfit 
                                            ? 'CLOSE' 
                                            : 'CONFIRM',
                                          style: const TextStyle(
                                            fontSize: 12, // Keep smaller font
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'VT323',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

// Custom painter for closet background
class _ClosetBackgroundPainter extends CustomPainter {
  final ui.Image image;
  
  _ClosetBackgroundPainter(this.image);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for outfit preview images
class _OutfitImagePainter extends CustomPainter {
  final ui.Image image;
  
  _OutfitImagePainter(this.image);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    // Calculate scale to fit image in button while maintaining aspect ratio
    final imageAspect = image.width / image.height;
    final containerAspect = size.width / size.height;
    
    double drawWidth, drawHeight, offsetX, offsetY;
    
    if (imageAspect > containerAspect) {
      // Image is wider, fit to width
      drawWidth = size.width;
      drawHeight = size.width / imageAspect;
      offsetX = 0;
      offsetY = (size.height - drawHeight) / 2;
    } else {
      // Image is taller, fit to height
      drawHeight = size.height;
      drawWidth = size.height * imageAspect;
      offsetX = (size.width - drawWidth) / 2;
      offsetY = 0;
    }
    
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(offsetX, offsetY, drawWidth, drawHeight),
      paint,
    );
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
