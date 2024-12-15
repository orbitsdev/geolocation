import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/custom_indicator.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/notification_global.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/attendance_page.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/collections/create_or_edit_collection_page.dart';
import 'package:geolocation/features/officers/controller/officer_controller.dart';
import 'package:geolocation/features/officers/officer_all_attendance_page.dart';
import 'package:geolocation/features/officers/officer_all_collection_page.dart';
import 'package:geolocation/features/officers/officer_all_event_page.dart';
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
    OfficerAllEventPage(),
    OfficerAllCollectionPage(),
    OfficerFilesPage(),
     OfficerAllAttendancePage(),
  ];

  final List<Tab> tabs = const [
    Tab(text: 'All'),
    Tab(text: 'Posts'),
    Tab(text: 'Tasks'),
    Tab(text: 'Events'),
    Tab(text: 'Collections'),
    Tab(text: 'Approve Files'),
    Tab(text: 'Attendance'),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this,initialIndex: 6);
    
    tabController.addListener(() {
    switch (tabController.index) {
        case 0:
          //  OfficerController.controller.loadAllPageData();
          break;
        case 1:
            // PostController.controller.loadData();
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
           SliverGap(16),
            OfficerProfileSection(),
          SliverToBoxAdapter(
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    color: Colors.white,
    child: Row(
      children: [
        // Profile Picture
        GetBuilder<AuthController>(
          builder: (authcontroller) {
            return Container(
              width: 40.0,
              height: 40.0,
              child: OnlineImage(imageUrl: authcontroller.user.value.image ??'',borderRadius: BorderRadius.circular(30),),
            );
          }
        ),
        const SizedBox(width: 12.0),

        // Input Placeholder
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Get.to(()=> CreateOrEditCollectionPage(), transition: Transition.cupertino);
             Modal.showCreationModal(); // Open modal
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Text(
                "Collection|Announcement",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12.0),

        // Action Icon (Add New)
        GestureDetector(
          onTap: () {
            Modal.showCreationModal();
            // Get.to(()=> CreateOrEditCollectionPage(), transition: Transition.cupertino);
          },
          child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Palette.GREEN3,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 24.0,
            ),
          ),
        ),
      ],
    ),
  ),
),

        
            // TabBar in SliverPersistentHeader
//           SliverPersistentHeader(
//   pinned: true,
//   delegate: _SliverTabBarDelegate(
//     TabBar(
//              tabAlignment: TabAlignment.start,
//       controller: tabController,
//       isScrollable: true, // Enable horizontal scrolling for tabs
//       labelColor: Colors.white, // Active tab label color
//       unselectedLabelColor: Colors.grey, // Inactive tab label color
//       indicator: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         // borderRadius: BorderRadius.only(
//         //   bottomLeft: Radius.circular(4),
//         //   bottomRight: Radius.circular(4),
//         // ),
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             Palette.GREEN1,
//             Palette.GREEN1,
//           ],
//         ),
//       ),
//       indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
//       indicatorSize: TabBarIndicatorSize.tab,
//       dividerColor: Colors.transparent,
//       overlayColor: MaterialStateProperty.all(Colors.transparent),
//       tabs: tabs.map((tab) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           child: Tab(text: tab.text),
//         );
//       }).toList(),
//     ),
//   ),
// ),




            SliverPersistentHeader(
              // pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                     dividerColor: Palette.LIGHT_BACKGROUND,
              // indicatorSize: TabBarIndicatorSize.label,
              //   indicator: BoxDecoration(
              //     borderRadius: BorderRadius.only(
              //         topLeft: Radius.circular(10),
              //         topRight: Radius.circular(10)),
              //     gradient: LinearGradient(
              //       begin: Alignment.topCenter,
              //       end: Alignment.bottomCenter,
              //       colors: [
              //         Palette.GREEN2,
              //         Palette.GREEN3,
              //       ],
              //     )),
              controller: tabController,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Palette.GREEN3,
              isScrollable: true,
              labelColor: Palette.GREEN3,
              
              tabAlignment: TabAlignment.start,
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
