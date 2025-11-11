import 'package:bsuniverse/facilities/screens/facilities_screen.dart';
import 'package:bsuniverse/pages/home.dart';
import 'package:bsuniverse/pages/leaderboards.dart';
import 'package:bsuniverse/pages/manual.dart';
import 'package:bsuniverse/pages/settings.dart';
import 'package:bsuniverse/screens/game_screen.dart';
import 'package:bsuniverse/widgets/game_title.dart';
import 'package:bsuniverse/widgets/loading_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final Color championWhite = const Color.fromRGBO(250, 249, 246, 1.0);
final Color pixelGold = const Color.fromRGBO(255, 215, 0, 1.0);
final Color lavanderGray = const Color.fromRGBO(197, 197, 214, 1.0);
final Color blazingOrange = const Color.fromRGBO(255, 106, 0, 1.0);
final Color charcoalBlack = const Color.fromRGBO(27, 27, 27, 1.0);
final Color ashMaroon = const Color.fromRGBO(110, 14, 21, 1.0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  // The Material App is the mothering App. Ig this is where u
  // put the routes as well.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 50, 1, 1),
        ),
      ),
      home: const MyHomePage(title: 'Home Page'),
      routes: {
        '/home': (context) => const Home(),
        '/user-manual': (context) => const Manual(),
        '/leaderboards': (context) => const Leaderboards(),
        '/settings': (context) => const Settings(),
        '/loading': (context) => const SpartanLoadingScreen(),
        '/game': (context) => const GameScreen(),
        '/facilities': (context) => FacilitiesScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// Any identifier (variable, method, or class) that starts with _
// is accessible only within the same Dart file.
class _MyHomePageState extends State<MyHomePage> {
  final List<Widget> _sections = [
    const Home(),
    const Manual(),
    const Leaderboards(),
    FacilitiesScreen(),
    const Settings()
  ];
  int _selectedNav = 0;

  void _changeNav(currentNav) {
    setState(() {
      _selectedNav = currentNav;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Reruns everytime

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(131, 12, 12, 1), // Deep red
        leading: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Image.asset(
            'assets/images/bsuniverse_logo.png',
            height: 32,
            width: 32,
            fit: BoxFit.contain,
          ),
        ),
        title: GameTitle(
            fontSizeInput: 22,
            fontWeightInput: FontWeight.w400,
            colorInput: championWhite),
        centerTitle: false,
        elevation: 4,
        shadowColor: Colors.black54,
      ),
      body: _sections[_selectedNav],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ashMaroon,
        currentIndex: _selectedNav,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: pixelGold,
        unselectedItemColor: championWhite,
        showUnselectedLabels: false,
        selectedLabelStyle: const TextStyle(fontFamily: 'PixeloidSans', fontSize: 13),
        onTap: _changeNav,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(size: 30, Icons.home_outlined),
            label: 'Home',
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Align(
                alignment: Alignment.center,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        blurRadius: 30,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Icon(Icons.home, size: 35),
                ),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(size: 30, Icons.book_outlined),
            label: 'Manual',
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.book, size: 35),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(size: 30, Icons.leaderboard_outlined),
            label: 'Leaderboards',
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.leaderboard, size: 35),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(size: 30, Icons.business_outlined),
            label: 'Facilities',
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.business, size: 35),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(size: 30, Icons.settings_outlined),
            label: 'Settings',
            activeIcon: Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Icon(Icons.settings, size: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
