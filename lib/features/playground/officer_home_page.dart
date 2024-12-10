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
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/notification_global.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:googleapis_auth/auth_io.dart';

class OfficerHomePage extends StatelessWidget {
const OfficerHomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
     
      body: SafeArea(
        child: CustomScrollView(
        slivers: [
          ToSliver(
            child:Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                   
                   
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo, Fulan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Selamat Pagi!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  NotificationGlobal(
  value: 3, // Badge value
  action: () {
    print('Notification Icon Clicked!');
  },
  badgeColor: Palette.GREEN3, // Optional: Custom badge color
  textColor: Colors.white,  // Optional: Custom text color
)
,
                     SizedBox(width: 16),
                     GetBuilder<AuthController>(
                       builder: (controller) {
                         return Container(
                          height: 45,
                          width: 45,
                          child: OnlineImage(imageUrl: controller.user.value.image ??'',borderRadius: BorderRadius.circular(45),),
                         );
                       }
                     )
                  ],
                ),
              ],
            ),
          ),
            
          )
        ],
        ),
      ) ,
    );
  }
}