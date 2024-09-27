import 'dart:convert';
import 'dart:io';
import 'package:flutter_daily_planer/model/task.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart'; 
import 'package:logger/logger.dart';

class LocalApi {
  final Logger logger = Logger();

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory(); 
    return path.join(directory.path, 'tasks.json'); 
  }

  Future<List<Task>> getTasks() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      if (!await file.exists()) {
        return []; 
      }

      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((taskJson) => Task.fromJson(taskJson)).toList(); 
    } catch (e) {
      logger.e('Error reading tasks: $e');  
      return [];
    }
  }

  Future<bool> addTask(Task task) async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      List<Task> tasks = await getTasks();
      tasks.add(task);
      final jsonData = tasks.map((task) => task.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));

      logger.i('Task added successfully: ${task.title}');  
      return true;
    } catch (e) {
      logger.e('Error adding task: $e');  
      return false;
    }
  }

  Future<bool> updateTask(Task task) async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      List<Task> tasks = await getTasks();
      final index = tasks.indexWhere((t) => t.title == task.title);
      if (index != -1) {
        tasks[index] = task; 
        final jsonData = tasks.map((task) => task.toJson()).toList();
        await file.writeAsString(jsonEncode(jsonData));

        logger.i('Task updated successfully: ${task.title}');  
        return true;
      }
      return false; 
    } catch (e) {
      logger.e('Error updating task: $e');  
      return false;
    }
  }

  Future<bool> deleteTask(String title) async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      List<Task> tasks = await getTasks();
      final int initialLength = tasks.length; 

      tasks.removeWhere((task) => task.title == title);
      final jsonData = tasks.map((task) => task.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonData));

      final deleted = tasks.length < initialLength;
      if (deleted) {
        logger.i('Task deleted successfully: $title');  
      } else {
        logger.w('Task not found for deletion: $title'); 
      }
      return deleted; 
    } catch (e) {
      logger.e('Error deleting task: $e');  
      return false;
    }
  }
}
