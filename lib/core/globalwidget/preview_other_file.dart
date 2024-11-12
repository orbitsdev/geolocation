import 'package:flutter/material.dart';
import 'package:geolocation/features/file/model/media_file.dart';

class PreviewOtherFile extends StatelessWidget {
  final MediaFile file;

  const PreviewOtherFile({
    Key? key,
    required this.file,
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
            Icon(Icons.insert_drive_file, size: 34, color: Colors.grey[700]),
            SizedBox(height: 4),
            Text(
              file.extension ?? 'File',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}