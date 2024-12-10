import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class NotificationGlobal extends StatelessWidget {
  final int value;
  final VoidCallback action;
  final Color? badgeColor;
  final Color? textColor;

  const NotificationGlobal({
    Key? key,
    required this.value,
    required this.action,
    this.badgeColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Notification Icon
        IconButton(
          onPressed: action,
          icon: HeroIcon(HeroIcons.bell),
        ),

        // Badge (only visible when value > 0)
        if (value > 0)
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              decoration: BoxDecoration(
                color: badgeColor ?? Colors.red, // Default badge color
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
                    fontSize: 10,
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
