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
        title: const Text('Event Details'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Palette.gray50,
        foregroundColor: Palette.gray900,
      ),
      body: GetBuilder<AttendanceController>(builder: (controller) {
        if (controller.isLoading.value) {
          return  Center(child: MapLoading());
        }

        if (!controller.isMapReady.value) {
          return _buildErrorState(controller);
        }

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
                    borderRadius: BorderRadius.circular(12),
                    color: Palette.gray50,
                    boxShadow: [
                      BoxShadow(
                        color: Palette.gray300.withOpacity(0.5),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
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

  Widget _buildErrorState(AttendanceController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 64, color: Palette.RED),
          const Gap(16),
          Text(
            'Unable to load the map.',
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Palette.gray900,
            ),
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Text(
            'Ensure location services are enabled and your internet connection is stable.',
            style: Get.textTheme.bodyMedium?.copyWith(color: Palette.gray600),
            textAlign: TextAlign.center,
          ),
          const Gap(24),
          ElevatedButton.icon(
            onPressed: () => controller.refreshEventDetails(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.deYork500,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventDetails(AttendanceController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.selectedItem.value.title ?? 'Event Title',
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Palette.gray900,
            ),
          ),
          const Gap(8),
          Text(
            controller.selectedItem.value.description ?? 'No description available.',
            style: Get.textTheme.bodyMedium?.copyWith(color: Palette.gray700),
          ),
          const Gap(16),
          RippleContainer(
            onTap: controller.moveCamera,
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 34, color: Palette.deYork600),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        '${controller.selectedItem.value.startTime ?? ''} - ${controller.selectedItem.value.endTime ?? ''}',
                        style: Get.textTheme.bodyMedium?.copyWith(color: Palette.gray800),
                      ),
                    ),
                  ],
                ),
                const Gap(4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 34, color: Palette.deYork600),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        controller.selectedItem.value.mapLocation ?? 'Location not available',
                        style: Get.textTheme.bodyMedium?.copyWith(color: Palette.gray800),
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
            _buildAttendanceButton('Mark Attendance', Palette.deYork600, controller.checkIn, controller.isWithinRadius.value),
          const Gap(12),
          if (controller.selectedItem.value.attendance?.checkOutTime == null)
            _buildAttendanceButton('Complete Attendance', Palette.deYork600, controller.checkOut, controller.isWithinRadius.value),
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
