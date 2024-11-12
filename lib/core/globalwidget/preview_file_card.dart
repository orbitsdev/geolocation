import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/preview_other_file.dart';
import 'package:geolocation/core/globalwidget/preview_image.dart';
import 'package:geolocation/core/globalwidget/preview_video.dart';
import 'package:geolocation/features/file/model/media_file.dart';

class MediaFileCard extends StatelessWidget {
  final MediaFile file;

  const MediaFileCard({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (file.type != null && file.type!.startsWith('image'))
          PreviewImage(url: file.url ?? '')
        else if (file.type != null && file.type!.startsWith('video'))
          PreviewVideo(file: file)
        else
          PreviewOtherFile(file: file),
        SizedBox(height: 8), // Spacing between preview and file name
        Text(
          file.file_name ?? 'Unknown File', // Display the file name
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis, // Handle long file names
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}