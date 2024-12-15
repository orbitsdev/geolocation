import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

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
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: Colors.grey[300],
                  ),
                  const Gap(8),
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: Colors.grey[300],
                  ),
                  const Gap(8),
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),

            const Gap(12),

            // Media Section
            _buildMediaShimmer(),

            // const Gap(12),

            // // Collection Section
            // _buildCollectionShimmer(),
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
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
        const Gap(12),

        // Title and Metadata Placeholder
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 150,
                  height: 14,
                  color: Colors.grey[300],
                ),
              ),
              const Gap(8),
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 100,
                  height: 12,
                  color: Colors.grey[300],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Media Shimmer
  Widget _buildMediaShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 4, // Placeholder for 4 media items
        itemBuilder: (context, index) {
          return Container(
            height: 80,
            width: 80,
            color: Colors.grey[300],
          );
        },
      ),
    );
  }

  // Collection Shimmer
  Widget _buildCollectionShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 200,
        width: double.infinity,
        color: Colors.grey[300],
      ),
    );
  }
}
