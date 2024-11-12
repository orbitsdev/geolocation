import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class LocalVideoPlayer extends StatefulWidget {
  final String filePath;

  LocalVideoPlayer({required this.filePath});

  @override
  _LocalVideoPlayerState createState() => _LocalVideoPlayerState();
}

class _LocalVideoPlayerState extends State<LocalVideoPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _skipForward() {
    final currentPosition = _controller.value.position;
    final skipDuration = const Duration(seconds: 10);
    _controller.seekTo(currentPosition + skipDuration);
  }

  void _skipBackward() {
    final currentPosition = _controller.value.position;
    final skipDuration = const Duration(seconds: 10);
    _controller.seekTo(currentPosition - skipDuration);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
           Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Center(child: CircularProgressIndicator()),
        ),


         Positioned(
          top: 40, // Adjust the top position as needed
          right: 20, // Position at the top-right corner
          child: IconButton(
            icon: Icon(Icons.close, color: Colors.white, size: 30),
            onPressed: () {
              Get.back(); 
            },
          ),
        ),
        Positioned(
          bottom: 0, 
          left: 0,
          right: 0,
          child: _buildVideoControls(),
        ),
        ],
      ),
    );
  }
Widget _buildVideoControls() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.black.withOpacity(0.7), Colors.transparent],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
      borderRadius: BorderRadius.circular(8), // Optional for rounded edges
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: _controller,
          builder: (context, VideoPlayerValue value, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDuration(value.position),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  _formatDuration(value.duration),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            );
          },
        ),
        VideoProgressIndicator(
          _controller,
          allowScrubbing: true,
          colors: VideoProgressColors(
            playedColor: Colors.red,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.white,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.replay_10, color: Colors.white),
              onPressed: _skipBackward,
            ),
            IconButton(
              icon: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying ? _controller.pause() : _controller.play();
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.forward_10, color: Colors.white),
              onPressed: _skipForward,
            ),
          ],
        ),
      ],
    ),
  );
}


String _formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return '$minutes:$seconds';
}



}
