import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/shimmer_widget.dart';
import 'package:geolocation/core/theme/palette.dart';

class ShimmerEventCard3 extends StatelessWidget {
  final double height;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const ShimmerEventCard3({
    Key? key,
    this.height = 240, // Same height as the original EventCard3
    this.width,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(right: 16),
      height: height,
      width:width?? 250, // Same width as the original EventCard3
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
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(16),
          //   child: ShimmerWidget(
          //     height: height,
          //     width: double.infinity,
          //     borderRadius: BorderRadius.circular(16),
          //   ),
          // ),

          // Gradient Overlay (Static for Consistency)
          // Positioned.fill(
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.white.withOpacity(0.1),
          //       borderRadius: BorderRadius.circular(16),
          //     ),
          //   ),
          // ),

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
                ShimmerWidget(
                  width: 150,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
                const Gap(8),
                // Date and Time Shimmer
                ShimmerWidget(
                  width: 100,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const Gap(8),
                // Description Shimmer
                Column(
                  children: [
                    ShimmerWidget(
                      width: double.infinity,
                      height: 14,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const Gap(4),
                    ShimmerWidget(
                      width: double.infinity,
                      height: 14,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
