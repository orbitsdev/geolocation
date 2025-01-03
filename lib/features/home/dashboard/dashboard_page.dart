import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/custom_app_bar_with_bg.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/features/collections/controller/collection_controller.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:geolocation/features/files/controller/media_controller.dart';
import 'package:geolocation/features/home/dashboard/widget/over_all_card.dart';
import 'package:geolocation/features/home/dashboard/widget/profile_section.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/councils/controller/council_controller.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ScrollController scrollController = ScrollController();
  final councilController = Get.find<CouncilController>();
  final authController = Get.find<AuthController>();
  final positionController = Get.find<CouncilPositionController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData());
  }

  Future<void> loadData() async {
    final user = AuthController.controller.user.value;

    if (user.isAdmin()) {
      await councilController.fetchCouncils();
    } else if (!user.isAdmin() && user.hasAccess()) {
      final councilId = user.defaultPosition?.councilId;
      if (councilId != null) {
        positionController.setCouncilId(councilId);
       await Future.wait([
        positionController.fetchCouncilMembers(),
        TaskController.controller.loadTask(),
        EventController.controller.loadEvents(),
        CollectionController.controller.loadData(),
        PostController.controller.loadData(),
        MediaController.controller.loadMediaResources(),

      ]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: loadData,
        child: CustomScrollView(
          physics:  const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          slivers: [
            SliverGap(16),
            ProfileSection(),
            // CustomAppBarWithBg(),
            SliverGap(24),
            // _buildDashboardTitle(),
            _buildGridContent(),
          ],
        ),
      ),
    );
  }

  // Profile Section
  Widget _buildProfileSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Welcome, ${authController.user.value.fullName}',
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Dashboard Title
  Widget _buildDashboardTitle() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          'Dashboard',
          style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Grid Content
  Widget _buildGridContent() {
    return Obx(() {
      final user = authController.user.value;

      final gridItems = <Widget>[];

      if (user.isAdmin()) {
        gridItems.add(_buildGridItem(
          icon: FontAwesomeIcons.users,
          title: 'Councils',
          count: councilController.councils.length.toString(),
          onTap: () => Get.toNamed('/councils'),
        ));
      }

      if (user.hasAccess()) {
        gridItems.addAll([
          _buildGridItem(
            icon: FontAwesomeIcons.userGroup,
            title: 'Members',
            count: positionController.councilMembers.length.toString(),
            isLoading: positionController.isPageLoading.value,
            onTap: () => positionController.selectAndNavigateToCouncilMemberPage(
              user.defaultPosition?.councilId ?? 0,
            ),
          ),
          _buildGridItem(
            icon: FontAwesomeIcons.tasks,
            title: 'Tasks',
            count: TaskController.controller.tasks.length.toString(),
            isLoading: TaskController.controller.isLoading.value,
            onTap: () => Get.toNamed('/tasks'),
          ),

            _buildGridItem(
            icon: FontAwesomeIcons.calendarCheck,
            title: 'Events',
            count: EventController.controller.events.length.toString(),
             isLoading: EventController.controller.isLoading.value,
            onTap: () => Get.toNamed('/events'),
          ),
            _buildGridItem(
            icon: FontAwesomeIcons.coins,
            title: 'Collections',
            count: CollectionController.controller.collections.length.toString(),
            isLoading: CollectionController.controller.isPageLoading.value,
            onTap: () => Get.toNamed('/collections'),
          ),
          _buildGridItem(
            icon: FontAwesomeIcons.bullhorn,
           title: 'Posts',
            count: PostController.controller.posts.length.toString(),
            isLoading: PostController.controller.isPageLoading.value,
            onTap: () => Get.toNamed('/posts'),
          ),
        
        
          _buildGridItem(
            icon: FontAwesomeIcons.folderOpen,
             
           title: 'Files',
            count: MediaController.controller.mediaResources.length.toString(),
            isLoading: MediaController.controller.isLoading.value,
            onTap: () => Get.toNamed('/files'),
          ),
        ]);
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) => gridItems[index],
            childCount: gridItems.length,
          ),
        ),
      );
    });
  }

  // Grid Item
  Widget _buildGridItem({
    required IconData icon,
    required String title,
    required String count,
    VoidCallback? onTap,
    bool isLoading = false,
  }) {
    return RippleContainer(
      onTap: onTap,
      child: OverAllCard(
        icon: FaIcon(icon, size: 32, color:  Palette.deYork600,),
        title: title,
        count: count,
        isLoading: isLoading,
       
      ),
    );
  }
}
