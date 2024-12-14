import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:get/get.dart';

// class EventCard2 extends StatelessWidget {
//   final Event event;
//   final VoidCallback onView;
//   final double? width;
//   final EdgeInsetsGeometry? margin;

//   EventCard2({
//     Key? key,
//     required this.event,
//     required this.onView,
//     this.width,
//     this.margin,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return RippleContainer(
//       onTap: onView,
//       child: Container(
//         margin: margin ?? EdgeInsets.zero,
//         width: width ?? Get.size.width,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Palette.GREEN3,
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Stack(
//           children: [
//             // Background SVG Image
//             Positioned(
//               top: 8,
//               right: 8,
//               child: SvgPicture.asset(
//                 'assets/images/event.svg',
//                 height: 120, // Optional, adjusts image size
//                 width: 120,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Event Date Section
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     '${event.dateOnly} | ${event.startTimeOnly} - ${event.endTimeOnly}',
//                     style: Get.textTheme.bodyMedium?.copyWith(
//                       color: Palette.GREEN3,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 const Gap(16),
//                 // Event Description Section
//                 Container(
//                   padding: const EdgeInsets.all(8),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Container(width: Get.size.width,),
//                       // Event Title
//                       Text(
//                         event.title ?? 'Unknown Event',
//                         style: Get.textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           color: Palette.DARK_PRIMARY,
//                         ),
//                       ),
//                       const Gap(8),
//                       // Coordinates Section
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 8.0, horizontal: 8),
//                         decoration: BoxDecoration(
//                           color: Palette.GREEN1,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Event Description
//                             Text(
//                               event.description ?? '',
//                               style: Get.textTheme.bodyMedium?.copyWith(
//                                 fontWeight: FontWeight.bold,
//                                 color: Palette.GREEN3,
//                               ),
//                             ),
//                             const Gap(4),
//                             // Coordinates Label
//                             Text(
//                               'Coordinates',
//                               style: Get.textTheme.bodySmall?.copyWith(
//                                 color: Palette.GREEN3,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const Gap(6),
//                             // Latitude and Longitude
//                             Text(
//                               'Latitude: ${event.latitude}',
//                               style: Get.textTheme.bodySmall,
//                             ),
//                             const Gap(2),
//                             Text(
//                               'Longitude: ${event.longitude}',
//                               style: Get.textTheme.bodySmall,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//}


import 'package:flutter/material.dart';
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

  const EventCard2({
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
        width: width ?? Get.size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            // BoxShadow(
            //   color: Colors.black.withOpacity(0.1),
            //   blurRadius: 8,
            //   spreadRadius: 2,
            //   offset: const Offset(0, 4),
            // ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Date and Time
            _buildDateSection(),

            const Gap(12),

            // Event Title and Description
            _buildEventDetails(),

            const Gap(12),

            // Event Location Details (Coordinates)
            _buildLocationDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Row(
      children: [
        // Event Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Palette.GREEN3,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.event, color: Colors.white, size: 24),
        ),
        const Gap(12),

        // Date and Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${event.dateOnly ?? ''}',
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                '${event.startTimeOnly ?? ''} - ${event.endTimeOnly ?? ''}',
                style: Get.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Event Title
        Text(
          event.title ?? 'Unknown Event',
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Palette.GREEN3,
          ),
        ),

        const Gap(8),

        // Event Description
        if (event.description != null && event.description!.isNotEmpty)
          Text(
            event.description!,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: Palette.GRAY1,
            ),
          ),
      ],
    );
  }

  Widget _buildLocationDetails() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Palette.GREEN1,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on, color: Palette.GREEN3, size: 18),
          const Gap(8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Latitude
                Text(
                  'Latitude: ${event.latitude ?? 'N/A'}',
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Palette.GREEN2,
                  ),
                ),

                const Gap(4),

                // Longitude
                Text(
                  'Longitude: ${event.longitude ?? 'N/A'}',
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Palette.GREEN2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
