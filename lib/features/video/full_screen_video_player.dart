// FullScreenVideoPlayer.dart

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final VoidCallback playPauseFunction;
  final VoidCallback rewindFunction;
  final VoidCallback fastForwardFunction;

  const FullScreenVideoPlayer({
    Key? key,
    required this.controller,
    required this.playPauseFunction,
    required this.rewindFunction,
    required this.fastForwardFunction,
  }) : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.controller.value.isPlaying;
    widget.controller.addListener(_updatePlayingState);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePlayingState);
    super.dispose();
  }

  void _updatePlayingState() {
    setState(() {
      _isPlaying = widget.controller.value.isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: widget.controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(widget.controller),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: widget.rewindFunction,
                      icon: Icon(Icons.replay_10, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: widget.playPauseFunction,
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32.0,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.fastForwardFunction,
                      icon: Icon(Icons.forward_10, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}