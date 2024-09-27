import 'package:flutter/material.dart';
import 'package:flutter_daily_planer/screen/wellcome.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light; 

  void _toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          color: Colors.blue,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        appBarTheme: const AppBarTheme(
          color: Colors.black,
        ),
      ),
      themeMode: _themeMode, 
      home: WellcomePage(onThemeToggle: _toggleTheme), 
    );
  }
}
