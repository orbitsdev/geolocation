import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/online_thumbnail_helper.dart';
import 'package:geolocation/core/globalwidget/shimmer/shimmer.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/file/model/media_file.dart';

class PreviewVideo extends StatelessWidget {
  final MediaFile file;

  PreviewVideo({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: OnlineThumbnailHelper.getThumbnail(file.url ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
           return Stack(
             children: [
               ShimmerWidget(
                borderRadius: BorderRadius.circular(8),
                width: double.infinity,
                height: 85,
                         ),
                         Positioned(
                  child: Icon(
                    Icons.play_circle_filled,
                    color: Palette.PRIMARY_DARK,
                    size: 34,
                  ),
                  top: 0,
                  bottom: 0,
                  left: 0,
                  right: 0,)

             ],
           );
        } else if (snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            height: 85,
            child: Stack(
              children: [
                // Display the thumbnail image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    snapshot.data!,
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
                   color: Palette.PRIMARY_DARK,
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
        } else {
          return Container(
            color: Colors.black45,
            child: Icon(Icons.error, color: Colors.red),
          );
        }
      },
    );
  }
}
