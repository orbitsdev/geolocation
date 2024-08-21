import 'package:flutter/material.dart';
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
import 'package:geolocation/features/home/presentations/files_tab.dart';
import 'package:geolocation/features/home/presentations/posts_tab.dart';
import 'package:geolocation/features/home/presentations/scroll_container.dart';
import 'package:get/get.dart';

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
    _tabController = TabController(length:5, vsync: this);
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
      body: CustomScrollView(
        controller: scrollController,
        slivers: [
          ToSliver(
            child: Container(
              padding: EdgeInsets.all(16),
              constraints: BoxConstraints(),
              decoration: BoxDecoration(
                color: Palette.DARK_PRIMARY,
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
                                border: Border.all(
                                    width: 2, color: Palette.LIGHT_PRIMARY)),
                            height: 50,
                            width: 50,
                            child: OnlineImage(
                              imageUrl: 'https://picsum.photos/200/300',
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                          Gap(16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi! Angela',
                                style: Get.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.LIGHT_TEXT_PRIMARY),
                              ),
                              Text(
                                'orbinobrian@gmail.com',
                                style: Get.textTheme.bodyMedium
                                    ?.copyWith(color: Palette.LIGHT_PRIMARY),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: Palette.LIGHT_PRIMARY),
                              borderRadius: BorderRadius.circular(60)),
                          child: Container(
                              height: 40,
                              width: 40,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Center(
                                      child: FaIcon(FontAwesomeIcons.bell,
                                          color: Palette.LIGHT_PRIMARY)),
                                  Positioned(
                                    bottom: 0,
                                    left: -8,
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
          ))

          // tab bar or page vew
        ],
      ),
    );
  }
}
