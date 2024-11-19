import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocation/features/attendance/controller/attendance_controller.dart';

class MakeAttendancePage extends StatelessWidget {
  const MakeAttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the passed Event from arguments
    final Event event = Get.arguments as Event;

    // Initialize the controller and set the selected item
    final AttendanceController controller = Get.put(AttendanceController());
    controller.selectedItem.value = event; // Set the event directly from arguments
    controller.update();
    controller.startListeningToPosition();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
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
                        attendanceController.selectedItem.value.title ?? 'Event',
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
                      const Gap(12),
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
                              ? attendanceController.checkInOrOut
                              : null,
                          child: Text(
                            'Check In',
                            style: Get.textTheme.bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
