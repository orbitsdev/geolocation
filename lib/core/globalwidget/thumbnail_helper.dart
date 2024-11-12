import 'dart:typed_data';

import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';

class ThumbnailHelper {
  static Future<Uint8List?> getThumbnail(String videoPath) async {
    return await VideoThumbnail.thumbnailData(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128, // Specify the width of the thumbnail
      quality: 25,   // Set the quality of the thumbnail
    );
  }
}
