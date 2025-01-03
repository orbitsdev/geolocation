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
import 'package:geolocation/features/event/model/event.dart';
import 'package:geolocation/features/event/widgets/event_card.dart';
import 'package:geolocation/features/event/widgets/event_card2.dart';
import 'package:geolocation/features/event/widgets/event_card3.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class EventPage extends StatefulWidget {
  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
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
      appBar: AppBar(
        title: Text(
          'Upcoming Events',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Palette.PRIMARY),
            onPressed: () async {
              bool canProceed =
                  await controller.checkLocationServicesAndPermissions();
              if (canProceed) {
                Get.to(() => CreateEventPage());
              } else {
                Modal.showToast(
                    msg:
                        'Location services are disabled or unavailable. Please enable location services to proceed.');
              }
            },
          ),
        ],
      ),
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
                      ? ToSliver(
                          child: Center(child: CircularProgressIndicator()))
                      : controller.events.isNotEmpty
                          ? SliverAlignedGrid.count(
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 16,
                              itemCount: controller.events.length,
                              crossAxisCount: 1,
                              itemBuilder: (context, index) {
                                Event event = controller.events[index];
                                return EventCard3(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 0),
                                  width: Get.size.width,
                                  event: event, onView: (){ 
                                     Modal.showEventOptions(
                                      event: event,
                                      onViewDetails: () async {
                                      

                                        bool canProceed = await controller
                                            .checkLocationServicesAndPermissions();
                                        if (canProceed) {
                                          controller.viewEvent(event);
                                        } else {
                                          Modal.showToast(
                                              msg:
                                                  'Location services are disabled or unavailable. Please enable location services to proceed.');
                                        }

                                        // AttendanceController.controller.testLoad(event);
                                        // AttendanceController.controller.selectAndNavigateToAttendancePage(event);
                                      },
                                      onViewAttendance: () {
                                        if (event.id != null) {

                                          AttendanceController.controller.navigateToEventAttendancePage(event: event);
                                          // Get.back();
                                          // AttendanceController.controller
                                          //     .selectAndNavigateToAttendanceRecord(
                                          //         event);
                                        }
                                      },
                                      onUpdateEvent: () async  {
                                        if (event.id != null)   {
                                       
                                            bool canProceed = await controller
                                            .checkLocationServicesAndPermissions();
                                        if (canProceed) {
                                        controller
                                              .selectItemAndNavigateToUpdatePage(
                                                  event);
                                        } else {
                                          Modal.showToast(
                                              msg:
                                                  'Location services are disabled or unavailable. Please enable location services to proceed.');
                                        }
                                          
                                        }
                                      },
                                      onDeleteEvent: () {
                                        if (event.id != null) {
                                        

                                          controller.delete(event.id!);
                                        }
                                      },
                                    );
                                },);
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
                    ToSliver(
                      child: const Center(child: CircularProgressIndicator()),
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
