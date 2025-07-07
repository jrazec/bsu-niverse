import 'package:flutter/material.dart';
import 'package:flame/game.dart';


class QuestOverlay extends StatelessWidget {
  final FlameGame game;
  final String question;
  final List<String> options;
  final void Function(int) onOptionSelected;
  

  const QuestOverlay({
    Key? key,
    required this.game,
    required this.question,
    required this.options,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.9;
    final double height = MediaQuery.of(context).size.height * 0.9;
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width,
              maxHeight: height,
            ),
            child: Container(
              width: width,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Color(0xFF6E0E15), width: 6), // maroon
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'QUEST',
                    style: const TextStyle(
                      fontFamily: 'PixeloidSans-Bold',
                      fontSize: 32,
                      color: Color(0xFF6E0E15), // maroon
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    question,
                    style: const TextStyle(
                      fontFamily: 'VT323',
                      fontSize: 24,
                      color: Colors.black,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  // Smaller image placeholder
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      border: Border.all(color: Color(0xFF6E0E15), width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.image, size: 36, color: Colors.black26),
                    ),
                  ),

                  
                  // 2x2 grid for choices
                  LayoutBuilder(
                    builder: (context, constraints) {
                      
                      double gridWidth = constraints.maxWidth;
                      double spacing = 10.0;
                      int rowCount = (options.length / 2).ceil();
                      // Calculate button size to always fit all options
                      double buttonWidth = ((gridWidth - spacing) / 2 - spacing).clamp(80, 180);
                      double buttonHeight = 48.0;
                      // If the total height is too large, shrink the buttons
                      double totalGridHeight = rowCount * buttonHeight + (rowCount - 1) * spacing;
                      double maxGridHeight = constraints.maxHeight;
                      if (totalGridHeight > maxGridHeight) {
                        buttonHeight = ((maxGridHeight - (rowCount - 1) * spacing) / rowCount).clamp(32, 48);
                      }
                      return GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,
                        childAspectRatio: buttonWidth / buttonHeight,
                        physics: const NeverScrollableScrollPhysics(),
                        children: List.generate(options.length, (index) {
                          return SizedBox(
                            width: buttonWidth,
                            height: buttonHeight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6E0E15), // maroon
                                foregroundColor: Colors.white,
                                minimumSize: Size(buttonWidth, buttonHeight),
                                maximumSize: Size(buttonWidth, buttonHeight),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.black, width: 2),
                                ),
                                textStyle: const TextStyle(
                                  fontFamily: 'VT323',
                                  fontSize: 22,
                                  letterSpacing: 1.5,
                                ),
                                elevation: 0,
                              ),
                              onPressed: () => onOptionSelected(index),
                              child: Text(options[index]),
                            ),
                          );
                        }),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
