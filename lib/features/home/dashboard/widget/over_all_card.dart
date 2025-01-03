import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/circular_loading.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';

class OverAllCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final String count;
  final bool? isLoading;

  OverAllCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.count,
    this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.size.width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white, // Light green as primary background
        border: Border.all(
          color: Palette.deYork300, // Subtle border for emphasis
          width:1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Section
          Container(
            child: icon,
          ),
          const SizedBox(height: 8),
          // Title Section
          Text(
            title,
            style: Get.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Palette.deYork700, // Darker green for titles
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Count Section
          isLoading == true
              ? CircularLoading(
                  color: Palette.deYork600, // Consistent loading spinner color
                )
              : Text(
                  count,
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Palette.deYork900, // Emphasized dark green for count
                  ),
                ),
        ],
      ),
    );
  }
}
