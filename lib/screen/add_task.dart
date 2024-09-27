import 'package:flutter/material.dart';
import 'package:flutter_daily_planer/api/local_api.dart';
import 'package:flutter_daily_planer/model/task.dart';

class AddTask extends StatefulWidget {
  final Task? task;

  const AddTask({super.key, this.task});

  @override
  AddTaskState createState() => AddTaskState();
}

class AddTaskState extends State<AddTask> {
  final LocalApi localApi = LocalApi();
  final TextEditingController _taskContentController = TextEditingController();
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  
  DateTime? _selectedDate; 
  DateTime? _endDate; 
  TimeOfDay? _startTime; 
  TimeOfDay? _endTime; 

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async { 
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  Future<void> addNewTask() async {
    if (_taskContentController.text.isEmpty || _locationController.text.isEmpty) {
      _showSnackBar('Please fill in all required fields.');
      return;
    }

    Task newTask = Task(
      title: _taskContentController.text,
      dateCreated: DateTime.now().toIso8601String(),
      location: _locationController.text,
      content: _taskContentController.text,
      startTime: _startTime?.format(context), 
      endTime: _endTime?.format(context),     
      endDate: _endDate?.toIso8601String(), 
      host: _hostController.text,
      note: _noteController.text,
    );

    bool success = await localApi.addTask(newTask);
    if (success) {
      _showSnackBar('Task added successfully!');
      _clearInputs(); 
      Navigator.pop(context); 
    } else {
      _showSnackBar('Failed to add task.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _clearInputs() {
    _taskContentController.clear();
    _hostController.clear();
    _locationController.clear();
    _noteController.clear();
    setState(() {
      _selectedDate = null;
      _endDate = null; 
      _startTime = null;
      _endTime = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskContentController,
              decoration: const InputDecoration(labelText: 'Task Content', hintText: 'Enter task details'),
            ),
            TextField(
              controller: _hostController,
              decoration: const InputDecoration(labelText: 'Host'),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Start Date'),
                ),
                Text(_selectedDate?.toLocal().toString().split(' ')[0] ?? 'No start date selected'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _selectEndDate(context), 
                  child: const Text('Select End Date'), 
                ),
                Text(_endDate?.toLocal().toString().split(' ')[0] ?? 'No end date selected'), 
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _selectStartTime(context),
                  child: const Text('Select Start Time'),
                ),
                Text(_startTime?.format(context) ?? 'No start time selected'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => _selectEndTime(context),
                  child: const Text('Select End Time'),
                ),
                Text(_endTime?.format(context) ?? 'No end time selected'), 
              ],
            ),
            ElevatedButton(
              onPressed: addNewTask,
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
