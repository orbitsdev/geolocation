import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/attendance_page.dart';
import 'package:geolocation/features/attendance/controller/attendance_controller.dart';
import 'package:geolocation/features/attendance/make_attendace_page.dart';
import 'package:geolocation/features/attendance/model/attendance.dart';
import 'package:geolocation/features/attendance/widgets/attendance_card.dart';
import 'package:geolocation/features/attendance/widgets/attendance_card_shimmer.dart';
import 'package:geolocation/features/collections/collection_details_page.dart';
import 'package:geolocation/features/collections/controller/collection_controller.dart';
import 'package:geolocation/features/collections/create_or_edit_collection_page.dart';
import 'package:geolocation/features/collections/model/collection.dart';
import 'package:geolocation/features/collections/widgets/collection_card.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:geolocation/features/event/create_event_page.dart';
import 'package:geolocation/features/event/event_details_page.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:geolocation/features/event/model/event_attendance.dart';
import 'package:geolocation/features/event/widgets/event_card.dart';
import 'package:geolocation/features/event/widgets/event_card2.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class OfficerAllAttendancePage extends StatefulWidget {
  const OfficerAllAttendancePage({Key? key}) : super(key: key);

  @override
  State<OfficerAllAttendancePage> createState() =>
      _OfficerAllAttendancePageState();
}

class _OfficerAllAttendancePageState extends State<OfficerAllAttendancePage> {
  final AttendanceController controller = Get.find<AttendanceController>();
  final ScrollController newScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.attendances.isEmpty) {
      controller.loadMyAttendance();
       
      }

      // Debounce scroll listener
      newScrollController.addListener(() async {
        if (newScrollController.position.pixels >=
                newScrollController.position.maxScrollExtent - 200 &&
            !controller.isScrollLoading.value &&
            controller.hasData.value) {
          controller.loadMyAttendanceOnScroll();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.FBG,
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => controller.loadMyAttendance(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<AttendanceController>(
            builder: (controller) {
              return CustomScrollView(
                controller: newScrollController,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // Add spacing at the top

                  // Main content
                  controller.isPageLoading.value
                      ? SliverMasonryGrid.count(
                              crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                              crossAxisCount: 1,
                              childCount: 10,
                              itemBuilder: (context, index) {
                             
                                return AttendanceCardShimmer();
                              },
                            )
                      : controller.attendances.isNotEmpty
                          ? SliverMasonryGrid.count(
                              crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                              crossAxisCount: 1,
                              childCount: controller.attendances.length,
                              itemBuilder: (context, index) {
                                Attendance attendance =
                                    controller.attendances[index];
                                return AttendanceCard(attendance: attendance);
                              },
                            )
                          : const SliverToBoxAdapter(
                              child: Center(
                                child: Text(
                                  'No Attenance found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),

                  // Scroll-loading indicator
                  if (controller.isScrollLoading.value)
                    SliverMasonryGrid.count(
                              crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                              crossAxisCount: 1,
                              childCount: 10,
                              itemBuilder: (context, index) {
                             
                                return AttendanceCardShimmer();
                              },
                            ),

                  SliverGap(Get.size.height * 0.10)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
