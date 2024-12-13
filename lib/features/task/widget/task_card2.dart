import 'package:flutter/material.dart';
import 'package:geolocation/features/task/model/task.dart';
class TaskCard2 extends StatelessWidget {
  final Task task;

  const TaskCard2({
    required this.task,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  task.title ?? 'Untitled Task',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(task.status),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.status ?? 'Unknown',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Task Details
            Text(
              task.taskDetails ?? 'No details available.',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),

            // Footer Row
           Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Row(
      children: [
        Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]), // Changed the icon to calendar
        const SizedBox(width: 4),
        Text(
          'Due Date: ${task.dueDate ?? 'No Due Date'}', // Displaying dueDate instead of position
          style: const TextStyle(fontSize: 12),
        ),
      ],
    ),
    // Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    //   decoration: BoxDecoration(
    //     color: task.isLock == true ? Colors.redAccent : Colors.green,
    //     borderRadius: BorderRadius.circular(8),
    //   ),
    //   child: Text(
    //     task.isLock == true ? 'Locked' : 'Unlocked',
    //     style: const TextStyle(
    //       color: Colors.white,
    //       fontSize: 12,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    // ),
  ],
),

          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'to do':
        return Colors.grey;
      case 'in progress':
        return Colors.blueAccent;
      case 'completed':
        return Colors.green;
      case 'needs revision':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.blueGrey;
    }
  }
}