import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/shimmer_widget.dart';

class AttendanceCardShimmer extends StatelessWidget {
  const AttendanceCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Row Shimmer
          Row(
            children: [
              ShimmerWidget(
                width: 40,
                height: 40,
                borderRadius: BorderRadius.circular(30),
              ),
              const Gap(12),
              ShimmerWidget(
                width: 120,
                height: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          const Gap(12),

          // Event Title Shimmer
          ShimmerWidget(
            width: 180,
            height: 14,
            borderRadius: BorderRadius.circular(4),
          ),
          const Gap(8),

          // Event Date Shimmer
          Row(
            children: [
              ShimmerWidget(
                width: 16,
                height: 16,
                borderRadius: BorderRadius.circular(4),
              ),
              const Gap(6),
              ShimmerWidget(
                width: 100,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          const Gap(12),

          // Check-In Time Shimmer
          Row(
            children: [
              ShimmerWidget(
                width: 18,
                height: 18,
                borderRadius: BorderRadius.circular(4),
              ),
              const Gap(6),
              ShimmerWidget(
                width: 100,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          const Gap(8),

          // Check-Out Time Shimmer
          Row(
            children: [
              ShimmerWidget(
                width: 18,
                height: 18,
                borderRadius: BorderRadius.circular(4),
              ),
              const Gap(6),
              ShimmerWidget(
                width: 100,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
