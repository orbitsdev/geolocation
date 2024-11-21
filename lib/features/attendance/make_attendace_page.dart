import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:geolocation/features/event/model/event_attendance.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocation/features/attendance/controller/attendance_controller.dart';
class MakeAttendancePage extends StatelessWidget {
  const MakeAttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final event = arguments?['event'] as Event;

 
    final AttendanceController controller = Get.put(AttendanceController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeData(event);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () => controller.refreshEventDetails(),
          child: Stack(
            children: [
              GetBuilder<AttendanceController>(builder: (attendanceController) {
                return GoogleMap(
                  padding: EdgeInsets.only(bottom: Get.size.height / 3),
                  onMapCreated: (GoogleMapController mapController) {
                    attendanceController.onMapCreated(mapController);
                    attendanceController.moveCamera();
                    attendanceController.startListeningToPosition();
                  },
                  initialCameraPosition: attendanceController.initialPosition,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: attendanceController.markers.toSet(),
                  circles: attendanceController.geofenceCircles.toSet(),
                );
              }),
              Positioned(
                bottom: 20,
                left: 12,
                right: 12,
                child: GetBuilder<AttendanceController>(
                  builder: (attendanceController) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            attendanceController.selectedItem.value.title ??
                                'Event',
                            style: Get.textTheme.titleLarge,
                          ),
                          const Gap(16),
                          RippleContainer(
                            onTap: () => attendanceController.moveCamera(),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 34, color: Palette.PRIMARY),
                                    const Gap(8),
                                    Expanded(
                                      child: Text(
                                        '${attendanceController.selectedItem.value.startTime ?? ''} - ${attendanceController.selectedItem.value.endTime ?? ''}',
                                        style: Get.textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                const Gap(4),
                                Row(
                                  children: [
                                    Icon(Icons.location_on,
                                        size: 34, color: Palette.PRIMARY),
                                    const Gap(8),
                                    Expanded(
                                      child: Text(
                                        attendanceController.selectedItem.value
                                                .mapLocation ??
                                            'Location not available',
                                        style: Get.textTheme.bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Gap(12),
                         // Check-In Button
    if (attendanceController.selectedItem.value.attendance?.checkInTime == null &&
        attendanceController.isWithinRadius.value)
      SizedBox(
        width: Get.size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.PRIMARY,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: attendanceController.isWithinRadius.value
              ? attendanceController.checkIn
              : null,
          child: Text(
            'Check In',
            style: Get.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ),
      ),
    Gap(12),
    // Check-Out Button
    if (attendanceController.selectedItem.value.attendance?.checkOutTime == null &&
        attendanceController.isWithinRadius.value)
      SizedBox(
        width: Get.size.width,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: attendanceController.isWithinRadius.value
              ? attendanceController.checkOut
              : null,
          child: Text(
            'Check Out',
            style: Get.textTheme.bodyLarge?.copyWith(color: Colors.white),
          ),
        ),
      ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
