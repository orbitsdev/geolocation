import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/custom_tab_indicator.dart';
import 'package:geolocation/core/globalwidget/custom_tab_indicator2.dart';
import 'package:geolocation/core/globalwidget/icon_with_badge.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/tittle_with_icon_action.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/localdata/sample_data.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/event/event_page.dart';
import 'package:geolocation/features/home/all_tab.dart';
import 'package:geolocation/features/home/attendance_tab.dart';
import 'package:geolocation/features/home/collections_tab.dart';
import 'package:geolocation/features/home/dashboard/widget/event_time_line_tile.dart';
import 'package:geolocation/features/home/dashboard/widget/event_time_line_tile_active.dart';
import 'package:geolocation/features/home/dashboard/widget/member_user_card.dart';
import 'package:geolocation/features/home/dashboard/widget/over_all_card.dart';
import 'package:geolocation/features/home/dashboard/widget/profile_section.dart';
import 'package:geolocation/features/home/files_tab.dart';
import 'package:geolocation/features/home/posts_tab.dart';
import 'package:geolocation/core/globalwidget/scroll_container.dart';
import 'package:geolocation/features/notification/notification_page.dart';
import 'package:geolocation/features/post/post_page.dart';
import 'package:geolocation/features/post/widget/post_card.dart';
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
          SliverGap(Get.size.height * 0.05),
          ProfileSection(),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: ToSliver(child: Text('Dashboard', style: Get.textTheme.headlineLarge
            ?.copyWith(
              fontWeight: FontWeight.bold
            ),)),
          ),
          SliverGap(16),
          ToSliver(child: OverAllCard(icon: FaIcon(FontAwesomeIcons.users, size: 34,), title: 'Members',)),          
          ToSliver(child: OverAllCard(icon: FaIcon(FontAwesomeIcons.solidFolder, size: 34,), title: 'Collections',)),
          ToSliver(child: OverAllCard(icon: FaIcon(FontAwesomeIcons.bullhorn, size: 34,), title: 'Posts',)),
          ToSliver(child: OverAllCard(icon: FaIcon(FontAwesomeIcons.calendarCheck, size: 34,), title: 'Events',)),
          ToSliver(child: OverAllCard(icon: FaIcon(FontAwesomeIcons.tasks, size: 34,), title: 'Tasks',)),
          ToSliver(child: OverAllCard(icon: FaIcon(FontAwesomeIcons.folderOpen, size: 34,), title: 'Files',)),
          
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            sliver: ToSliver(
              child: Container(
                height: 90, // Explicit height

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return MemberUserCard();
                  },
                ),
              ),
            ),
          ),
          SliverGap(24),
          ToSliver(
              child: TittleWithIconAction(
            title: 'Upcoming Events',
            onTap: () {
              Get.to(() => EventPage(), transition: Transition.cupertino);
            },
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
                  if (index == 0) {
                    return EventTimeLineTileActive();
                  } else {
                    return EventTimeLineTile();
                  }
                }),
          ),

          SliverGap(24),
          ToSliver(
              child: TittleWithIconAction(
            title: 'Recent Post',
            onTap: () {
              Get.to(() => PostPage(), transition: Transition.cupertino);
            },
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
                  return PostCard();
                  })
          ),

          // SliverGap(24),
          // SliverPadding(
          //   padding: const EdgeInsets.only(left: 16),
          //   sliver: ToSliver(
          //     child: TabBar(
          //         padding: EdgeInsets.all(0),
          //         tabAlignment: TabAlignment.start,
          //         dividerColor: Colors.transparent,
          //         labelStyle: Get.textTheme.bodyLarge
          //             ?.copyWith(fontWeight: FontWeight.bold),
          //         isScrollable: true,
          //         controller: _tabController,
          //         labelColor: Palette.DARK_PRIMARY,
          //         unselectedLabelStyle: Get.textTheme.bodyMedium
          //             ?.copyWith(color: Palette.BLACK_SIMI),
          //         unselectedLabelColor: Palette.LIGHT_PRIMARY,
          //         indicatorSize: TabBarIndicatorSize.tab,
          //         // indicator: BoxDecoration(
          //         //   borderRadius: BorderRadius.circular(4),
          //         //   gradient: LinearGradient(
          //         //     begin: Alignment.topCenter,
          //         //     end: Alignment.bottomCenter,
          //         //     colors: [
          //         //       Palette.PRIMARY,
          //         //       Palette.DARK_PRIMARY,
          //         //     ],
          //         //   ),
          //         // ),
          //         tabs: [
          //           Tab(
          //             child: Text(
          //               "All".toUpperCase(),
          //             ),
          //           ),
          //           Tab(
          //             child: Text(
          //               "ATTENDANCE".toUpperCase(),
          //             ),
          //           ),
          //           Tab(
          //             child: Text(
          //               "POST".toUpperCase(),
          //             ),
          //           ),
          //           Tab(
          //             child: Text(
          //               "COLLECTIONS".toUpperCase(),
          //             ),
          //           ),
          //           Tab(
          //             child: Text(
          //               "FILES".toUpperCase(),
          //             ),
          //           ),
          //         ]),
          //   ),
          // ),

          // SliverFillRemaining(
          //     child: Container(
          //   height: 300,
          //   child: TabBarView(
          //     controller: _tabController,
          //     children: [
          //       AllTab(),
          //       AttendanceTab(),
          //       PostsTab(),
          //       CollectionsTab(),
          //       FilesTab(),
          //     ],
          //   ),
          // ))

          SliverGap(Get.size.height * 0.05)
        ],
      ),
    );
  }
}
