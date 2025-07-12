import 'package:bsuniverse/game/sound_manager.dart';
import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import '../bsuniverse.dart';

// Color scheme from the project
final Color championWhite = Color.fromRGBO(250, 249, 246, 1.0);
final Color pixelGold = Color.fromRGBO(255, 215, 0, 1.0);
final Color lavanderGray = Color.fromRGBO(197, 197, 214, 1.0);
final Color blazingOrange = Color.fromRGBO(255, 106, 0, 1.0);
final Color charcoalBlack = Color.fromRGBO(27, 27, 27, 1.0);
final Color ashMaroon = Color.fromRGBO(110, 14, 21, 1.0);
final Color fineRed = Color.fromRGBO(201, 33, 30, 1.0);

/// In-Game Menu Screen Overlay Component
/// 
/// This component provides a pixel-art styled Pokemon-inspired menu interface featuring:
/// - Real-time coin counter that updates with quest completion status
/// - Active tasks list showing all current popups with their locations
/// - Hamburger menu with options to go to bed, exit game, and audio controls
/// - Scrollable task list with modal popup details for each task
/// - Progress tracking for completed quests per building
class MenuScreenOverlay extends StatefulWidget {
  final BSUniverseGame game;
  final VoidCallback onClose;

  const MenuScreenOverlay({
    Key? key,
    required this.game,
    required this.onClose,
  }) : super(key: key);

  @override
  State<MenuScreenOverlay> createState() => _MenuScreenOverlayState();
}

class _MenuScreenOverlayState extends State<MenuScreenOverlay>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  
  bool _showHamburgerMenu = false;
  double _soundVolume = 0.7;
  List<ActiveTask> _activeTasks = [];
  
  // Task completion tracking for each building
  Map<String, int> _completedTasks = {
    'gzb': 0,
    'abb': 0,
    'lsb': 0,
    'vmb': 0,
    'other': 0,
  };
  
  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _slideController.forward();
    _loadGameData();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _loadGameData() {

    
    // Load active tasks from current popups and player data
    _loadActiveTasks();
    
    // Load sound volume from game settings
    _soundVolume = widget.game.soundManager.musicVolume;
    
    setState(() {});
  }

  void _loadActiveTasks() {
    _activeTasks.clear();
    
    // Load active quests from player data system
    final activeQuests = widget.game.playerData.activeQuests.values.toList();
    for (final quest in activeQuests) {
      _activeTasks.add(ActiveTask(
        id: quest.id,
        title: quest.title,
        description: 'Accepted quest: ${quest.title}',
        location: quest.location,
        building: quest.building,
        isCompleted: false, // Active quests are by definition not completed
        popup: null, // No popup needed for active quests
      ));
    }
    
    // Also get popups from current scene for available (non-accepted) tasks
    if (widget.game.currentScene?.sceneMap != null) {
      final scene = widget.game.currentScene!;
      
      // Find popup components in the current scene
      scene.sceneMap!.children.whereType<Popup>().forEach((popup) {
        // Only show if this quest hasn't been accepted, completed, or declined
        final playerData = widget.game.playerData;
        if (!playerData.isQuestActive(popup.questTitle) && 
            !playerData.isQuestCompleted(popup.questTitle) && 
            !playerData.isQuestDeclined(popup.questTitle)) {
          final buildingFromLocation = _getBuildingFromLocation(popup.location);
          _activeTasks.add(ActiveTask(
            id: popup.questTitle,
            title: popup.questTitle,
            description: popup.dialogue,
            location: popup.location,
            building: buildingFromLocation,
            isCompleted: false,
            popup: popup,
          ));
        }
      });
    }
    
    // Add hint message if no active tasks
    if (_activeTasks.isEmpty) {
      _activeTasks.add(ActiveTask(
        id: 'hint',
        title: 'Explore Buildings',
        description: 'Go to any building to detect tasks for you! Visit GZB, ABB, LSB, or VMB for more quests (5 each), other buildings have 1 quest each.',
        location: 'Campus Map',
        building: 'hint',
        isCompleted: false,
        popup: null,
      ));
    }
  }

  String _getBuildingFromLocation(String location) {
    location = location.toLowerCase();
    if (location.contains('gzb') || location.contains('gonzales')) return 'gzb';
    if (location.contains('abb') || location.contains('administration')) return 'abb';
    if (location.contains('lsb') || location.contains('library')) return 'lsb';
    if (location.contains('vmb') || location.contains('vicente')) return 'vmb';
    return 'other';
  }


  void _markTaskCompleted(String taskId, bool success) {
    setState(() {
      final taskIndex = _activeTasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        final task = _activeTasks[taskIndex];
        task.isCompleted = true;
        
        // Update completion tracking
        _completedTasks[task.building] = (_completedTasks[task.building] ?? 0) + 1;
        
        // Remove completed task after delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _activeTasks.removeAt(taskIndex);
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ashMaroon.withOpacity(0.95),
                fineRed.withOpacity(0.95),
                charcoalBlack.withOpacity(0.95),
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Pixel-art background pattern
                _buildPixelBackground(),
                
                // Main content
                Column(
                  children: [
                    // Header with hamburger, title, and coin counter
                    _buildHeader(),
                    
                    // Tasks section
                    Expanded(
                      child: _buildTasksSection(),
                    ),
                    
                    // Close button at bottom
                    _buildCloseButton(),
                  ],
                ),
                
                // Hamburger menu overlay
                if (_showHamburgerMenu) _buildHamburgerMenu(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPixelBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: PixelBackgroundPainter(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Hamburger menu button
          GestureDetector(
            onTap: () {
              setState(() {
                _showHamburgerMenu = !_showHamburgerMenu;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: pixelGold,
                border: Border.all(color: charcoalBlack, width: 2),
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: charcoalBlack.withOpacity(0.5),
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: 3, width: 24, color: charcoalBlack),
                  const SizedBox(height: 3),
                  Container(height: 3, width: 24, color: charcoalBlack),
                  const SizedBox(height: 3),
                  Container(height: 3, width: 24, color: charcoalBlack),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Title
          Expanded(
            child: Text(
              'QUEST MENU',
              style: TextStyle(
                fontFamily: 'VT323',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: championWhite,
                shadows: [
                  Shadow(
                    color: charcoalBlack,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Coin counter
          _buildCoinCounter(),
        ],
      ),
    );
  }

  Widget _buildCoinCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: pixelGold,
        border: Border.all(color: charcoalBlack, width: 2),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: charcoalBlack.withOpacity(0.5),
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on,
            color: charcoalBlack,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            '${widget.game.spartaCoins.coins}',
            style: TextStyle(
              fontFamily: 'VT323',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: charcoalBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: championWhite.withOpacity(0.95),
        border: Border.all(color: charcoalBlack, width: 3),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: charcoalBlack.withOpacity(0.3),
            offset: const Offset(3, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        children: [
          // Tasks header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ashMaroon,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Text(
              'ACTIVE TASKS',
              style: TextStyle(
                fontFamily: 'VT323',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: championWhite,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          
          // Tasks list
          Expanded(
            child: _activeTasks.isEmpty
                ? _buildEmptyTasksMessage()
                : _buildTasksList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTasksMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 48,
              color: lavanderGray,
            ),
            const SizedBox(height: 16),
            Text(
              'No active tasks',
              style: TextStyle(
                fontFamily: 'VT323',
                fontSize: 18,
                color: charcoalBlack,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore buildings to discover new quests!',
              style: TextStyle(
                fontFamily: 'PixeloidSans',
                fontSize: 12,
                color: lavanderGray,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTasksList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _activeTasks.length,
      itemBuilder: (context, index) {
        final task = _activeTasks[index];
        return _buildTaskItem(task, index);
      },
    );
  }

  Widget _buildTaskItem(ActiveTask task, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: task.isCompleted ? lavanderGray.withOpacity(0.5) : championWhite,
        border: Border.all(
          color: task.building == 'hint' ? blazingOrange : charcoalBlack,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: charcoalBlack.withOpacity(0.2),
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: task.building == 'hint' ? null : () => _showTaskModal(task),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Task icon based on building
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getBuildingColor(task.building),
                    border: Border.all(color: charcoalBlack, width: 1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      _getBuildingIcon(task.building),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Task details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontFamily: 'VT323',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: task.isCompleted ? lavanderGray : charcoalBlack,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        task.location,
                        style: TextStyle(
                          fontFamily: 'PixeloidSans',
                          fontSize: 12,
                          color: task.isCompleted ? lavanderGray : fineRed,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Completion status or tap hint
                if (task.isCompleted)
                  Icon(
                    Icons.check_circle,
                    color: pixelGold,
                    size: 20,
                  )
                else if (task.building != 'hint')
                  Icon(
                    Icons.arrow_forward_ios,
                    color: lavanderGray,
                    size: 16,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getBuildingColor(String building) {
    switch (building) {
      case 'gzb':
        return pixelGold;
      case 'abb':
        return blazingOrange;
      case 'lsb':
        return ashMaroon;
      case 'vmb':
        return fineRed;
      case 'hint':
        return lavanderGray;
      default:
        return championWhite;
    }
  }

  String _getBuildingIcon(String building) {
    switch (building) {
      case 'gzb':
        return '🏢';
      case 'abb':
        return '🏛️';
      case 'lsb':
        return '📚';
      case 'vmb':
        return '🏫';
      case 'hint':
        return '💡';
      default:
        return '📍';
    }
  }

  void _showTaskModal(ActiveTask task) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TaskDetailsModal(
          task: task,
          onClose: () => Navigator.of(context).pop(),
          onMarkCompleted: (success) {
            Navigator.of(context).pop();
            _markTaskCompleted(task.id, success);
          },
        );
      },
    );
  }

  Widget _buildHamburgerMenu() {
    return Positioned(
      top: 80,
      left: 16,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: championWhite,
          border: Border.all(color: charcoalBlack, width: 3),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: charcoalBlack.withOpacity(0.5),
              offset: const Offset(3, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            // Menu header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ashMaroon,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Text(
                'MENU',
                style: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: championWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Menu items
            _buildMenuItem('🛏️ Go to Bed', () => _goToBed()),
            _buildMenuItem('🔊 Sound: ${(_soundVolume * 100).round()}%', () => _adjustSound()),
            _buildMenuItem('❌ Exit Game', () => _exitGame()),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String text, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'VT323',
              fontSize: 14,
              color: charcoalBlack,
            ),
          ),
        ),
      ),
    );
  }

  void _goToBed() {
    // Change scene to bedroom and close menu
    widget.game.changeScene(GoTo.bedroom, Vector2(104, 66));
    _closeMenu();
  }

  void _adjustSound() {
    setState(() {
      _soundVolume = (_soundVolume + 0.1) % 1.1;
      if (_soundVolume > 1.0) _soundVolume = 0.0;
    });
    
    // Update game sound volume
    widget.game.soundManager.setMusicVolume(_soundVolume);
  }

  void _exitGame() {
    // Pause game and show exit confirmation
    widget.game.pauseEngine();
    _closeMenu();
    Navigator.pushNamed(context, '/');
    GameSoundManager().stopBackgroundMusic();
  }

  void _closeMenu() {
    setState(() {
      _showHamburgerMenu = false;
    });
    _slideController.reverse().then((_) {
      widget.onClose();
    });
  }

  Widget _buildCloseButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: _closeMenu,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: fineRed,
            border: Border.all(color: charcoalBlack, width: 2),
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: charcoalBlack.withOpacity(0.5),
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Text(
            'CLOSE',
            style: TextStyle(
              fontFamily: 'VT323',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: championWhite,
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for pixel-art background pattern
class PixelBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = charcoalBlack.withOpacity(0.1);
    final gridSize = 20.0;
    
    for (double x = 0; x < size.width; x += gridSize) {
      for (double y = 0; y < size.height; y += gridSize) {
        if ((x / gridSize + y / gridSize) % 2 == 0) {
          canvas.drawRect(
            Rect.fromLTWH(x, y, gridSize, gridSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Data model for active tasks
class ActiveTask {
  final String id;
  final String title;
  final String description;
  final String location;
  final String building;
  bool isCompleted;
  final Popup? popup;

  ActiveTask({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.building,
    required this.isCompleted,
    this.popup,
  });
}

/// Modal dialog for showing task details
class TaskDetailsModal extends StatelessWidget {
  final ActiveTask task;
  final VoidCallback onClose;
  final Function(bool success) onMarkCompleted;

  const TaskDetailsModal({
    Key? key,
    required this.task,
    required this.onClose,
    required this.onMarkCompleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 320,
        decoration: BoxDecoration(
          color: championWhite,
          border: Border.all(color: charcoalBlack, width: 3),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: charcoalBlack.withOpacity(0.5),
              offset: const Offset(3, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ashMaroon,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
              ),
              child: Text(
                'TASK DETAILS',
                style: TextStyle(
                  fontFamily: 'VT323',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: championWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    task.title,
                    style: TextStyle(
                      fontFamily: 'VT323',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: charcoalBlack,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: fineRed,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        task.location,
                        style: TextStyle(
                          fontFamily: 'PixeloidSans',
                          fontSize: 12,
                          color: fineRed,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Description
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: lavanderGray.withOpacity(0.3),
                      border: Border.all(color: lavanderGray, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.description,
                      style: TextStyle(
                        fontFamily: 'PixeloidSans',
                        fontSize: 12,
                        color: charcoalBlack,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onMarkCompleted(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: fineRed,
                              border: Border.all(color: charcoalBlack, width: 2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'FAILED',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: championWhite,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 8),
                      
                      Expanded(
                        child: GestureDetector(
                          onTap: () => onMarkCompleted(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: pixelGold,
                              border: Border.all(color: charcoalBlack, width: 2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'COMPLETED',
                              style: TextStyle(
                                fontFamily: 'VT323',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: charcoalBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Close button
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: onClose,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: lavanderGray,
                          border: Border.all(color: charcoalBlack, width: 2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'CLOSE',
                          style: TextStyle(
                            fontFamily: 'VT323',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: charcoalBlack,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
