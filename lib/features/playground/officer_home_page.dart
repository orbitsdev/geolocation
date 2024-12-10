// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:geolocation/core/globalwidget/sliver_gap.dart';
// import 'package:geolocation/features/home/dashboard/widget/profile_section.dart';
// import 'package:geolocation/features/post/controller/post_controller.dart';
// import 'package:geolocation/features/post/model/post.dart';
// import 'package:geolocation/features/post/widget/post_widget.dart';
// import 'package:get/get.dart';
// import 'package:sliver_tools/sliver_tools.dart';

// class OfficerHomePage extends StatefulWidget {
//   const OfficerHomePage({Key? key}) : super(key: key);

//   @override
//   State<OfficerHomePage> createState() => _OfficerHomePageState();
// }

// class _OfficerHomePageState extends State<OfficerHomePage>
//     with SingleTickerProviderStateMixin {
//   final PostController controller = Get.find<PostController>();
//   final ScrollController newScrollController = ScrollController();

//   late TabController tabController;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize TabController
//     tabController = TabController(length: 4, vsync: this);

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       controller.loadData();

//       newScrollController.addListener(() async {
//         if (newScrollController.position.pixels >=
//             newScrollController.position.maxScrollExtent - 200) {
//           controller.loadDataOnScroll();
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () => controller.loadData(),
//           child: CustomScrollView(
//             controller: newScrollController,
//             slivers: [
//               ProfileSection(),
//                SliverGap(24),

//               // Tabs
//               SliverPersistentHeader(
//                 // pinned: true,
//                 // floating: false,
//                 delegate: _SliverTabBarDelegate(
//                   TabBar(
//                     controller: tabController,
//                     labelColor: Colors.black,
//                     unselectedLabelColor: Colors.grey,
//                     indicatorColor: Theme.of(context).primaryColor,
//                     tabs: const [
//                       Tab(text: 'All'),
//                       Tab(text: 'Attendance'),
//                       Tab(text: 'Collections'),
//                       Tab(text: 'Files'),
//                     ],
//                   ),
//                 ),
//               ),

//               // Tab content
//               SliverToBoxAdapter(
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.8,
//                   child: TabBarView(
//                     controller: tabController,
//                     children: [
//                       // Tab 1: All posts
//                       _buildPostsList(),
//                       // Tab 2: Attendance
//                       Center(
//                         child: Text(
//                           'Attendance Section',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                       // Tab 3: Collections
//                       Center(
//                         child: Text(
//                           'Collections Section',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                       // Tab 4: Files
//                       Center(
//                         child: Text(
//                           'Files Section',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // Helper to build the "All" posts list
//   Widget _buildPostsList() {
//     return GetBuilder<PostController>(
//       builder: (postcontroller) {
//         return ListView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: postcontroller.posts.length,
//           itemBuilder: (context, index) {
//             Post post = postcontroller.posts[index];
//             return PostWidget(
//               post: post,
//               onEdit: () {
//                 // controller.selectItemAndNavigateToUpdatePage(post);
//               },
//               onDelete: () async {
//                 // controller.delete(post.id!);
//               },
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     tabController.dispose();
//     newScrollController.dispose();
//     super.dispose();
//   }
// }

// // Delegate for SliverPersistentHeader to make the TabBar sticky
// class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar tabBar;

//   _SliverTabBarDelegate(this.tabBar);

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: Colors.white,
//       child: tabBar,
//     );
//   }

//   @override
//   double get maxExtent => tabBar.preferredSize.height;

//   @override
//   double get minExtent => tabBar.preferredSize.height;

//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return true;
//   }
// }


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/home/all_tab.dart';
import 'package:geolocation/features/home/attendance_tab.dart';
import 'package:geolocation/features/home/collections_tab.dart';
import 'package:geolocation/features/home/dashboard/widget/profile_section.dart';
import 'package:geolocation/features/home/files_tab.dart';
import 'package:geolocation/features/home/posts_tab.dart';

import 'package:get/get.dart';
class OfficerHomePage extends StatefulWidget {
  const OfficerHomePage({ Key? key }) : super(key: key);

  @override
  _OfficerHomePageState createState() => _OfficerHomePageState();
}


class _OfficerHomePageState extends State<OfficerHomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    // Add a listener to detect tab index changes
    _tabController.addListener(() {
      // Ensure the listener reacts only when the tab has finished changing
      if (_tabController.index != _tabController.previousIndex) {
        print('Tab changed to index: ${_tabController.index}');
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() {
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          print('End of Scroll');
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            ProfileSection(),
            SliverGap(24),
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
                                          width: 4, color: Palette.PRIMARY),
                                      borderRadius: BorderRadius.circular(60)),
                                  margin: EdgeInsets.only(right: 16),
                                  height: 60,
                                  width: 60,
                                  child: OnlineImage(
                                    imageUrl: 'https://picsum.photos/200/300',
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
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
            SliverGap(24),
            SliverPadding(
              padding: const EdgeInsets.only(left: 16),
              sliver: ToSliver(
                child: TabBar(
                    padding: EdgeInsets.all(0),
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    isScrollable: true,
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Palette.LIGHT_PRIMARY,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Palette.PRIMARY,
                          Palette.DARK_PRIMARY,
                        ],
                      ),
                    ),
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
              ),
            )
          ],
        ),
      ),
    );
  }

}