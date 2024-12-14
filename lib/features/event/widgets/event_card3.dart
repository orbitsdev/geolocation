import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/image/offline_image.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:get/get.dart';

class EventCard3 extends StatelessWidget {
  final Event event;
  final VoidCallback onView;
  final double height;
  final EdgeInsetsGeometry? margin;

  EventCard3({
    Key? key,
    required this.event,
    required this.onView,
    this.height = 240, // Height optimized for horizontal scrolling
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RippleContainer(
      onTap: onView,
      child: Container(
        margin: margin ?? const EdgeInsets.only(right: 16),
        height: height,
        width: 250, // Compact width for horizontal layout
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: OfflineImage(
                  path: imagePath('1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      // Palette.BLACK.withOpacity(0.7),
                      // Palette.GREEN3.withOpacity(0.1),
                      Palette.PRIMARY.withOpacity(0.95), Palette.GREEN2.withOpacity(0.30)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
            // Content Overlay
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Event Title
                  Text(
                    event.title ?? 'Event Title',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(4),
                  // Event Date and Time
                  Text(
                    '${event.dateOnly} | ${event.startTimeOnly}',
                    style: Get.textTheme.bodySmall?.copyWith(
                         color: Colors.white,
                    ),
                  ),
                  const Gap(8),
                  // Event Description
                  Text(
                    event.description ?? 'No description available',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.bodySmall?.copyWith(
                         color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
