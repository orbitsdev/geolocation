import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/globalwidget/empty_state.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/attendance_full_details_page.dart';
import 'package:geolocation/features/attendance/controller/attendance_controller.dart';
import 'package:geolocation/features/attendance/model/attendance.dart';

import 'package:geolocation/features/attendance/widgets/attendance_card.dart';
import 'package:geolocation/features/attendance/widgets/attendance_card_shimmer.dart';
import 'package:geolocation/features/event/model/event_attendance.dart';
import 'package:get/get.dart';

class EventAttendancePage extends StatefulWidget {
  final int eventId;

  const EventAttendancePage({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventAttendancePage> createState() => _EventAttendancePageState();
}

class _EventAttendancePageState extends State<EventAttendancePage> {
  final AttendanceController controller = Get.find<AttendanceController>();
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.eventAttendanceList.isEmpty) {
        controller.loadEventAttendance(widget.eventId);
      }

      scrollController.addListener(() async {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent - 200 &&
            !controller.isScrollLoadingEventAttendance.value &&
            controller.hasMoreEventAttendance.value) {
          controller.loadEventAttendanceOnScroll(widget.eventId);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.gray100,
      appBar: AppBar(
        title:  GetBuilder<AttendanceController>(
          builder: (controller) {
            return Text(
              "Event Attendance (${controller.eventAttendanceList.length})",
              style: TextStyle(color: Palette.gray900, fontWeight: FontWeight.bold),
            );
          }
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Palette.gray900),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => controller.loadEventAttendance(widget.eventId),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<AttendanceController>(
            builder: (controller) {
              return CustomScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  controller.isLoadingEventAttendance.value
                      ? SliverMasonryGrid.count(
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          crossAxisCount: 1,
                          childCount: 10,
                          itemBuilder: (context, index) {
                            return const AttendanceCardShimmer();
                          },
                        )
                      : controller.eventAttendanceList.isNotEmpty
                          ? SliverMasonryGrid.count(
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              crossAxisCount: 1,
                              childCount: controller.eventAttendanceList.length,
                              itemBuilder: (context, index) {
                                Attendance attendance =
                                    controller.eventAttendanceList[index];
                                return RippleContainer(
                                  onTap: () {
                                    Get.to(
                                      () => AttendanceFullDetailsPage(
                                        attendance: attendance,
                                      ),
                                      transition: Transition.cupertino,
                                    );
                                  },
                                  child: AttendanceCard(attendance: attendance),
                                );
                              },
                            )
                          :  SliverToBoxAdapter(
                              child: EmptyState()),
                  if (controller.isScrollLoadingEventAttendance.value)
                    SliverMasonryGrid.count(
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      crossAxisCount: 1,
                      childCount: 10,
                      itemBuilder: (context, index) {
                        return const AttendanceCardShimmer();
                      },
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 60), // Additional spacing at the bottom
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
