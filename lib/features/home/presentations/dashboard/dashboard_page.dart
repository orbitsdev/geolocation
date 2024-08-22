import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/shared/custom_tab_indicator.dart';
import 'package:geolocation/core/shared/custom_tab_indicator2.dart';
import 'package:geolocation/core/shared/icon_with_badge.dart';
import 'package:geolocation/core/shared/images/online_image.dart';
import 'package:geolocation/core/shared/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/home/presentations/all_tab.dart';
import 'package:geolocation/features/home/presentations/attendance_tab.dart';
import 'package:geolocation/features/home/presentations/collections_tab.dart';
import 'package:geolocation/features/home/presentations/dashboard/widget/event_time_line_tile.dart';
import 'package:geolocation/features/home/presentations/dashboard/widget/event_time_line_tile_active.dart';
import 'package:geolocation/features/home/presentations/files_tab.dart';
import 'package:geolocation/features/home/presentations/posts_tab.dart';
import 'package:geolocation/features/home/presentations/scroll_container.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          print('end');
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.BACKGROUND,
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          ToSliver(
            child: Container(
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(),
              decoration: BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Gap(Get.size.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              // border: Border.all(
                              //     width: 2, color: Palette.LIGHT_PRIMARY)
                            ),
                            height: 60,
                            width: 60,
                            child: OnlineImage(
                              imageUrl: 'https://i.pravatar.cc/300',
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          Gap(16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi! Angela',
                                style: Get.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.BLACK),
                              ),
                              Text(
                                '2024-2024',
                                style: Get.textTheme.bodyMedium
                                    ?.copyWith(color: Palette.BLACK),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Palette.LIGH_BACKGROUND,
                              // border: Border.all(
                              //     width: 1, color: Palette.LIGHT_PRIMARY),
                              borderRadius: BorderRadius.circular(60)),
                          child: Container(
                              height: 60,
                              width: 60,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Center(
                                      child: HeroIcon(HeroIcons.bell,
                                          color: Palette.BLACK)),
                                  Positioned(
                                    top: -4,
                                    right: 4,
                                    child: Container(
                                      padding: EdgeInsets.all(2),
                                      // color: Colors.red,
                                      decoration: BoxDecoration(
                                        // border: Border.all(color: Colors.white),
                                        color: Palette.ORANGE_DARK,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 14,
                                        minHeight: 14,
                                      ),
                                      child: Text(
                                        '0',
                                        style: Get.textTheme.bodySmall
                                            ?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              )))
                    ],
                  ),
                ],
              ),
            ),
          ),
          ToSliver(
              child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Palette.LIGH_BACKGROUND_GREEN,
                  borderRadius: BorderRadius.circular(20)),
              constraints: BoxConstraints(
                minHeight: 120,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Submitted Tasks',
                        style: Get.textTheme.bodyLarge?.copyWith(),
                      ),
                      Gap(4),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '242',
                          style: Get.textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Gap(16),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          children: [
                            Container(
                              height: 14,
                              width: 14,
                              decoration: BoxDecoration(
                                  color: Palette.ORANGE_DARK,
                                  borderRadius: BorderRadius.circular(20)),
                            ),
                            Gap(8),
                            Text(
                              '24 Not Check',
                              style: Get.textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            sliver: ToSliver(
              child: Container(
                height: 60,
                child: Column(
                  children: [
                    Container(
                      height: 60, // Explicit height

                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Palette.ACTIVE),
                                    borderRadius: BorderRadius.circular(60)),
                                margin: EdgeInsets.only(right: 16),
                                height: 60,
                                width: Get.size.width / 6,
                                child: OnlineImage(
                                  imageUrl: 'https://i.pravatar.cc/300',
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              // Text(data)
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverGap(32),
          ToSliver(
              child: Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Text(
              'Upcoming Events',
              style: Get.textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
          )),

          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            sliver: SliverAlignedGrid.count(

                //  SliverMasonryGrid.count(
                crossAxisSpacing: 0,
                mainAxisSpacing: 6,
                itemCount: 3,
                // childCount: sampleProductCategory.length,
                crossAxisCount: 1,
                itemBuilder: (context, index) {
                   return Container(
        height: 160,  // Explicitly set the height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.red,  // Set a color to see the container
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: OnlineImage(imageUrl: 'https://picsum.photos/200/300'),
        ),
      );
                  //   if(index == 0){
                  //   return EventTimeLineTileActive();

                  // }else{

                  //   return EventTimeLineTile();
                  // }

                  //   color: Colors.white,
                  //   child: TimelineTile(
                  //     alignment: TimelineAlign.manual,
                  //     indicatorStyle: IndicatorStyle(
                  //       indicator: Container(),
                  //       // indicator: ClipOval(
                  //       //   child: Container(
                  //       //     color: Palette.LIGHT_BACKGROUND,
                  //       //     child: Center(
                  //       //         child: Icon(
                  //       //       Icons.check,
                  //       //       color: Colors.white,
                  //       //       size: 14,
                  //       //     )),
                  //       //   ),
                  //       // ),
                  //       width: 18,
                  //       height: 18,

                  //     ),
                  //     beforeLineStyle: LineStyle(thickness: 0.5, color: Palette.ORANGE),
                  //     afterLineStyle: LineStyle(thickness: 0.5, color: Palette.ORANGE),
                  //     lineXY: 0.3,
                  //     startChild: Container(
                  //       color: Colors.red,

                  //       constraints: const BoxConstraints(
                  //       ),
                  //       // color: Colors.grey,
                  //       child: Text(
                  //                   'Mar 21, 2024 10:21 AM',
                  //                   style: Get.textTheme.bodySmall?.copyWith(
                  //         // fontSize: 10,
                  //         // fontWeight: FontWeight.bold,
                  //         color: Palette.BLACK_SIMI),
                  //                   textAlign: TextAlign.center,
                  //                 ),
                  //     ),
                  //     endChild: Container(

                  //       padding: EdgeInsets.all(8),

                  //        color: Colors.grey,
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         children: [
                  //           Text(
                  //             'Arrive from general santos',
                  //             style: Get.textTheme.bodySmall!.copyWith(
                  //                 fontSize: 14, fontWeight: FontWeight.w600),
                  //           ),
                  //           Gap(8),
                  //           Text(
                  //             'Arrive from general 273 Store House santos sorting center ',
                  //             style: Get.textTheme.bodySmall!
                  //                 .copyWith(fontSize: 14, height: 0,
                  //           ),),
                  //           Gap(8),
                  //           Text(
                  //             'General Santos',
                  //             style: Get.textTheme.bodySmall!.copyWith(
                  //                 fontSize: 14,

                  //                 fontWeight: FontWeight.w600,
                  //                 fontStyle: FontStyle.italic),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // );
                }),
          ),

          SliverGap(24),
          SliverPadding(
            padding: const EdgeInsets.only(left: 16),
            sliver: ToSliver(
              child: TabBar(
                  padding: EdgeInsets.all(0),
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  labelStyle: Get.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  isScrollable: true,
                  controller: _tabController,
                  labelColor: Palette.DARK_PRIMARY,
                  unselectedLabelStyle: Get.textTheme.bodyMedium
                      ?.copyWith(color: Palette.BLACK_SIMI),
                  unselectedLabelColor: Palette.LIGHT_PRIMARY,
                  indicatorSize: TabBarIndicatorSize.tab,
                  // indicator: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(4),
                  //   gradient: LinearGradient(
                  //     begin: Alignment.topCenter,
                  //     end: Alignment.bottomCenter,
                  //     colors: [
                  //       Palette.PRIMARY,
                  //       Palette.DARK_PRIMARY,
                  //     ],
                  //   ),
                  // ),
                  tabs: [
                    Tab(
                      child: Text(
                        "All".toUpperCase(),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "ATTENDANCE".toUpperCase(),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "POST".toUpperCase(),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "COLLECTIONS".toUpperCase(),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "FILES".toUpperCase(),
                      ),
                    ),
                  ]),
            ),
          ),

          SliverFillRemaining(
              child: Container(
            height: 300,
            child: TabBarView(
              controller: _tabController,
              children: [
                AllTab(),
                AttendanceTab(),
                PostsTab(),
                CollectionsTab(),
                FilesTab(),
              ],
            ),
          ))

          // tab bar or page vew
        ],
      ),
    );
  }
}
