import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/shimmer_widget.dart';
import 'package:get/get.dart';

class ShimmerMediaResourceCardNew extends StatelessWidget {
  const ShimmerMediaResourceCardNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for image or video preview
          ShimmerWidget(
            height: Get.size.height * 0.12, // 12% of screen height
            width: double.infinity,
            borderRadius: BorderRadius.circular(8),
          ),
          const Gap(8),

          // Placeholder for file name
          ShimmerWidget(
            height: Get.size.height * 0.015, // 1.5% of screen height
            width: Get.size.width * 0.7, // 70% of screen width
            borderRadius: BorderRadius.circular(4),
          ),
          const Gap(4),

          // Placeholder for uploader information
          Row(
            children: [
              ShimmerWidget(
                height: Get.size.height * 0.03, // 3% of screen height
                width: Get.size.height * 0.03, // 3% of screen height for a circle
                borderRadius: BorderRadius.circular(10),
              ),
              const Gap(8),
              Flexible(
                child: ShimmerWidget(
                  height: Get.size.height * 0.015, // 1.5% of screen height
                  width: Get.size.width, // 50% of screen width
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
