import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final Function(bool) onThemeToggle;

  const SettingsPage({super.key, required this.onThemeToggle});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Chế độ giao diện',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Chọn chế độ tối để giúp mắt dễ chịu hơn trong môi trường tối.',
              style: TextStyle(fontSize: 14),
            ),
            SwitchListTile(
              title: const Text('Chế độ tối'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                  widget.onThemeToggle(_isDarkMode);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
