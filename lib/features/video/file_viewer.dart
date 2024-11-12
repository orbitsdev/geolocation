
import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/browser_view_page.dart';
import 'package:geolocation/features/file/model/media_file.dart';
import 'package:geolocation/features/video/online_image_with_close.dart';
import 'package:geolocation/features/video/online_video_player.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
// Import your OnlineVideoPlayer widget here

class FileViewer extends StatefulWidget {
  final List<MediaFile> mediaFiles;
  final int initialIndex;

  FileViewer({
    required this.mediaFiles,
    this.initialIndex = 0,
  });

  @override
  _FileViewerState createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.mediaFiles.length,
        itemBuilder: (context, index) {
         final file = widget.mediaFiles[index];
        if (file.type!.startsWith('video')) {
          return OnlineVideoPlayer(url: file.url ?? '');
        } else if (file.type!.startsWith('image')) {
          return OnineImageWithClose(imageUrl: file.url ?? '');
        } else {
          return BrowserViewerPage(file: file); 
        }
        },
      ),
    );
  }
}
