import 'package:flutter/material.dart';
import 'package:flutter_daily_planer/model/task.dart';
import 'package:flutter_daily_planer/screen/add_task.dart';

import 'package:intl/intl.dart'; 

class TaskDetailScreen extends StatelessWidget {
  final Task task;
 

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title ?? 'Task Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title ?? 'No Title',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Text(
              task.content ?? 'No Content',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),

            Text(
              'Date Created: ${_formatDate(task.dateCreated)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            Text(
              'Start Time: ${task.startTime ?? 'No Start Time'}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'End Time: ${task.endTime ?? 'No End Time'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTask(task: task),
                  ),
                );
              },
              child: const Text('Edit Task'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'No Date';
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate); 
  }
}
