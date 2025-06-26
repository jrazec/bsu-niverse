import 'package:flutter/material.dart';

class GameTitle extends StatelessWidget {
  final double? fontSizeInput;
  final Color? colorInput;
  final FontWeight? fontWeightInput;

  const GameTitle({super.key,this.fontSizeInput=10.0,this.colorInput=Colors.black,this.fontWeightInput=FontWeight.w100});

  @override
  Widget build(BuildContext context) {
    return Text(
                    "BSU-niverse!",
                    style: TextStyle(
                      fontSize: fontSizeInput,
                      color: colorInput, // Champion White
                      fontFamily: 'OrangeKid',
                      fontWeight: fontWeightInput,
                      shadows: [
                        Shadow(
                          blurRadius: 6.0,
                          color: Color.fromRGBO(0, 0, 0, 0.6), 
                          offset: Offset(2.5, 2.5),
                        ),
                      ],
                    ),
                  );

  }
}