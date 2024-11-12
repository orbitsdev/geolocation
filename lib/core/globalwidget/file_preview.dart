import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:open_filex/open_filex.dart';


class FilePreviewWidget extends StatelessWidget {
  final String filePath; // Path to the file

  const FilePreviewWidget({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String extension = filePath.split('.').last.toLowerCase();

    if (_isImage(extension)) {
      return _buildImagePreview();
    } else if (_isVideo(extension)) {
      return _buildVideoPreview();
    } else {
      return _buildGenericFilePreview(extension);
    }
  }

  bool _isImage(String extension) {
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  bool _isVideo(String extension) {
    return ['mp4', 'avi', 'mov', 'mkv', 'flv', 'webm'].contains(extension);
  }

  Widget _buildImagePreview() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.file(
        File(filePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  Widget _buildVideoPreview() {
    return FutureBuilder<Uint8List?>(
      future: _generateVideoThumbnail(filePath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Image.memory(
                snapshot.data!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                child: Icon(
                  Icons.play_circle_fill,
                  color: Colors.white,
                  size: 34,
                ),
              ),
            ],
          );
        } else {
          return Container(
            color: Colors.black45,
            child: Center(child: Icon(Icons.error, color: Colors.red)),
          );
        }
      },
    );
  }

  Future<Uint8List?> _generateVideoThumbnail(String filePath) async {
    return await VideoThumbnail.thumbnailData(
      video: filePath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // optional, default is 0
      quality: 25,
    );
  }

  Widget _buildGenericFilePreview(String extension) {
    return GestureDetector(
      onTap: () => OpenFilex.open(filePath), // Opens file with external app
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: Colors.grey),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.insert_drive_file, size: 40, color: Colors.grey[700]),
              SizedBox(height: 8),
              Text(
                '.$extension',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
