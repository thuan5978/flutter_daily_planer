import 'package:flutter_daily_planer/api/local_api.dart'; 
import 'package:flutter_daily_planer/model/task.dart';
import 'package:flutter_daily_planer/model/const.dart';
import 'package:flutter_daily_planer/screen/add_task.dart';
import 'package:flutter_daily_planer/screen/task_detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPage();
}

class _TaskListPage extends State<TaskListPage> {
  LocalApi localApi = LocalApi(); 

  Future<List<Task>> getList() async {
    try {
      List<Task> lst = await localApi.getTasks(); 
      return lst;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
      floatingActionButton: _addButton(context),
    );
  }

  Widget _addButton(BuildContext context) {
    return Container(
      width: getMainWidth(context),
      height: 100,
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Positioned(
            right: 10,
            bottom: 10,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTask()));
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: mainColor,
                ),
                child: const Icon(Icons.add, size: 30, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Container(
      width: getMainWidth(context),
      height: getMainHeight(context),
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: const ScrollPhysics(),
        child: FutureBuilder<List<Task>>(
          future: getList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No tasks available!"));
            } else {
              return Container(
                width: getMainWidth(context),
                height: getMainHeight(context),
                padding: const EdgeInsets.only(bottom: 20),
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.vertical,
                  physics: const ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return TaskItem(
                      task: snapshot.data![index],
                      onUpdate: () => _updateTask(context, snapshot.data![index]),
                      onDelete: () => _deleteTask(context, snapshot.data![index]),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }

  void _updateTask(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTask(task: task)), 
    );
  }

  void _deleteTask(BuildContext context, Task task) async {
    bool success = await localApi.deleteTask(task.title!);
    if (success) {
      setState(() {}); 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleted: ${task.title}")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error deleting task")));
    }
  }
}
class TaskItem extends StatelessWidget {
  const TaskItem({
    super.key,
    required this.task,
    required this.onUpdate,
    required this.onDelete,
  });

  final Task task;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TaskDetailScreen(task: task),
          ),
        );
      },
      child: Container(
        width: getMainWidth(context),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title ?? 'No Title', 
                  style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
                Text(
                  task.content ?? 'No Content', // Handle null content
                  style: const TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.normal),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 20),
                Text(
                  _formatDate(task.dateCreated), 
                  style: const TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 5),
                Text(
                  task.host ?? 'No Host', 
                  style: const TextStyle(fontSize: 15, color: Colors.blue, fontWeight: FontWeight.normal),
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onUpdate,
                  icon: const Icon(Icons.edit, color: Colors.black, size: 20),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'No Date'; 

    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate); 
    } catch (e) {
      return 'Invalid Date'; 
    }
  }
}






