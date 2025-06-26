import 'package:flutter/material.dart';

class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(250, 249, 246, 1.0), // championWhite
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Modal Header
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(110, 14, 21, 1.0), // funRed
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Image.asset('assets/images/bsuniverse_logo.png', height: 60, width: 500,),
                  const SizedBox(height: 10),
                  const Text(
                    'BSU-niverse!',
                    style: TextStyle(
                      fontFamily: 'OrangeKid',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'WELCOME BACK!',
                    style: TextStyle(
                      fontFamily: 'VT323',
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Login/Register Toggle
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(197, 197, 214, 1.0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _buildToggleButton('LOGIN', isLogin, () {
                    setState(() => isLogin = true);
                  }),
                  _buildToggleButton('REGISTER', !isLogin, () {
                    setState(() => isLogin = false);
                  }),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Form Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildLabel('USERNAME'),
                  _buildInput('Enter username'),
                  const SizedBox(height: 12),
                  _buildLabel('PASSWORD'),
                  _buildInput('Enter password', obscureText: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Start Game Button
            GestureDetector(
              onTap: () { 
                Navigator.pop(context);
                Navigator.pushNamed(context,'/loading');
                },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(110, 14, 21, 1.0),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'START GAME',
                      style: TextStyle(
                        fontFamily: 'PressStart2P',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? const Color.fromRGBO(250, 249, 246, 1.0) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PixelOperator',
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'FiraCode',
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(27, 27, 27, 1.0),
        ),
      ),
    );
  }

  Widget _buildInput(String hint, {bool obscureText = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(27, 27, 27, 1.0)),
        borderRadius: BorderRadius.circular(6),
        color: const Color.fromRGBO(250, 249, 246, 1.0),
      ),
      child: TextField(
        obscureText: obscureText,
        style: const TextStyle(fontFamily: 'PixeloidSans'),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(fontFamily: 'PixeloidSans'),
        ),
      ),
    );
  }
}
