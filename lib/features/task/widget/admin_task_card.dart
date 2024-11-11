import 'package:flutter/material.dart';
import 'package:geolocation/features/task/model/task.dart';
import 'package:get/get.dart';

class AdminTaskCard extends StatelessWidget {
  final Task task;

  AdminTaskCard({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  '${task.title??''}',
                  style: Get.textTheme.bodyLarge,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(task.status ?? 'Unknown'),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task.status ?? 'Unknown',
                  style: Get.textTheme.bodyMedium?.copyWith(
                     color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          // Task Details (Body)
          Text(
            task.taskDetails ?? 'No details available.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),

          SizedBox(height: 12),
          Divider(color: Color(0xFFF1F1F1)),

          // Due Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Due Date',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                task.dueDate ?? 'No Due Date',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Dynamic color based on task status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'To Do':
        return Colors.blueAccent;
      case 'In Progress':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
