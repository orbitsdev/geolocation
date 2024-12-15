import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/map_loading.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/model/attendance.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:geolocation/features/event/model/event_attendance.dart';
import 'package:geolocation/features/event/widgets/time_card.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocation/features/attendance/controller/attendance_controller.dart';

// class MakeAttendancePage extends StatefulWidget {
//   const MakeAttendancePage({Key? key}) : super(key: key);

//   @override
//   State<MakeAttendancePage> createState() => _MakeAttendancePageState();
// }

// class _MakeAttendancePageState extends State<MakeAttendancePage> {
//   var controller = Get.find<AttendanceController>();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // controller.prepareMap();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final arguments = Get.arguments;
//     final event = arguments?['event'] as Event;

//     final AttendanceController controller = Get.put(AttendanceController());
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.initializeData(event);
//     });

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Mark Attendance'),
//         centerTitle: true,
//       ),
//       body:  GetBuilder<AttendanceController>(builder: (controller) {
//           if(controller.isLoading.value){
//             return Center(child: MapLoading());
//           }
//           if(controller.isLoading.value == false && controller.isMapReady.value == false){
//               return Container(child: Column(children: [
//                 Text('Somethint whent wrong pelac hcej ytou locaiton orn itner citon')
//               ],),);
//           }

         
//          return RefreshIndicator(
//           triggerMode: RefreshIndicatorTriggerMode.anywhere,
//           onRefresh: () => controller.refreshEventDetails(),
//           child: Stack(
//             children: [
//               GetBuilder<AttendanceController>(builder: (attendanceController) {
//                 return GoogleMap(
//                   padding: EdgeInsets.only(bottom: Get.size.height / 3),
//                   onMapCreated: (GoogleMapController mapController) {
//                     attendanceController.onMapCreated(mapController);
//                     attendanceController.moveCamera();
//                     attendanceController.startListeningToPosition();
//                   },
//                   initialCameraPosition: attendanceController.initialPosition,
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: true,
//                   markers: attendanceController.markers.toSet(),
//                   circles: attendanceController.geofenceCircles.toSet(),
//                 );
//               }),
//               Positioned(
//                 bottom: 20,
//                 left: 12,
//                 right: 12,
//                 child: GetBuilder<AttendanceController>(
//                   builder: (attendanceController) {
//                     return Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8),
//                         color: Colors.white,
//                       ),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Event Title
//                             Text(
//                               attendanceController.selectedItem.value.title ??
//                                   'Event',
//                               style: Get.textTheme.titleLarge,
//                             ),
//                             const Gap(16),
//                             // Event Details
//                             RippleContainer(
//                               onTap: () => attendanceController.moveCamera(),
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     children: [
//                                       Icon(Icons.calendar_today,
//                                           size: 34, color: Palette.PRIMARY),
//                                       const Gap(8),
//                                       Expanded(
//                                         child: Text(
//                                           '${attendanceController.selectedItem.value.startTime ?? ''} - ${attendanceController.selectedItem.value.endTime ?? ''}',
//                                           style: Get.textTheme.bodyMedium,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   const Gap(4),
//                                   Row(
//                                     children: [
//                                       Icon(Icons.location_on,
//                                           size: 34, color: Palette.PRIMARY),
//                                       const Gap(8),
//                                       Expanded(
//                                         child: Text(
//                                           attendanceController.selectedItem
//                                                   .value.mapLocation ??
//                                               'Location not available',
//                                           style: Get.textTheme.bodyMedium,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const Gap(12),
//                             // Check-In TimeCard
//                             if (attendanceController.selectedItem.value
//                                         .attendance?.checkInTime !=
//                                     null ||
//                                 attendanceController.selectedItem.value
//                                         .attendance?.checkOutTime !=
//                                     null)
//                               TimeCard(
//                                 attendance: attendanceController.selectedItem
//                                     .value.attendance as Attendance,
//                               ),
//                             const Gap(12),
//                             // Check-Out TimeCard

//                             const Gap(12),
//                             // Check-In Button
//                             if (attendanceController.selectedItem.value
//                                     .attendance?.checkInTime ==
//                                 null)
//                               SizedBox(
//                                 width: Get.size.width,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Palette.PRIMARY,
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 16),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   onPressed:
//                                       attendanceController.isWithinRadius.value
//                                           ? attendanceController.checkIn
//                                           : null,
//                                   child: Text(
//                                     'Check In',
//                                     style: Get.textTheme.bodyLarge
//                                         ?.copyWith(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             const Gap(12),
//                             // Check-Out Button
//                             if (attendanceController.selectedItem.value
//                                     .attendance?.checkOutTime ==
//                                 null)
//                               SizedBox(
//                                 width: Get.size.width,
//                                 child: ElevatedButton(
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor: Colors.red,
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 16),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                   ),
//                                   onPressed:
//                                       attendanceController.isWithinRadius.value
//                                           ? attendanceController.checkOut
//                                           : null,
//                                   child: Text(
//                                     'Check Out',
//                                     style: Get.textTheme.bodyLarge
//                                         ?.copyWith(color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
     
//     );
//   }
// }


class MakeAttendancePage extends StatefulWidget {
  const MakeAttendancePage({Key? key}) : super(key: key);

  @override
  State<MakeAttendancePage> createState() => _MakeAttendancePageState();
}

class _MakeAttendancePageState extends State<MakeAttendancePage> {
  final AttendanceController controller = Get.put(AttendanceController());

  @override
  void initState() {
    super.initState();
    final arguments = Get.arguments;
    final event = arguments?['event'] as Event;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeData(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        centerTitle: true,
      ),
      body: GetBuilder<AttendanceController>(builder: (controller) {
        // Show loading indicator while loading
        if (controller.isLoading.value) {
          return  Center(child: MapLoading());
        }

        // Show message if the map is not ready
        if (!controller.isMapReady.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64, color: Colors.red),
                const Gap(16),
                Text(
                  'Unable to load the map.',
                  style: Get.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
                Text(
                  'Please ensure that location services are enabled and you have a stable internet connection.',
                  style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const Gap(24),
                ElevatedButton.icon(
                  onPressed: () => controller.refreshEventDetails(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.PRIMARY,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        }

        // Show the map and UI if everything is ready
        return RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () => controller.refreshEventDetails(),
          child: Stack(
            children: [
              GoogleMap(
                padding: EdgeInsets.only(bottom: Get.size.height / 3),
                onMapCreated: controller.onMapCreated,
                initialCameraPosition: controller.initialPosition,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: controller.markers.toSet(),
                circles: controller.geofenceCircles.toSet(),
              ),
              Positioned(
                bottom: 20,
                left: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: _buildEventDetails(controller),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEventDetails(AttendanceController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.selectedItem.value.title ?? 'Event',
            style: Get.textTheme.titleLarge,
          ),
          const Gap(16),
          RippleContainer(
            onTap: controller.moveCamera,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 34, color: Palette.PRIMARY),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        '${controller.selectedItem.value.startTime ?? ''} - ${controller.selectedItem.value.endTime ?? ''}',
                        style: Get.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 34, color: Palette.PRIMARY),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        controller.selectedItem.value.mapLocation ?? 'Location not available',
                        style: Get.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(12),
          if (controller.selectedItem.value.attendance?.checkInTime != null ||
              controller.selectedItem.value.attendance?.checkOutTime != null)
            TimeCard(attendance: controller.selectedItem.value.attendance as Attendance),
          const Gap(12),
          if (controller.selectedItem.value.attendance?.checkInTime == null)
            _buildAttendanceButton('Check In', Palette.GREEN3, controller.checkIn, controller.isWithinRadius.value),
          const Gap(12),
          if (controller.selectedItem.value.attendance?.checkOutTime == null)
            _buildAttendanceButton('Check Out', Colors.red, controller.checkOut, controller.isWithinRadius.value),
        ],
      ),
    );
  }

  Widget _buildAttendanceButton(String label, Color color, VoidCallback onPressed, bool isEnabled) {
    return SizedBox(
      width: Get.size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isEnabled ? onPressed : null,
        child: Text(
          label,
          style: Get.textTheme.bodyLarge?.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
