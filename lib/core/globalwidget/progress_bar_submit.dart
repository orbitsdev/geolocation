import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';

class ProgressBarSubmit extends StatelessWidget {
  final double progress; // Progress parameter

  const ProgressBarSubmit({Key? key, required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Stack(
      alignment: Alignment.center,
      children: [
        LinearProgressIndicator(
          value: progress,
          minHeight: 12, // Increased height for better visibility
          backgroundColor: Colors.grey[300],
          color: Palette.PRIMARY_DARK,
        ),
        Text(
          '${(progress * 100).toStringAsFixed(0)}%', // Dynamic percentage display
          style: Get.textTheme.bodySmall?.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
