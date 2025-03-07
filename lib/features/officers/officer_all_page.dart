import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/controller/attendance_controller.dart';
import 'package:geolocation/features/attendance/make_attendace_page.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:geolocation/features/event/model/event.dart';
import 'package:geolocation/features/event/widgets/event_card2.dart';
import 'package:geolocation/features/event/widgets/event_card3.dart';
import 'package:geolocation/features/event/widgets/shimmer_event_card.dart';
import 'package:geolocation/features/officers/controller/officer_controller.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/post/create_or_edit_post_page.dart';
import 'package:geolocation/features/post/post_details_page.dart';
import 'package:geolocation/features/post/widget/post_card.dart';
import 'package:geolocation/features/post/widget/shimmer_post_card.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../post/model/post.dart';

class OfficerAllPage extends StatefulWidget {
  const OfficerAllPage({Key? key}) : super(key: key);

  @override
  State<OfficerAllPage> createState() => _OfficerAllPageState();
}

class _OfficerAllPageState extends State<OfficerAllPage> {
  var eventController = Get.find<EventController>();

  final ScrollController newScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await eventController.loadAllPageData();

      newScrollController.addListener(() async {
        if (newScrollController.position.pixels >=
            newScrollController.position.maxScrollExtent - 200) {
          PostController.controller.loadDataOnScroll();
        }
      });
    });

    print('all page called');
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () => eventController.loadAllPageData(),
      child: CustomScrollView(
        controller: newScrollController,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          GetBuilder<EventController>(
            builder: (econtroller) {
              return MultiSliver(
                children: [
                  SliverGap(16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Latest Events',
                      style: Get.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SliverGap(8),
                  if (econtroller.isLoading.value == true)
                    ToSliver(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        height:
                            240, // Matches the EventCard3 height with padding
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return ShimmerEventCard3();
                          },
                        ),
                      ),
                    ),
                  ToSliver(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      height: 240, // Matches the EventCard3 height with padding
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: econtroller.events.length,
                        itemBuilder: (context, index) {
                          Event event = econtroller.events[index];
                          return EventCard3(
                            event: event,
                            onView: () async {
                              Modal.showEventActionModal(
                                onViewEvent: () async {
                                  Get.back();

                                  bool canProceed = await econtroller
                                      .checkLocationServicesAndPermissions();
                                  if (canProceed) {
                                    econtroller.viewEvent(event);
                                  } else {
                                    Modal.showToast(
                                        msg:
                                            'Location services are disabled or unavailable. Please enable location services to proceed.');
                                  }
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
                                onMakeAttendance: () async {
                                  bool canProceed = await econtroller
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
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SliverGap(16),
          GetBuilder<PostController>(builder: (postcontroller) {
            return MultiSliver(children: [
              if (postcontroller.isLoading.value == true)
                SliverAlignedGrid.count(
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    itemCount: 10,
                    crossAxisCount: 1,
                    itemBuilder: (context, index) {
                      return ShimmerPostCard();
                    }),
              SliverAlignedGrid.count(
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 16,
                  itemCount: postcontroller.posts.length,
                  crossAxisCount: 1,
                  itemBuilder: (context, index) {
                    Post post = postcontroller.posts[index];
                    return RippleContainer(
                      onTap: () => Get.to(
                          () => PostDetailsPage(
                                post: post,
                              ),
                          transition: Transition.cupertino),
                      child: PostCard(
                        onView: () {},
                        onEdit: () {
                          postcontroller
                              .selectItemAndNavigateToUpdatePage(post);
                        },
                        onDelete: () {
                          postcontroller.delete(post.id as int);
                        },
                        post: post,
                      ),
                    );
                  }),
              if (postcontroller.isScrollLoading.value)
                SliverAlignedGrid.count(
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    itemCount: 10,
                    crossAxisCount: 1,
                    itemBuilder: (context, index) {
                      return ShimmerPostCard();
                    }),
            ]);
          }),
        ],
      ),
    );
  }
}
