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
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:geolocation/features/event/create_event_page.dart';
import 'package:geolocation/features/event/event_details_page.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:geolocation/features/event/widgets/event_card.dart';
import 'package:geolocation/features/event/widgets/event_card2.dart';
import 'package:geolocation/features/event/widgets/event_card3.dart';
import 'package:geolocation/features/event/widgets/shimmer_event_card.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class OfficerAllEventPage extends StatefulWidget {
  @override
  State<OfficerAllEventPage> createState() => _OfficerAllEventPageState();
}

class _OfficerAllEventPageState extends State<OfficerAllEventPage> {
  final EventController controller = Get.find<EventController>();
  final ScrollController newScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {

    if (controller.events.isEmpty) {
    controller.loadEvents();
    }

    newScrollController.addListener(() async {
      if (newScrollController.position.pixels >=
          newScrollController.position.maxScrollExtent - 200) {
        controller.loadOnScroll();
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
        onRefresh: () => controller.loadEvents(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GetBuilder<EventController>(
            builder: (controller) {
              return CustomScrollView(
                controller: newScrollController,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                 SliverGap(8),
controller.isLoading.value
    ? SliverAlignedGrid.count(
        crossAxisSpacing: 8,
        mainAxisSpacing: 16,
        itemCount: 10,
        crossAxisCount: 1, // Ensure it spans full width
        itemBuilder: (context, index) {
          return ShimmerEventCard3(
            width: Get.size.width, // Adjust for padding
          );
        },
      )
    
                      : controller.events.isNotEmpty
                          ? SliverAlignedGrid.count(
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 16,
                              itemCount: controller.events.length,
                              crossAxisCount: 1,
                              itemBuilder: (context, index) {
                                Event event = controller.events[index];
                                return EventCard3(
                                  width: Get.size.width,
                            event: event,
                            onView: () async {
                              Modal.showEventActionModal(
                                onViewEvent: () async {
                                  Get.back();

                                  bool canProceed = await controller
                                      .checkLocationServicesAndPermissions();
                                  if (canProceed) {
                                    controller.viewEvent(event);
                                  } else {
                                    Modal.showToast(
                                        msg:
                                            'Location services are disabled or unavailable. Please enable location services to proceed.');
                                  }
                                },
                                onViewAttendance: () {
                                  if (event.id != null) {

                                          AttendanceController.controller.navigateToEventAttendancePage(event: event);
                                         
                                        }
                                },
                                onMakeAttendance: () async {
                                  bool canProceed = await controller
                                      .checkLocationServicesAndPermissions();
                                  if (canProceed) {
                                    Get.to(() => MakeAttendancePage(),
                                        arguments: {'event': event},
                                        transition: Transition.cupertino);
                                  } else {
                                    Modal.showToast(
                                        msg:
                                            'Location services are disabled or unavailable. Please enable location services to proceed.');
                                  }
                                  // Navigate to Make Attendance Page
                                  // Get.to(() => MakeAttendancePage(), transition: Transition.cupertino);
                                },
                              );
                            },
                          );
                              
                              },
                            )
                          : ToSliver(
                              child: Center(
                                child: Text(
                                  'No events found',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              ),
                            ),
                  if (controller.isScrollLoading.value)
                    SliverAlignedGrid.count(
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 16,
                              itemCount: controller.events.length,
                              crossAxisCount: 10,
                              itemBuilder: (context, index) {
                               
                                return ShimmerEventCard3(
            width: Get.size.width, // Adjust for padding
          );
                              
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
