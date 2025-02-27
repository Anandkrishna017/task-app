
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Task {
  String id;
  String name;

  Task({required this.id, required this.name});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(id: json['_id'], name: json['name']);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskController = TextEditingController();
  List<Task> tasks = [];
  String baseUrl = "http://<IP-Address>/api";
  bool isLoading = false;

  // HomePage(){
  //   fetchTasks();
  // }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  void fetchTasks() async {
    try {
      setState(() => isLoading = true);
      String url = "$baseUrl/get";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> taskJson = json.decode(response.body);
        setState(() {
          tasks = taskJson.map((task) => Task.fromJson(task)).toList();
        });

        debugPrint("\nCurrent Tasks:");
        for (var task in tasks) {
          debugPrint("ID: ${task.id}, Name: ${task.name}");
        }
      }
    } catch (e) {
      debugPrint("Error fetching tasks: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void addTask(String name) async {
    try {
      String url = "$baseUrl/add";
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"name": name}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        fetchTasks();
      }
    } catch (e) {
      debugPrint("Error adding task: $e");
    }
  }

  void updateTask(Task task, String newName) async {
    try {
      String id = task.id;
      String url = "$baseUrl/update?id=$id";
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'name': newName}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        fetchTasks();
      }
    } catch (e) {
      debugPrint("Error updating task: $e");
    }
  }

  void deleteTask(String id) async {
    try {
      String url = "$baseUrl/delete?id=$id";
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          tasks.removeWhere((task) => task.id == id);
        });
      } else {
        debugPrint("Failed to delete task: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error deleting task: $e");
    }
  }

  void showEditDialog(Task task) {
    TextEditingController editController =
        TextEditingController(text: task.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(hintText: 'Edit task name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (editController.text.isNotEmpty) {
                  updateTask(task, editController.text);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: TextField(
            controller: _taskController,
            onSubmitted: (value) {
              if (_taskController.text.isNotEmpty) {
                addTask(_taskController.text);
                _taskController.clear();
              }
            },
            decoration: InputDecoration(
              hintText: "Enter Task",
              suffixIcon: IconButton(
                onPressed: () {
                  if (_taskController.text.isNotEmpty) {
                    addTask(_taskController.text);
                    _taskController.clear();
                  }
                },
                icon: const Icon(Icons.add),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : tasks.isEmpty
                  ? const Center(child: Text("No tasks added"))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ListTile(
                              title: Text(tasks[index].name,style: TextStyle(color: Colors.white),),
                              onTap: () => showEditDialog(tasks[index]),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => deleteTask(tasks[index].id),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
