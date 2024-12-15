import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/theme/palette.dart';

class ShimmerEventCard3 extends StatelessWidget {
  final double height;
  final EdgeInsetsGeometry? margin;

  const ShimmerEventCard3({
    Key? key,
    this.height = 240, // Same height as the original EventCard3
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(right: 16),
      height: height,
      width: 250, // Same width as the original EventCard3
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Shimmer
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Shimmer.fromColors(
              baseColor: Palette.SHIMMER100,
              highlightColor: Palette.SHIMMER300,
              child: Container(
                height: height,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
          ),
          // Gradient Overlay (Static for Consistency)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                
              ),
            ),
          ),
          // Content Shimmer Overlay
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Shimmer
                Shimmer.fromColors(
                  baseColor: Palette.SHIMMER100,
                  highlightColor: Palette.SHIMMER300,
                  child: Container(
                    width: 150,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                ),
                const Gap(8),
                // Date and Time Shimmer
                Shimmer.fromColors(
                  baseColor: Palette.SHIMMER100,
                  highlightColor: Palette.SHIMMER300,
                  child: Container(
                    width: 100,
                    height: 14,
                    color: Colors.grey[300],
                  ),
                ),
                const Gap(8),
                // Description Shimmer
                Shimmer.fromColors(
                  baseColor: Palette.SHIMMER100,
                  highlightColor: Palette.SHIMMER300,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 14,
                        color: Colors.grey[300],
                      ),
                      const Gap(4),
                      Container(
                        width: double.infinity,
                        height: 14,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
