import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/circular_loading.dart';
import 'package:geolocation/core/theme/game_pallete.dart';
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
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            // GamePalette.darkBackground,
            Palette.PRIMARY,
            Palette.PRIMARY
            // GamePalette.tealGreen,
          ],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon Section
          Container(
            // padding: const EdgeInsets.all(12),
            // decoration: BoxDecoration(
            //   shape: BoxShape.circle,
            //   gradient: LinearGradient(
            //     colors: [
            //       GamePalette.tealGreen,
            //       GamePalette.darkBackground,
            //     ],
            //     begin: Alignment.topLeft,
            //     end: Alignment.bottomRight,
            //   ),
            // ),
            child: icon,
          ),
          const SizedBox(height: 8),
          // Title Section
          Text(
            title,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: GamePalette.textWhite,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Count Section
          isLoading == true
              ? CircularLoading()
              : Text(
                  '${count}',
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: GamePalette.textWhite,
                  ),
                ),
        ],
      ),
    );
  }
}
