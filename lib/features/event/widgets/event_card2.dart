import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:get/get.dart';

class EventCard2 extends StatelessWidget {
  final Event event;
  final VoidCallback onView;
  final double? width;
  final EdgeInsetsGeometry? margin;

  EventCard2({
    Key? key,
    required this.event,
    required this.onView,
    this.width,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RippleContainer(
      onTap: onView,
      child: Container(
        margin: margin ?? EdgeInsets.zero,
        width: width ?? Get.size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Palette.GREEN3,
        ),
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Background SVG Image
            Positioned(
              top: 8,
              right: 8,
              child: SvgPicture.asset(
                'assets/images/event.svg',
                height: 120, // Optional, adjusts image size
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Date Section
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${event.dateOnly} | ${event.startTimeOnly} - ${event.endTimeOnly}',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      color: Palette.GREEN3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Gap(16),
                // Event Description Section
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: Get.size.width,),
                      // Event Title
                      Text(
                        event.title ?? 'Unknown Event',
                        style: Get.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Palette.DARK_PRIMARY,
                        ),
                      ),
                      const Gap(8),
                      // Coordinates Section
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Palette.GREEN1,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Event Description
                            Text(
                              event.description ?? '',
                              style: Get.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Palette.GREEN3,
                              ),
                            ),
                            const Gap(4),
                            // Coordinates Label
                            Text(
                              'Coordinates',
                              style: Get.textTheme.bodySmall?.copyWith(
                                color: Palette.GREEN3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Gap(6),
                            // Latitude and Longitude
                            Text(
                              'Latitude: ${event.latitude}',
                              style: Get.textTheme.bodySmall,
                            ),
                            const Gap(2),
                            Text(
                              'Longitude: ${event.longitude}',
                              style: Get.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
