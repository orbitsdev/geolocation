import 'package:flutter/material.dart';

class RemarkWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color backgroundColor;

  const RemarkWidget({
    Key? key,
    this.title = "Remarks", // Default title
    required this.message,
    this.icon = Icons.info_outline,
    this.backgroundColor = const Color(0xFFFCECEE), // Light background color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.redAccent, // Customize icon color
                size: 24.0,
              ),
              const SizedBox(width: 8.0),
              Text(
                title,
                style: TextStyle(
                  color: Colors.black87, // Title color
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold, // Bold for emphasis
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            message,
            style: TextStyle(
              color: Colors.black87, // Message text color
              fontSize: 14.0,
            ),
          ),
        ],
      ),
    );
  }
}
