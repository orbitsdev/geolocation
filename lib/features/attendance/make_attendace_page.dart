import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocation/features/attendance/controller/attendance_controller.dart';

class MakeAttendancePage extends StatelessWidget {
  const MakeAttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.put(AttendanceController());

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
            Obx(() => GoogleMap(
              padding:EdgeInsets.only(bottom: Get.size.height /3),
                  onMapCreated: controller.onMapCreated,
                  initialCameraPosition: controller.initialPosition,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: controller.markers.toSet(),
                  circles: controller.geofenceCircles.toSet(),
                )),
            Positioned(
              bottom: 20,
              left: 12,
              right: 12,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.selectedItem.value.title ?? 'Event',
                      style: Get.textTheme.titleLarge,
                    ),
                    Gap(16),
                    RippleContainer(
                      onTap: () => controller.moveCamera(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 34, color: Palette.PRIMARY),
                              Gap(8),
                              Expanded(
                                child: Text(
                                  '${controller.selectedItem.value.startTime ?? ''} - ${controller.selectedItem.value.endTime ?? ''}',
                                  style: Get.textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                          Gap(4),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 34, color: Palette.PRIMARY),
                              Gap(8),
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
                    Gap(12),
                    SizedBox(
                      width: Get.size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.PRIMARY,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: controller.checkInOrOut,
                        child: Text(
                          'Check In',
                          style: Get.textTheme.bodyLarge?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
