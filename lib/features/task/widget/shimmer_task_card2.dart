import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTaskCard2 extends StatelessWidget {
  const ShimmerTaskCard2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section (Owner Placeholder)
            _buildOwnerShimmer(),
            const Gap(8),

            // Divider Placeholder
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey[300],
              ),
            ),
            const Gap(16),

            // Title and Status Placeholder
            _buildTitleAndStatusShimmer(),
            const Gap(16),

            // Task Details Placeholder
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  const Gap(8),
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  const Gap(8),
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),
            const Gap(16),

            // Footer Placeholder (Due Date)
            _buildFooterShimmer(),
            const Gap(16),

            // Approval Section Placeholder
            _buildApprovalShimmer(),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerShimmer() {
    return Row(
      children: [
        // Circular Placeholder for Profile Picture
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const Gap(8),

        // Rectangular Placeholder for Name
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 14,
            width: 150,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndStatusShimmer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Placeholder for Title
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 16,
            width: 200,
            color: Colors.grey[300],
          ),
        ),
        // Placeholder for Status Badge
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 20,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterShimmer() {
    return Row(
      children: [
        // Icon Placeholder
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const Gap(8),
        // Text Placeholder
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 14,
            width: 120,
            color: Colors.grey[300],
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
