import 'package:flutter/material.dart';
import '../widgets/boucing_arrow.dart';
import '../widgets/game_title.dart';
import '../widgets/card_content.dart';
import '../widgets/dev_card.dart';
import '../widgets/game_logo_bouncing.dart';
import '../widgets/login_modal.dart';

final Color championWhite = Color.fromRGBO(250, 249, 246, 1.0);
final Color pixelGold = Color.fromRGBO(255, 215, 0, 1.0);
final Color lavanderGray = Color.fromRGBO(197, 197, 214, 1.0);
final Color blazingOrange = Color.fromRGBO(255, 106, 0, 1.0);
final Color charcoalBlack = Color.fromRGBO(27, 27, 27, 1.0);
final Color ashMaroon = Color.fromRGBO(110, 14, 21, 1.0);
final Color fineRed = Color.fromRGBO(201, 33, 30, 1.0);

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // CONTROLLER FOR SCROLLING DOWN
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: [
        // ----- HERO SECTION -----
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [ashMaroon, fineRed, championWhite],
              stops: [0.0, 0.85, 1],
            ),
          ),
          child: Column(
            spacing: BorderSide.strokeAlignCenter,
            children: [
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Column(
                      children: [
                        // LOGO
                        Container(
                          margin: const EdgeInsets.only(top: 45.0),

                          padding: const EdgeInsets.all(12.0),
                          child: Text(""),
                        ),
                        SpartanLogo(),
                        // GAME TITLE
                        GameTitle(
                          fontSizeInput: 60.0,
                          colorInput: championWhite,
                          fontWeightInput: FontWeight.bold,
                        ),
                        // GAME DESCRIPTION
                        Text(
                          "Embark on an epic academic adventure through your university journey. Explore, learn and conquer challenges in this pokemon-like university themed game!",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(255, 255, 255, 1),
                            fontFamily: 'VT323',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 70.0, 0, 0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ashMaroon,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                              elevation: 6,
                              shadowColor: charcoalBlack,
                            ),
                            onPressed: () {
                              // Navigator.pushNamed(context, '/game');
                              showDialog(
                                context: context,
                                builder: (context) => const LoginModal(),
                              );
                            },
                            child: Text(
                              "PLAY NOW",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: championWhite,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'PixeloidSans-Bold',
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50.0),
                            child: BouncingArrow(),
                          ),
                          onTap: () {
                            _scrollController.animateTo(
                              _scrollController.offset + 750,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ----- ABOUT BSUNIVERSE SECTION -----
        Container(
          color: championWhite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // TITLE
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 5,
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 40,
                      color: ashMaroon,
                    ),
                  ),
                  Container(
                    child: Text(
                      "About BSU-niverse",
                      style: TextStyle(
                        fontFamily: 'OrangeKid',
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: ashMaroon,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: PixelCard(
                  title: "Game Features",
                  bullets: [
                    "Interactive campus exploration",
                    "Complete campus-related quests",
                    "Dress up like what you wear in the campus",
                    "Collect characters and pets to show-off",
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 50),
                child: PixelCard(
                  title: "How to Play",
                  bullets: [
                    "1. Log-in or Create your account",
                    "2. Complete the tutorial",
                    "3. Explore the map and complete quests",
                    "4. Roll through the store for sum Gatcha ✨",
                  ],
                ),
              ),
            ],
          ),
        ),

        // ----- THE CREATORS SECTION -----
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [championWhite, fineRed, ashMaroon],
              stops: [0.0, 0.1, 1],
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 70),
              // Title
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 380,
                    height: 50,
                    decoration: BoxDecoration(
                      color: ashMaroon,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          blurRadius: 10,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 300,
                    height: 70,
                    decoration: BoxDecoration(
                      color: ashMaroon,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'The Creators',
                      style: TextStyle(
                        fontFamily: 'OrangeKid', // Your pixel-s:tyle font
                        fontSize: 40,
                        color: championWhite,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              DevCard(
                name: "razec",
                role: "Main Dancer & Visual",
                imagePath: "assets/images/razec.png",
                links: [
                  "GitHub                                                             11",
                  "LinkedIn                                                         29",
                  "Website                                                      2003",
                ],
                description:
                    "Master of pixelated UIs. Codes with style and charm!",
                colorInput: pixelGold,
              ),
              DevCard(
                name: "badet",
                role: "The Game Mastermind",
                imagePath: "assets/images/berna.png",
                links: [
                  "GitHub                                                             11",
                  "LinkedIn                                                         29",
                  "Website                                                      2003",
                ],
                description:
                    "Lurks in the shadows of the cloud, silently scaling servers.",
                colorInput: pixelGold,
              ),
              DevCard(
                name: "yuhjie",
                role: "UI/UX Wizard",
                imagePath: "assets/images/yajie.png",
                links: [
                  "GitHub                                                             11",
                  "LinkedIn                                                         29",
                  "Website                                                      2003",
                ],
                description:
                    "Lurks in the shadows of the cloud, silently scaling servers.",
                colorInput: pixelGold,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
