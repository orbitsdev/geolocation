import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/game_pallete.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class OverAllCard extends StatelessWidget {
  final String title;
  final Widget icon;
  final String count;

  OverAllCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            GamePalette.darkBackground,
            GamePalette.tealGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon,
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: Get.textTheme.titleMedium?.copyWith(
                color: GamePalette.textWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            count,
            style: Get.textTheme.headlineSmall?.copyWith(
              color: GamePalette.textWhite,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}