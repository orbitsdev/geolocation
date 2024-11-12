import 'dart:typed_data';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
class OnlineThumbnailHelper {
  static final Map<String, Uint8List?> _thumbnailCache = {};

  static Future<Uint8List?> getThumbnail(String videoUrl) async {
    if (_thumbnailCache.containsKey(videoUrl)) {
      return _thumbnailCache[videoUrl]; // Return cached thumbnail if available
    }

    // Generate the thumbnail and get Uint8List for in-memory display
    final Uint8List? thumbnailData = await VideoThumbnail.thumbnailData(
      video: videoUrl,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 128,
      quality: 75,
    );

    _thumbnailCache[videoUrl] = thumbnailData; // Cache the generated thumbnail
    return thumbnailData;
  }
}
