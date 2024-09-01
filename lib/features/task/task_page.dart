import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/task/widget/task_card.dart';

class TaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.LIGHT_BACKGROUND,
      appBar: AppBar(
      backgroundColor: Colors.white,
        title: Text('Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TaskCard(
              title: 'Design Landing Page',
              description: 'Create a landing page for the new product.',
              status: 'In Progress',
              dueDate: 'Sep 10, 2024',
            ),
            TaskCard(
              title: 'Team Meeting',
              description: 'Weekly sync with the product team.',
              status: 'Completed',
              dueDate: 'Sep 01, 2024',
            ),
            TaskCard(
              title: 'Review PRs',
              description: 'Review the latest pull requests from the team.',
              status: 'Pending',
              dueDate: 'Sep 12, 2024',
            ),
            TaskCard(
              title: 'Update Documentation',
              description: 'Update the API documentation with new endpoints.',
              status: 'In Progress',
              dueDate: 'Sep 15, 2024',
            ),
          ],
        ),
      ),
    );
  }
}