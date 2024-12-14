import 'package:flutter/material.dart';
import 'package:geolocation/features/files/model/media_resource.dart';
import 'package:geolocation/features/files/pages/media_resource_browser_viewer_page.dart';
import 'package:geolocation/features/video/online_image_with_close.dart';
import 'package:geolocation/features/video/online_video_player.dart';

class MediaResourceViewer extends StatefulWidget {
  final List<MediaResource> mediaResources;
  final int initialIndex;

  const MediaResourceViewer({
    Key? key,
    required this.mediaResources,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  _MediaResourceViewerState createState() => _MediaResourceViewerState();
}

class _MediaResourceViewerState extends State<MediaResourceViewer> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.mediaResources.length,
        itemBuilder: (context, index) {
          final media = widget.mediaResources[index];

          // Check for video type
          if (media.type?.startsWith('video') == true) {
            return OnlineVideoPlayer(url: media.url ?? '');
          } 
          // Check for image type
          else if (media.type?.startsWith('image') == true) {
            return OnineImageWithClose(imageUrl: media.url ?? '');
          } 
          // Handle other types like PDF, DOCX, etc.
          else {
            return MediaResourceBrowserViewerPage(
              file: media, // Pass the entire MediaResource object
            );
          }
        },
      ),
    );
  }
}
