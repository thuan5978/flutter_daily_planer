import 'package:flutter/material.dart';
import 'package:flutter_daily_planer/screen/task_list.dart';
import 'package:flutter_daily_planer/screen/calendar.dart';
import 'package:flutter_daily_planer/screen/setting.dart';

class MainScreen extends StatefulWidget {
  final Function(bool) onThemeToggle; 

  const MainScreen({super.key, required this.onThemeToggle});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const TaskListPage(),
      const CalendarView(),
      SettingsPage(onThemeToggle: widget.onThemeToggle), 
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Công việc'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Lịch'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
