import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/online_thumbnail_helper.dart';
import 'package:geolocation/core/globalwidget/shimmer/shimmer.dart';
import 'package:geolocation/core/theme/palette.dart';

class PreviewVideoNew extends StatefulWidget {
  final String url;
  final double? height;

  const PreviewVideoNew({
    Key? key,
    required this.url,
    this.height,
  }) : super(key: key);

  @override
  _PreviewVideoNewState createState() => _PreviewVideoNewState();
}

class _PreviewVideoNewState extends State<PreviewVideoNew> {
  late ValueNotifier<Uint8List?> _thumbnailNotifier;

  @override
  void initState() {
    super.initState();
    _thumbnailNotifier = ValueNotifier<Uint8List?>(null);
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    final thumbnail = await OnlineThumbnailHelper.getThumbnail(widget.url);
    _thumbnailNotifier.value = thumbnail;
  }

  @override
  void dispose() {
    _thumbnailNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return ValueListenableBuilder<Uint8List?>(
      valueListenable: _thumbnailNotifier,
      builder: (context, thumbnail, child) {
        if (thumbnail == null) {
          // Show shimmer while the thumbnail is loading
          return Stack(
            children: [
              ShimmerWidget(
                borderRadius: BorderRadius.circular(8),
                width: double.infinity,
                height: widget.height ?? 85,
              ),
               Positioned(
                child: Icon(
                  Icons.play_circle_filled,
                  color: Palette.LIGHT_PRIMARY,
                  size: 34,
                ),
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
              ),
            ],
          );
        } else {
          // Display the cached thumbnail
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            height: widget.height ?? 85,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    thumbnail,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.5),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                // Play icon
                 Positioned(
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Palette.LIGHT_PRIMARY,
                    size: 34,
                  ),
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
