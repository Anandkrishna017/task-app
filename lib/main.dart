

import 'package:flutter/material.dart';
import 'package:taskmanagement/About.dart';
import 'package:taskmanagement/HomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: false,
      ),
      home: const Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentState = 0;
  final List<Widget> pages = const [HomePage(), About()];
  final List<String> titles = const ["Tasks", "About"];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
      ),
      body: pages[currentState],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task),
            label: "Tasks",
          ),
          NavigationDestination(
            icon: Icon(Icons.info),
            label: "About",
          ),
        ],
        onDestinationSelected: (int value) {
          setState(() {
            currentState = value;
          });
        },
        selectedIndex: currentState,
      ),
    );
  }
}