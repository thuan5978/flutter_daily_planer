import 'package:flutter/material.dart';
import 'package:flutter_daily_planer/screen/main_screen.dart'; 

class SignIn extends StatefulWidget {
  final Function(bool) onThemeToggle;

  const SignIn({super.key, required this.onThemeToggle});

  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  final TextEditingController emailControl = TextEditingController();
  final TextEditingController passControl = TextEditingController();

  @override
  void dispose() {
    emailControl.dispose();
    passControl.dispose();
    super.dispose();
  }

  void _signIn() {
    final email = emailControl.text.trim();
    final password = passControl.text.trim();

    
    if (email.isEmpty || password.isEmpty) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập email và mật khẩu")),
      );
      return;
    }

   

    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(onThemeToggle: widget.onThemeToggle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: _body(context),
      ),
    );
  }

  Widget _body(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _input(context, 'Email', emailControl, false),
          const SizedBox(height: 20),
          _input(context, 'Password', passControl, true),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: _signIn, 
            child: ButtonCustom(text: "Sign In", currentContext: context),
          ),
        ],
      ),
    );
  }

  Widget _input(BuildContext context, String title, TextEditingController input, bool isPassword) {
    return TextField(
      controller: input,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: title,
        border: const OutlineInputBorder(),
      ),
    );
  }
}

class ButtonCustom extends StatelessWidget {
  final String text;
  final BuildContext currentContext;

  const ButtonCustom({required this.text, required this.currentContext, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
