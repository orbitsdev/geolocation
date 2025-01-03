import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:heroicons/heroicons.dart';

class NotificationGlobal extends StatelessWidget {
  final int value;
  final VoidCallback action;
  final Color? badgeColor;
  final Color? textColor;
  double? size;

   NotificationGlobal({
    Key? key,
    required this.value,
    required this.action,
    this.badgeColor,
    this.textColor,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Notification Icon
        IconButton(
          onPressed: action,
          icon: HeroIcon(HeroIcons.bell,size: size ??34,),
        ),

        // Badge (only visible when value > 0)
        if (value > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: badgeColor ?? Palette.RED, // Default badge color
                borderRadius: BorderRadius.circular(20),
              ),
              constraints: const BoxConstraints(
                minWidth: 14,
                minHeight: 14,
              ),
              child: Center(
                child: Text(
                  '$value',
                  style: TextStyle(
                    color: textColor ?? Colors.white, // Default text color
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
