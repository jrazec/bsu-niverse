import 'package:flutter/material.dart';
import '../data/popup_configs.dart';

/// Pokemon-style quest dialogue overlay that appears at the bottom of the screen
class QuestDialogueOverlay extends StatefulWidget {
  final PopupConfig questConfig;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final VoidCallback onClose;

  const QuestDialogueOverlay({
    Key? key,
    required this.questConfig,
    required this.onAccept,
    required this.onDecline,
    required this.onClose,
  }) : super(key: key);

  @override
  State<QuestDialogueOverlay> createState() => _QuestDialogueOverlayState();
}

class _QuestDialogueOverlayState extends State<QuestDialogueOverlay>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  bool _showChoices = false;

  // Color scheme
  final Color championWhite = Color.fromRGBO(250, 249, 246, 1.0);
  final Color pixelGold = Color.fromRGBO(255, 215, 0, 1.0);
  final Color charcoalBlack = Color.fromRGBO(27, 27, 27, 1.0);
  final Color ashMaroon = Color.fromRGBO(110, 14, 21, 1.0);
  final Color fineRed = Color.fromRGBO(201, 33, 30, 1.0);

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // Start from bottom
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _slideController.forward();

    // Show choices after dialogue is displayed
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showChoices = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _onAccept() {
    widget.onAccept();
    _closeDialogue();
  }

  void _onDecline() {
    widget.onDecline();
    _closeDialogue();
  }

  void _closeDialogue() {
    _slideController.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isLandscape = screenWidth > screenHeight;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Semi-transparent overlay
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.3),
          ),

          // Pokemon-style dialogue box at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: isLandscape ? screenHeight * 0.65 : screenHeight * 0.55,
                ),
                decoration: BoxDecoration(
                  color: championWhite,
                  border: Border.all(color: charcoalBlack, width: 4),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: charcoalBlack.withOpacity(0.5),
                      offset: const Offset(0, -4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Quest title bar
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: ashMaroon,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.assignment,
                            color: championWhite,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.questConfig.questTitle,
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: championWhite,
                              ),
                            ),
                          ),
                          // Close button
                          GestureDetector(
                            onTap: _closeDialogue,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: fineRed,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                Icons.close,
                                color: championWhite,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable content area
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location info
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: pixelGold.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: pixelGold, width: 1),
                              ),
                              child: Text(
                                widget.questConfig.location,
                                style: TextStyle(
                                  fontFamily: 'PixeloidSans',
                                  fontSize: 12,
                                  color: charcoalBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Main dialogue text
                            Text(
                              widget.questConfig.dialogue,
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 16,
                                color: charcoalBlack,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Quest description
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.grey[300]!, width: 1),
                              ),
                              child: Text(
                                widget.questConfig.questDescription,
                                style: TextStyle(
                                  fontFamily: 'PixeloidSans',
                                  fontSize: 14,
                                  color: charcoalBlack,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Fixed bottom section with choices
                    if (_showChoices)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border: Border(
                            top: BorderSide(color: Colors.grey[300]!, width: 1),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Coin reward info
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: pixelGold.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: pixelGold, width: 1),
                              ),
                              child: Text(
                                'Reward: +${widget.questConfig.coinsReward} coins',
                                style: TextStyle(
                                  fontFamily: 'PixeloidSans',
                                  fontSize: 12,
                                  color: charcoalBlack,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),

                            // Action buttons row
                            Row(
                              children: [
                                // Decline button
                                Expanded(
                                  child: _buildChoiceButton(
                                    'DECLINE',
                                    onPressed: _onDecline,
                                    backgroundColor: Colors.grey[400]!,
                                    textColor: charcoalBlack,
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Accept button
                                Expanded(
                                  child: _buildChoiceButton(
                                    'ACCEPT',
                                    onPressed: _onAccept,
                                    backgroundColor: ashMaroon,
                                    textColor: championWhite,
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
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceButton(
    String text, {
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: charcoalBlack, width: 2),
          boxShadow: [
            BoxShadow(
              color: charcoalBlack.withOpacity(0.3),
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'VT323',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}

/// Task discovery notification that appears at the top center and fades away
class TaskDiscoveryNotification extends StatefulWidget {
  final int taskCount;
  final VoidCallback onComplete;

  const TaskDiscoveryNotification({
    Key? key,
    required this.taskCount,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<TaskDiscoveryNotification> createState() => _TaskDiscoveryNotificationState();
}

class _TaskDiscoveryNotificationState extends State<TaskDiscoveryNotification>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Color scheme
  final Color championWhite = Color.fromRGBO(250, 249, 246, 1.0);
  final Color pixelGold = Color.fromRGBO(255, 215, 0, 1.0);
  final Color charcoalBlack = Color.fromRGBO(27, 27, 27, 1.0);
  final Color ashMaroon = Color.fromRGBO(110, 14, 21, 1.0);

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 3000), // 3 seconds total
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.0, 0.2), // Fade in first 20%
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _slideController.forward();
    _fadeController.forward();

    // Auto close after 3 seconds
    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) {
        _slideController.reverse().then((_) {
          widget.onComplete();
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(  // Add Stack wrapper here
        children: [
          Positioned(
            top: 80,
            left: 20,
            right: 20,
            child: AnimatedBuilder(
              animation: Listenable.merge([_fadeAnimation, _slideAnimation]),
              builder: (context, child) {
                return SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: ashMaroon,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: pixelGold, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: charcoalBlack.withOpacity(0.5),
                            offset: const Offset(0, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            color: pixelGold,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              '${widget.taskCount} task${widget.taskCount > 1 ? 's' : ''} discovered!',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: championWhite,
                              ),
                              textAlign: TextAlign.center,
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
        ],
      ),
    );
  }
}
