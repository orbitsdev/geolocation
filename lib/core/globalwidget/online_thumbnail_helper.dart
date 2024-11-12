import 'dart:typed_data';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class OnlineThumbnailHelper {
  static Future<Uint8List?> getThumbnail(String videoUrl) async {
    // Generate the thumbnail and get Uint8List for in-memory display
    final Uint8List? thumbnailData = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 128,
      quality: 75,
    );

    return thumbnailData; // Return Uint8List instead of File
  }
}
