import 'package:flutter/material.dart';
import 'package:flutter_daily_planer/screen/sign_in.dart';

class WellcomePage extends StatelessWidget {
  final Function(bool) onThemeToggle;

  const WellcomePage({super.key, required this.onThemeToggle});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
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
          SizedBox(
            width: 105,
            height: 105,
            child: Image.asset("assets/icon/logo.png", fit: BoxFit.cover),
          ),
          const SizedBox(height: 200),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignIn(onThemeToggle: onThemeToggle), 
                ),
              );
            },
            child: Container(
              width: width / 2,
              height: 70,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  "Sign In",  
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
