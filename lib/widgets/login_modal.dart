import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
class LoginModal extends StatefulWidget {
  const LoginModal({super.key});

  @override
  State<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  bool isLogin = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  String? _errorMessage;

  final AuthService authService = AuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      if (isLogin) {
        await authService.signIn(
          email: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );
      } else {
        await authService.signUp(
          email: _usernameController.text.trim(),
          password: _passwordController.text.trim(),
        );
      }

      Navigator.pop(context);
      Navigator.pushNamed(context, '/loading');
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 400,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(250, 249, 246, 1.0),
          border: Border.all(color: Colors.black, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              const SizedBox(height: 10),
              _buildToggle(),
              const SizedBox(height: 16),
              _buildFormFields(),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontFamily: 'VT323'),
                  ),
                ),
              const SizedBox(height: 16),
              _buildSubmitButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(110, 14, 21, 1.0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Image.asset('assets/images/bsuniverse_logo.png', height: 60),
          const SizedBox(height: 10),
          const Text('BSU-niverse!',
              style: TextStyle(
                fontFamily: 'OrangeKid',
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          const SizedBox(height: 6),
          const Text('WELCOME BACK!',
              style: TextStyle(
                fontFamily: 'VT323',
                fontSize: 16,
                color: Colors.white70,
              )),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
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
    );
  }

  Widget _buildFormFields() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildLabel('EMAIL'),
          _buildInputField(
            controller: _usernameController,
            hint: 'Enter email',
            validator: (val) {
              if (val == null || val.isEmpty) return 'Email is required';
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) return 'Enter valid email';
              return null;
            },
          ),
          const SizedBox(height: 12),
          _buildLabel('PASSWORD'),
          _buildInputField(
            controller: _passwordController,
            hint: 'Enter password',
            obscureText: true,
            validator: (val) {
              if (val == null || val.isEmpty) return 'Password is required';
              if (val.length < 6) return 'Minimum 6 characters';
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _loading ? null : _handleAuth,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(110, 14, 21, 1.0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_loading)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            else
              const Icon(Icons.play_arrow, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              isLogin ? 'LOGIN' : 'REGISTER',
              style: const TextStyle(
                fontFamily: 'PressStart2P',
                fontSize: 12,
                color: Colors.white,
              ),
            ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(27, 27, 27, 1.0)),
        borderRadius: BorderRadius.circular(6),
        color: const Color.fromRGBO(250, 249, 246, 1.0),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontFamily: 'PixeloidSans'),
        validator: validator,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(fontFamily: 'PixeloidSans'),
        ),
      ),
    );
  }
}
