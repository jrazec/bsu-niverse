import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/leaderboards.dart';
import 'pages/manual.dart';
import 'pages/settings.dart';
void main() {
  runApp(const MyApp());
}

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 50, 1, 1)),
      ),
      home: const MyHomePage(title: 'Home Page'),
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
    Home(),
    Manual(),
    Leaderboards(),
    Settings()
  ];
  int _selectedNav = 0;

  void _changeNav (currentNav) {
    setState(() {
      _selectedNav = currentNav;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Reruns everytime

    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(131, 12, 12, 1),
        leading: Image.asset(
          'assets/images/bsuniverse_logo.png'
        ),
        
      ),
      body: _sections[_selectedNav],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(131, 12, 12, 1),
        currentIndex: _selectedNav, 
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color.fromARGB(223, 255, 255, 255),
        unselectedItemColor: Color.fromARGB(255, 236, 236, 236),
        showUnselectedLabels: false,
        onTap: _changeNav,
        items: [
          BottomNavigationBarItem(
            icon: Icon(size:30,Icons.home_outlined),
            label: 'Home',
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.home, size: 40),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(size:30,Icons.book_outlined),
            label: 'Manual',
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.book, size: 40),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(size:30,Icons.leaderboard_outlined),
            label: 'Leaderboards',
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Align(
                alignment: Alignment.center,
                child: Icon(Icons.leaderboard, size: 40),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(size:30,Icons.settings_outlined),
            label: 'Settings',
            activeIcon: Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Icon(Icons.settings, size: 40),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
