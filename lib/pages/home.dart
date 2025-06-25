import 'package:flutter/material.dart';
import '../widgets/boucing_arrow.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

    // Similar to React's component. This
  final heroSection = Container(
          color: Color.fromRGBO(211,47,47, 1),
          child: Column(
            spacing: BorderSide.strokeAlignCenter,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      
                      children: [
                          // LOGO 
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 100.0, 0, 0),
                            child: Image.asset(
                              'assets/images/bsuniverse_logo.png',
                              height: 100,
                              width: 100,
                              ),
                          ),

                          // GAME TITLE
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20.0),
                            child: Text( // To Change to Container/Image
                              "BSU-niverse!", 
                              style: TextStyle(
                                fontSize: 60,
                                color: Colors.white,
                                fontFamily: 'OrangeKid',
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),

                          // GAME DESCRIPTION
                          Text(
                            "Embark on an epic academic adventure through your university journey. Explore, learn and conquer challenges in this pokemon-like university themed game!",
                            style: TextStyle(
                              fontSize: 20, 
                              color: Colors.white,
                              fontFamily: 'OrangeKid',
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 100.0,0,0),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateColor.resolveWith((states) {
                                  return Color.fromRGBO(255, 255, 255, 1);
                                },),
                              ),
                              onPressed: (){}, 
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "Play Now",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontFamily: 'OrangeKid'
                                  ),
                                ),
                              )
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:50.0),
                            child: BouncingArrow(),
                          ),
                      ],
                    ),
                  )
                ],
              ),
              Column(),
              Column()
            ],
        )
  );
  final aboutGameSection = Column();
  final creatorSection = Column();

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
          heroSection,
          aboutGameSection,
          creatorSection
        ]
    );
  }
}