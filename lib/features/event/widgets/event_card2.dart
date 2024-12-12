
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
      // margin: EdgeInsets.all(16),
      width: Get.size.width ,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(16),
        color: Palette.GREEN3,
      ),
             padding: const EdgeInsets.all(16),
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
                Flexible(
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                ),
                ],
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
                    // Event Description
                    Text(
                      // 'EVENT NAME',
                      event.title ?? 'Unknown Event',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Palette.DARK_PRIMARY,
                      ),
                    ),
                     const Gap(8),
                    // Coordinates Section with Background
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8,),
                      decoration: BoxDecoration(
                        color: Palette.GREEN1,
                        // borderRadius: BorderRadius.circular(10),
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
                                  // 'DESCRIPTIN',
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
                          
                        ],
                      ),
                    ),
                  
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
