import 'package:flutter/material.dart';

class PreviewOtherFileNew extends StatelessWidget {
  final String fileName;
  final String extension;

  const PreviewOtherFileNew({
    Key? key,
    required this.fileName,
    required this.extension,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[300],
      ),
      height: 85,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.insert_drive_file, size: 32, color: Colors.grey[700]),
            const SizedBox(height: 4),
            Text(
              extension.toUpperCase(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
