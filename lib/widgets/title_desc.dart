import 'package:flutter/material.dart';

class TitleDesc extends StatelessWidget {
  final double fontSizeInput;
  final Color colorInput;
  final FontWeight fontWeightInput;
  final String description;
  final String subTitle;
  final Image image;

  const TitleDesc({
    super.key,
    this.fontSizeInput = 10.0,
    this.colorInput = Colors.black,
    this.fontWeightInput = FontWeight.w100,
    required this.description,
    required this.subTitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorInput,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.white,
                  offset: Offset(0, 0),
                  blurRadius: 0,
                  spreadRadius: 2.5,
                ),
                BoxShadow(
                  color: colorInput,
                  offset: Offset(0, 0),
                  blurRadius: 2,
                  spreadRadius: 1.5,
                ),
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0),
                  offset: Offset(0, 0),
                  blurRadius: 0,
                  spreadRadius: 0.5,
                ),
              ],
            ),
            width: 330,
            child: Row(
              children: [
                Transform.translate(
                  offset: Offset(-25, 0),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: colorInput,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(0, 0),
                          blurRadius: 0,
                          spreadRadius: 2.5,
                        ),
                        BoxShadow(
                          color: colorInput,
                          offset: Offset(0, 0),
                          blurRadius: 2,
                          spreadRadius: 1.5,
                        ),
                        BoxShadow(
                          color: Color.fromARGB(255, 0, 0, 0),
                          offset: Offset(0, 0),
                          blurRadius: 0,
                          spreadRadius: 0.3,
                        ),
                      ],
                    ),
                    child: image,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 5.0,
                      top: 5.0,
                      bottom: 5.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subTitle,
                          style: TextStyle(
                            fontFamily: 'VT323',
                            fontSize: fontSizeInput,
                            height: 1,
                            color: Colors.white,
                          ),
                          softWrap: true, // allow wrapping
                          overflow: TextOverflow.visible, // allow full text
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 330,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: colorInput,
                  offset: Offset(0, 0),
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: colorInput,
                  offset: Offset(0, 0),
                  blurRadius: 0,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              description,
              style: TextStyle(
                fontFamily: 'PixeloidSans',
                fontSize: fontSizeInput - 8,
                color: colorInput,
              ),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
