import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_daily_planer/model/task.dart';
import 'package:flutter_daily_planer/api/local_api.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  CalendarViewState createState() => CalendarViewState();
}

class CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Task>> _tasksByDate = {};
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _loadTasks(); 
  }

  Future<void> _loadTasks() async {
    try {
      List<Task> tasks = await LocalApi().getTasks();

      for (var task in tasks) {
        DateTime taskDate = DateTime.parse(task.dateCreated!);
        DateTime normalizedTaskDate = DateTime(taskDate.year, taskDate.month, taskDate.day);

        _tasksByDate.putIfAbsent(normalizedTaskDate, () => []).add(task);
      }
    } catch (e) {
      logger.e('Error loading tasks: $e'); 
    } finally {
      setState(() {}); 
    }
  }

  List<Task> _getTasksForDay(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    var tasks = _tasksByDate[normalizedDay] ?? [];
    logger.i('Tasks for ${day.toLocal()}: $tasks');
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lịch Công việc')),
      body: Column(
        children: [
          TableCalendar<Task>(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: _getTasksForDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                logger.i('Selected Day: ${_selectedDay?.toLocal()}');
              });
            },
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              selectedDecoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildTaskList()),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    List<Task> tasks = _getTasksForDay(_selectedDay ?? _focusedDay);
    logger.i('Displaying tasks: $tasks');
    if (tasks.isEmpty) {
      return const Center(child: Text('Không có công việc nào cho ngày này.'));
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(tasks[index].title ?? 'No Title'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Content: ${tasks[index].content ?? 'No Content'}'),
              Text('Start Time: ${tasks[index].startTime ?? 'No Start Time'}'),
              Text('End Time: ${tasks[index].endTime ?? 'No End Time'}'),
              Text('End Date: ${_formatEndDate(tasks[index].endDate)}'), 
              Text('Location: ${tasks[index].location ?? 'No Location'}'),
              Text('Date Created: ${_formatDate(tasks[index].dateCreated)}'), 
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'No Date';
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate); 
  }

  String _formatEndDate(String? endDate) {
    if (endDate == null || endDate.isEmpty) return 'No End Date';
    DateTime parsedEndDate = DateTime.parse(endDate);
    return DateFormat('dd/MM/yyyy').format(parsedEndDate);
  }
}
