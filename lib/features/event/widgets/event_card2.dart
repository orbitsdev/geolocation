
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class EventCard2 extends StatelessWidget {
  final Event event;
  final VoidCallback onView;

  const EventCard2({
    Key? key,
    required this.event,
    required this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Palette.GREEN3,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      margin: const EdgeInsets.only(bottom: 24),
      child: Stack(
        children: [
          // Background SVG Image
          Positioned(
            top: 8,
            right: 8,
            child: SizedBox(
              height: 120,
              width: 120,
            child: SvgPicture.asset(
                'assets/images/event.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Date Section
              Row(
                children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${event.startTime}- ${event.endTime}}',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Palette.GREEN3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const Gap(16),
              // Event Description Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Description
                    Text(
                      event.title ?? 'Unknown Event',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Palette.DARK_PRIMARY,
                      ),
                    ),
                    const Gap(8),
                    // Coordinates Section with Background
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16,),
                      decoration: BoxDecoration(
                        color: Palette.GREEN1,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${event.description}',
                                  style: Get.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.GREEN3,
                                  ),
                                ),
                                Gap(4),
                                Text(
                                  'Coordinates',
                                  style: Get.textTheme.bodySmall!.copyWith(
                                    color: Palette.GREEN3,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                const Gap(6),
                                Text(
                                  'Latitude: ${event.latitude}',
                                  style: Get.textTheme.bodySmall,
                                ),
                                const Gap(2),
                                Text(
                                  'Lotitude:${event.longitude}',
                                  style: Get.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          RippleContainer(
                            onTap: onView,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Palette.GREEN3,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: HeroIcon(
                                  HeroIcons.mapPin,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(8),
                    Divider(),
                    // Event Schedules Section
                    
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
