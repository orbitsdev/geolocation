import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/custom_indicator.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/notification_global.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/attendance_page.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/officers/officer_all_page.dart';
import 'package:geolocation/features/officers/officer_files_page.dart';
import 'package:geolocation/features/officers/officer_post_page.dart';
import 'package:geolocation/features/officers/officer_task_page.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/profile/widgets/officer_profile_section.dart';
import 'package:get/get.dart';

class OfficerHomePage extends StatefulWidget {
  const OfficerHomePage({Key? key}) : super(key: key);

  @override
  State<OfficerHomePage> createState() => _OfficerHomePageState();
}

class _OfficerHomePageState extends State<OfficerHomePage> with SingleTickerProviderStateMixin {

  var postController = Get.find<PostController>();
  late TabController tabController;
    final ScrollController newScrollController = ScrollController();

  final List<Widget> pages = [
    OfficerAllPage(),
    OfficerPostPage(),
    OfficerTaskPage(),
    OfficerFilesPage(),
    AttendancePage(),
  ];

  final List<Tab> tabs = const [
    Tab(text: 'All'),
    Tab(text: 'Posts'),
    Tab(text: 'Tasks'),
    Tab(text: 'Files'),
    Tab(text: 'Attendance'),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this,initialIndex: 0);
    
    tabController.addListener(() {
    switch (tabController.index) {
        case 0:
          // postController.loadData();
          break;
        case 1:
          print('Load Posts');
          // Call your function for posts
          break;
        case 2:
          print('Load Attendance');
          // Call your function for attendance
          break;
        case 3:
          print('Load Tasks');
          // Call your function for tasks
          break;
        case 4:
          print('Load Files');
          // Call your function for files
          break;
        default:
          break;
      }
  });

  //  newScrollController.addListener(() async {
  //       if (newScrollController.position.pixels >=
  //           newScrollController.position.maxScrollExtent - 200) {
  //             print('caleed------------------ON');
  //         // PostController.controller.loadDataOnScroll();
  //       }
  //     });



  }
  Future<void> refreshCurrentTab() async {
  switch (tabController.index) {
    case 0:
      print('DA');
      // await postController.loadData();
      break;
    case 1:
      print('Refresh Posts');
      // Call your refresh logic for posts
      break;
    case 2:
      print('Refresh Attendance');
      // Call your refresh logic for attendance
      break;
    case 3:
      print('Refresh Tasks');
      // Call your refresh logic for tasks
      break;
    case 4:
      print('Refresh Files');
      // Call your refresh logic for files
      break;
    default:
      break;
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh:refreshCurrentTab,
        child: CustomScrollView(
          controller: newScrollController,
          physics: const  NeverScrollableScrollPhysics(),
          slivers: [
            // Profile Section
            OfficerProfileSection(),
        
            // TabBar in SliverPersistentHeader
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                     dividerColor: Colors.transparent,
              indicator: CustomUnderlineTabIndicator(
                color: Palette.GREEN3,
              ),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Palette.GREEN3,
              isScrollable: true,
              labelColor: Palette.GREEN3,
              tabAlignment: TabAlignment.start,
              controller: tabController,
              unselectedLabelStyle: Get.textTheme.bodyMedium!.copyWith(
                height: 0,
              ),
              labelStyle: Get.textTheme.bodyLarge!.copyWith(
                height: 0,
              ),
                  tabs: tabs,
                ),
              ),
            ),
        
            // TabBarView Content
            SliverFillRemaining(
              child: TabBarView(
                controller: tabController,
                children: pages,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
