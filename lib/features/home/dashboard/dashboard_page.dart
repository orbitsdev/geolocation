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
import 'package:geolocation/core/theme/game_pallete.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/collections/collection_page.dart';
import 'package:geolocation/features/councils/controller/council_controller.dart';
import 'package:geolocation/features/councils/pages/council_list_page.dart';
import 'package:geolocation/features/event/event_page.dart';
import 'package:geolocation/features/file/file_page.dart';
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
import 'package:geolocation/features/council_positions/pages/council_member_position_list_page.dart';
import 'package:geolocation/features/notification/notification_page.dart';
import 'package:geolocation/features/post/post_page.dart';
import 'package:geolocation/features/post/widget/post_card.dart';
import 'package:geolocation/features/task/member_task_page.dart';
import 'package:geolocation/features/task/task_page.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:timeline_tile/timeline_tile.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  final councilController = Get.find<CouncilController>();
  final authcontroller = Get.find<AuthController>();
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    loadData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {}
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    councilController.fetchCouncils();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.BACKGROUND,
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => loadData(),
        child: CustomScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          slivers: [
            SliverGap(Get.size.height * 0.05),
            ProfileSection(),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: ToSliver(
                  child: Text(
                'Dashboard',
                style: Get.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              )),
            ),
            SliverGap(16),
           GetBuilder<AuthController>(
  builder: (authController) {
    return authController.user.value.isAdmin() ? ToSliver(
      child: RippleContainer(
        onTap: () => Get.to(() => CouncilListPage(), transition: Transition.cupertino),
        child: GetBuilder<CouncilController>(
          builder: (councilController) {
            return OverAllCard(
              icon: FaIcon(FontAwesomeIcons.users, size: 34, color: Colors.white), // Members
              title: 'Councils',
              // Dynamic count using the observable list length
              count: '${councilController.councils.length}', // Dynamic council count
            );
          },
        ),
      ),
    ) : ToSliver(child: Container());
  },
),

          
             Obx((){
              return  !authcontroller.user.value.isAdmin() ?  MultiSliver(children: [
                ToSliver(
                    child: RippleContainer(
                  onTap: () => Get.to(() => MemberTaskPage(),
                      transition: Transition.cupertino),
                  child: OverAllCard(
                    icon: FaIcon(FontAwesomeIcons.tasks,
                        size: 34, color: Colors.white), // Tasks
                    title: 'Tasks',
                    count: '39',
                  ),
                )),
                ToSliver(
                    child: RippleContainer(
                  onTap: () =>
                      Get.to(() => PostPage(), transition: Transition.cupertino),
                  child: OverAllCard(
                    icon: FaIcon(FontAwesomeIcons.bullhorn,
                        size: 34, color: Colors.white), // Posts
                    title: 'Posts',
                    count: '58',
                  ),
                )),
                ToSliver(
                    child: RippleContainer(
                  onTap: () => Get.to(() => CollectionPage(),
                      transition: Transition.cupertino),
                  child: OverAllCard(
                    icon: FaIcon(FontAwesomeIcons.solidFolder,
                        size: 34, color: Colors.white), // Collections
                    title: 'Collections',
                    count: '180',
                  ),
                )),
                ToSliver(
                    child: RippleContainer(
                  onTap: () =>
                      Get.to(() => EventPage(), transition: Transition.cupertino),
                  child: OverAllCard(
                    icon: FaIcon(FontAwesomeIcons.calendarCheck,
                        size: 34, color: Colors.white), // Events
                    title: 'Events',
                    count: '16',
                  ),
                )),
                ToSliver(
                    child: RippleContainer(
                  onTap: () =>
                      Get.to(() => FilesPage(), transition: Transition.cupertino),
                  child: OverAllCard(
                    icon: FaIcon(FontAwesomeIcons.folderOpen,
                        size: 34, color: Colors.white), // Files
                    title: 'Files',
                    count: '87',
                  ),
                )),
              ]) : ToSliver(child: Container());
            }
              
            ),
            //     ToSliver(child: RippleContainer(
            // onTap: ()=> Get.to(()=> CouncilPositionListPage(),transition: Transition.cupertino),
            // child: OverAllCard(
            //   icon: FaIcon(FontAwesomeIcons.users, size: 34, color: Colors.white), // Members
            //   title: 'Members',
            //   count: '242',
            // ),
            //     )),

            // SliverPadding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 16,
            //   ),
            //   sliver: ToSliver(
            //     child: Container(
            //       height: 90, // Explicit height

            //       child: ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         itemCount: 10,
            //         itemBuilder: (context, index) {
            //           return MemberUserCard();
            //         },
            //       ),
            //     ),
            //   ),
            // ),
            // SliverGap(24),
            // ToSliver(
            //     child: TittleWithIconAction(
            //   title: 'Upcoming Events',
            //   onTap: () {
            //     Get.to(() => EventPage(), transition: Transition.cupertino);
            //   },
            // )),

            // SliverPadding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 16,
            //   ),
            //   sliver: SliverAlignedGrid.count(

            //       //  SliverMasonryGrid.count(
            //       crossAxisSpacing: 0,
            //       mainAxisSpacing: 6,
            //       itemCount: 3,
            //       // childCount: sampleProductCategory.length,
            //       crossAxisCount: 1,
            //       itemBuilder: (context, index) {
            //         if (index == 0) {
            //           return EventTimeLineTileActive();
            //         } else {
            //           return EventTimeLineTile();
            //         }
            //       }),
            // ),

            // SliverGap(24),
            // ToSliver(
            //     child: TittleWithIconAction(
            //   title: 'Recent Post',
            //   onTap: () {
            //     Get.to(() => PostPage(), transition: Transition.cupertino);
            //   },
            // )),

            // SliverPadding(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: 16,
            //   ),
            //   sliver: SliverAlignedGrid.count(

            //       //  SliverMasonryGrid.count(
            //       crossAxisSpacing: 0,
            //       mainAxisSpacing: 6,
            //       itemCount: 3,
            //       // childCount: sampleProductCategory.length,
            //       crossAxisCount: 1,
            //       itemBuilder: (context, index) {
            //         return PostCard();
            //         })
            // ),

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
      ),
    );
  }
}
