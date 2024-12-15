import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/shimmer_widget.dart';

class ShimmerCollectionCard extends StatelessWidget {
  const ShimmerCollectionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerWidget(
                    width: 150,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const Gap(8),
                  ShimmerWidget(
                    width: 100,
                    height: 12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const Gap(8),
                  ShimmerWidget(
                    width: 120,
                    height: 14,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
              Column(
                children: [
                  ShimmerWidget(
                    width: 5,
                    height: 5,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  ShimmerWidget(
                    width: 5,
                    height: 5,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  ShimmerWidget(
                    width: 5,
                    height: 5,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ],
          ),
          const Gap(16),

          // Description Section
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
          const Gap(16),

          // Chart Placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child:  Center(
              child: ShimmerWidget(
                width: 100,
                height: 14,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
