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
  final int cost; // Cost in SpartaCoins to unlock (0 means free/default)
  final bool isDefault; // Whether this outfit is unlocked by default
  
  const OutfitConfig({
    required this.displayName,
    required this.spriteFileName,
    required this.previewImagePath,
    this.cost = 0,
    this.isDefault = false,
  });
}

class ClosetOverlay extends StatefulWidget {
  final FlameGame game;
  final Future<void> Function(String) onOutfitSelected; // Called when outfit is confirmed
  final void Function() onClosed; // Called when overlay is closed
  final String currentOutfit; // Current player outfit sprite filename
  final int Function() getSpartaCoins; // Function to get current SpartaCoins
  final void Function(int) removeSpartaCoins; // Function to remove SpartaCoins
  final Set<String> unlockedOutfits; // Set of unlocked outfit sprite filenames
  final void Function(String) onOutfitUnlocked; // Function to persist unlocked outfit to game
  
  // Available outfits configuration
  static const List<OutfitConfig> availableOutfits = [
    OutfitConfig(
      displayName: 'School Uniform',
      spriteFileName: 'boy_uniform.png',
      previewImagePath: 'men_school_unif.png',
      cost: 0, // Free/default outfit
      isDefault: true,
    ),
    OutfitConfig(
      displayName: 'PE Uniform',
      spriteFileName: 'boy_pe.png',
      previewImagePath: 'pe_uniform.png',
      cost: 5, // Costs 5 SpartaCoins
      isDefault: false,
    ),
    OutfitConfig(
      displayName: 'JPCS Set',
      spriteFileName: 'boy_jpcs.png', 
      previewImagePath: 'jpcs_set.png',
      cost: 5, // Costs 5 SpartaCoins
      isDefault: false,
    ),
    OutfitConfig(
      displayName: 'TechIS Set',
      spriteFileName: 'boy_techis.png',
      previewImagePath: 'tech_is_set.png',
      cost: 5, // Costs 5 SpartaCoins
      isDefault: false,
    ),
  ];

  // Female outfit configurations
  static const List<OutfitConfig> femaleOutfits = [
    OutfitConfig(
      displayName: 'School Uniform',
      spriteFileName: 'girl_uniform.png',
      previewImagePath: 'women_school_unif.png',
      cost: 0, // Free/default outfit
      isDefault: true,
    ),
    OutfitConfig(
      displayName: 'PE Uniform',
      spriteFileName: 'girl_pe.png',
      previewImagePath: 'pe_uniform.png',
      cost: 5, // Costs 5 SpartaCoins
      isDefault: false,
    ),
    OutfitConfig(
      displayName: 'JPCS Set',
      spriteFileName: 'girl_jpcs.png', 
      previewImagePath: 'jpcs_set.png',
      cost: 5, // Costs 5 SpartaCoins
      isDefault: false,
    ),
    OutfitConfig(
      displayName: 'TechIS Set',
      spriteFileName: 'girl_techis.png',
      previewImagePath: 'tech_is_set.png',
      cost: 5, // Costs 5 SpartaCoins
      isDefault: false,
    ),
  ];

  const ClosetOverlay({
    Key? key,
    required this.game,
    required this.onOutfitSelected,
    required this.onClosed,
    required this.currentOutfit,
    required this.getSpartaCoins,
    required this.removeSpartaCoins,
    required this.unlockedOutfits,
    required this.onOutfitUnlocked,
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
  late Set<String> _unlockedOutfits;
  late int _currentCoins;
  bool _isFemaleMode = false; // Toggle for boy/girl sprites
  
  @override
  void initState() {
    super.initState();
    
    // Detect current gender from outfit filename
    _isFemaleMode = widget.currentOutfit.startsWith('girl_');
    
    // Set current outfit as initially selected
    selectedOutfit = widget.currentOutfit;
    
    // Initialize unlocked outfits and current coins
    _unlockedOutfits = Set.from(widget.unlockedOutfits);
    _currentCoins = widget.getSpartaCoins();
    
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
  
  // Get current outfits based on gender selection
  List<OutfitConfig> get _currentOutfits => _isFemaleMode ? ClosetOverlay.femaleOutfits : ClosetOverlay.availableOutfits;
  
  // Check if a given outfit sprite filename is equivalent to the current outfit
  // This handles cross-gender outfit equivalence (e.g., boy_uniform.png = girl_uniform.png)
  bool _isCurrentOutfitEquivalent(String outfitFileName) {
    if (widget.currentOutfit == outfitFileName) {
      return true; // Exact match
    }
    
    // Find the index of the current outfit in its original gender list
    final bool currentIsGirl = widget.currentOutfit.startsWith('girl_');
    final List<OutfitConfig> originalList = currentIsGirl ? ClosetOverlay.femaleOutfits : ClosetOverlay.availableOutfits;
    final int currentIndex = originalList.indexWhere((outfit) => outfit.spriteFileName == widget.currentOutfit);
    
    if (currentIndex == -1) return false; // Current outfit not found
    
    // Check if the given outfit is at the same index in the other gender list
    final List<OutfitConfig> otherList = currentIsGirl ? ClosetOverlay.availableOutfits : ClosetOverlay.femaleOutfits;
    if (currentIndex < otherList.length) {
      return otherList[currentIndex].spriteFileName == outfitFileName;
    }
    
    return false;
  }
  
  // Toggle between male and female outfits
  void _toggleGender() {
    setState(() {
      _isFemaleMode = !_isFemaleMode;
      // When switching gender, select the equivalent outfit in the new gender
      if (selectedOutfit != null) {
        final previousOutfits = _isFemaleMode ? ClosetOverlay.availableOutfits : ClosetOverlay.femaleOutfits;
        final currentOutfits = _currentOutfits;
        
        // Find the index of the currently selected outfit in the previous gender's list
        final currentIndex = previousOutfits.indexWhere((outfit) => outfit.spriteFileName == selectedOutfit);
        
        if (currentIndex >= 0 && currentIndex < currentOutfits.length) {
          // Map to equivalent outfit in new gender (same index position)
          selectedOutfit = currentOutfits[currentIndex].spriteFileName;
        } else {
          // Default to uniform if no equivalent found
          selectedOutfit = currentOutfits[0].spriteFileName;
        }
      }
    });
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
      // Check if the selected outfit is unlocked before confirming
      final selectedOutfitConfig = _currentOutfits.firstWhere(
        (outfit) => outfit.spriteFileName == selectedOutfit,
      );
      final isUnlocked = selectedOutfitConfig.isDefault || _unlockedOutfits.contains(selectedOutfit);
      
      if (isUnlocked) {
        print("Calling onOutfitSelected with: $selectedOutfit");
        try {
          await widget.onOutfitSelected(selectedOutfit!);
          print("onOutfitSelected completed successfully");
        } catch (e) {
          print("Error in onOutfitSelected: $e");
        }
      } else {
        print("Cannot confirm locked outfit: $selectedOutfit");
        return; // Don't close overlay if outfit is locked
      }
    }
    print("Closing overlay after confirmation");
    _closeOverlay();
  }
  
  Widget _buildOutfitButton(OutfitConfig outfit) {
    final bool isSelected = selectedOutfit == outfit.spriteFileName;
    // Check if this outfit corresponds to the current outfit (considering gender equivalence)
    final bool isCurrent = _isCurrentOutfitEquivalent(outfit.spriteFileName);
    final bool isUnlocked = outfit.isDefault || _unlockedOutfits.contains(outfit.spriteFileName);
    final bool canAfford = _currentCoins >= outfit.cost;
    
    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          // Allow selection if unlocked
          setState(() {
            selectedOutfit = outfit.spriteFileName;
          });
        } else if (canAfford && outfit.cost > 0) {
          // Show unlock dialog if locked but affordable
          _showUnlockDialog(outfit);
        } else {
          // Show insufficient funds message
          _showInsufficientFundsDialog(outfit);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.yellow : (isUnlocked ? Colors.white : Colors.red),
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.yellow.withOpacity(0.5),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ] : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              // Background
              Container(
                color: isUnlocked ? Colors.black54 : Colors.black87, // Darker for locked
              ),
              // Outfit preview image
              FutureBuilder<ui.Image>(
                key: ValueKey('${outfit.previewImagePath}_${_isFemaleMode}'), // Force rebuild when gender changes
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
              // Lock overlay for locked outfits
              if (!isUnlocked)
                Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const Center(
                    child: Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              // Cost display for locked outfits
              if (!isUnlocked && outfit.cost > 0)
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: canAfford ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '🪙${outfit.cost}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
                      fontSize: 16, // Much smaller font for mobile - reduced from 10 to 8
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
  
  // Show dialog to confirm outfit unlock
  void _showUnlockDialog(OutfitConfig outfit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: Text(
            'Unlock ${outfit.displayName}?',
            style: const TextStyle(color: Colors.white, fontFamily: 'VT323'),
          ),
          content: Text(
            'This will cost ${outfit.cost} SpartaCoins.\nYou currently have $_currentCoins coins.',
            style: const TextStyle(color: Colors.white, fontFamily: 'VT323'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _unlockOutfit(outfit);
              },
              child: const Text('Unlock', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
  
  // Show dialog for insufficient funds
  void _showInsufficientFundsDialog(OutfitConfig outfit) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          title: const Text(
            'Insufficient SpartaCoins',
            style: TextStyle(color: Colors.white, fontFamily: 'VT323'),
          ),
          content: Text(
            'You need ${outfit.cost} SpartaCoins to unlock ${outfit.displayName}.\nYou currently have $_currentCoins coins.',
            style: const TextStyle(color: Colors.white, fontFamily: 'VT323'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
  
  // Unlock an outfit by spending coins
  void _unlockOutfit(OutfitConfig outfit) {
    setState(() {
      _unlockedOutfits.add(outfit.spriteFileName);
      _currentCoins -= outfit.cost;
      widget.removeSpartaCoins(outfit.cost);
      widget.onOutfitUnlocked(outfit.spriteFileName); // Persist unlock to game
      selectedOutfit = outfit.spriteFileName; // Auto-select the newly unlocked outfit
    });
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
                              future: _loadImage('closet.png'),
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
                                  // Title and SpartaCoins display row
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Title
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                        child: const Text(
                                          'CHOOSE YOUR OUTFIT',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'VT323',
                                          ),
                                        ),
                                      ),
                                      
                                      // Right side - Gender toggle and SpartaCoins
                                      Row(
                                        children: [
                                          // Gender toggle button
                                          GestureDetector(
                                            onTap: _toggleGender,
                                            child: Container(
                                              width: 80,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: _isFemaleMode ? Colors.pink.withOpacity(0.3) : Colors.blue.withOpacity(0.3),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(color: Colors.white, width: 2),
                                              ),
                                              child: Stack(
                                                children: [
                                                  // Switch background with labels
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height: 32,
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            '♂️',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: !_isFemaleMode ? Colors.white : Colors.white.withOpacity(0.5),
                                                              height: 1.0,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          height: 32,
                                                          alignment: Alignment.center,
                                                          child: Text(
                                                            '♀️',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              color: _isFemaleMode ? Colors.white : Colors.white.withOpacity(0.5),
                                                              height: 1.0,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  // Sliding indicator
                                                  AnimatedPositioned(
                                                    duration: const Duration(milliseconds: 200),
                                                    curve: Curves.easeInOut,
                                                    left: _isFemaleMode ? 40 : 0,
                                                    top: 0,                                                      child: Container(
                                                        width: 40,
                                                        height: 32,
                                                        alignment: Alignment.center,
                                                        decoration: BoxDecoration(
                                                          color: _isFemaleMode ? Colors.pink : Colors.blue,
                                                          borderRadius: BorderRadius.circular(16),
                                                          border: Border.all(color: Colors.white, width: 2),
                                                        ),
                                                        child: Text(
                                                          _isFemaleMode ? '♀️' : '♂️',
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            height: 1.0,
                                                          ),
                                                          textAlign: TextAlign.center,
                                                        ),
                                                      ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          
                                          const SizedBox(width: 8), // Space between gender toggle and coins
                                          
                                          // SpartaCoins display
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.8),
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: Colors.amber, width: 2),
                                            ),
                                            child: Text(
                                              '🪙 $_currentCoins',
                                              style: const TextStyle(
                                                color: Colors.amber,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'VT323',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
                                          children: _currentOutfits.map((outfit) {
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
                                            fontSize: 24, // Keep smaller font
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'VT323',
                                          ),
                                        ),
                                      ),
                                      
                                      // Confirm button
                                      ElevatedButton(
                                        onPressed: () {
                                          if (selectedOutfit == widget.currentOutfit) {
                                            _closeOverlay();
                                          } else {
                                            // Check if selected outfit is unlocked
                                            final selectedOutfitConfig = _currentOutfits.firstWhere(
                                              (outfit) => outfit.spriteFileName == selectedOutfit,
                                            );
                                            final isUnlocked = selectedOutfitConfig.isDefault || _unlockedOutfits.contains(selectedOutfit);
                                            if (isUnlocked) {
                                              _confirmSelection();
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: () {
                                            if (selectedOutfit == widget.currentOutfit) return Colors.grey;
                                            final selectedOutfitConfig = _currentOutfits.firstWhere(
                                              (outfit) => outfit.spriteFileName == selectedOutfit,
                                            );
                                            final isUnlocked = selectedOutfitConfig.isDefault || _unlockedOutfits.contains(selectedOutfit);
                                            return isUnlocked ? Colors.green : Colors.red;
                                          }(),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 6,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          () {
                                            if (selectedOutfit == widget.currentOutfit) return 'CLOSE';
                                            final selectedOutfitConfig = _currentOutfits.firstWhere(
                                              (outfit) => outfit.spriteFileName == selectedOutfit,
                                            );
                                            final isUnlocked = selectedOutfitConfig.isDefault || _unlockedOutfits.contains(selectedOutfit);
                                            return isUnlocked ? 'CONFIRM' : 'LOCKED';
                                          }(),
                                          style: const TextStyle(
                                            fontSize: 24,
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
