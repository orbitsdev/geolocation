import 'package:flutter/material.dart';

class StatusRowWidget extends StatelessWidget {
  final String label;
  final String status;

  const StatusRowWidget({
    Key? key,
    required this.label,
    required this.status,
  }) : super(key: key);

  // Helper function to get the status-specific style
  Map<String, dynamic> _getStatusStyle(String status) {
    switch (status) {
      case 'To Do':
        return {
          'color': Colors.orange,
          'backgroundColor': Colors.orange.withOpacity(0.1),
          'icon': Icons.schedule,
        };
      case 'In Progress':
        return {
          'color': Colors.blueAccent,
          'backgroundColor': Colors.blueAccent.withOpacity(0.1),
          'icon': Icons.work,
        };
      case 'Completed':
        return {
          'color': Colors.green,
          'backgroundColor': Colors.greenAccent.withOpacity(0.1),
          'icon': Icons.check_circle,
        };
      case 'Needs Revision':
        return {
          'color': Colors.orangeAccent,
          'backgroundColor': Colors.orangeAccent.withOpacity(0.1),
          'icon': Icons.edit,
        };
      case 'Rejected':
        return {
          'color': Colors.redAccent,
          'backgroundColor': Colors.redAccent.withOpacity(0.1),
          'icon': Icons.close,
        };
      default:
        return {
          'color': Colors.grey,
          'backgroundColor': Colors.grey.withOpacity(0.1),
          'icon': Icons.info,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _getStatusStyle(status);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xff333333),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: style['backgroundColor'], // Light background color
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  style['icon'], // Status-specific icon
                  color: style['color'],
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  status,
                  style: TextStyle(
                    color: style['color'], // Status-specific text color
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
