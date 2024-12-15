import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/shimmer_widget.dart';

class ShimmerPostCard extends StatelessWidget {
  const ShimmerPostCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeaderShimmer(),

            const Gap(12),

            // Content Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerWidget(
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const Gap(8),
                ShimmerWidget(
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
                const Gap(8),
                ShimmerWidget(
                  width: double.infinity,
                  height: 14,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),

            const Gap(12),

            // Media Section
            _buildMediaShimmer(),
          ],
        ),
      ),
    );
  }

  // Header Shimmer
  Widget _buildHeaderShimmer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Picture Placeholder
        ShimmerWidget(
          width: 50,
          height: 50,
          borderRadius: BorderRadius.circular(25),
        ),
        const Gap(12),

        // Title and Metadata Placeholder
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerWidget(
                width: 150,
                height: 14,
                borderRadius: BorderRadius.circular(4),
              ),
              const Gap(8),
              ShimmerWidget(
                width: 100,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Media Shimmer
  Widget _buildMediaShimmer() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 4, // Placeholder for 4 media items
      itemBuilder: (context, index) {
        return ShimmerWidget(
          width: double.infinity,
          height: 80,
          borderRadius: BorderRadius.circular(8),
        );
      },
    );
  }
}
