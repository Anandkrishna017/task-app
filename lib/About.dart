
import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Task Manager App",
            ),
            SizedBox(height: 16),
            Text(
              "A simple task management application to help you stay organized.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            
          ],
        ),
      ),
    );
  }
}