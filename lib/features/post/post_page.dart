import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/post/create_or_edit_post_page.dart';
import 'package:geolocation/features/post/model/post.dart';
import 'package:geolocation/features/post/widget/post_widget.dart';
import 'package:geolocation/features/post/widget/shimmer_post_widget.dart';
import 'package:get/get.dart';

class PostPage extends StatefulWidget {
   PostPage({Key? key}) : super(key: key);

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final PostController controller = Get.find<PostController>();
  final ScrollController newScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.posts.isEmpty) {
        controller.loadData();
      }

      newScrollController.addListener(() async {
        if (newScrollController.position.pixels >=
            newScrollController.position.maxScrollExtent - 200) {
          controller.loadDataOnScroll();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      backgroundColor: Palette.LIGHT_BACKGROUND,
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => controller.loadData(),
        child: CustomScrollView(
          controller: newScrollController,
          shrinkWrap: true,
          physics:  AlwaysScrollableScrollPhysics(),
          slivers: [

            SliverAppBar(
            backgroundColor: Colors.white,
            pinned: true,
            // expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Posts',
                style: TextStyle(color: Colors.black),
              ),
              // background: Image.network(
              //   'https://via.placeholder.com/600x200',
              //   fit: BoxFit.cover,
              // ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  // Navigate to Create Post Page
                  Get.to(() => CreateOrEditPostPage(), transition: Transition.cupertino);
                },
                icon: Icon(Icons.create, color: Palette.PRIMARY),
                label: Text(
                  'New Post',
                  style: TextStyle(color: Palette.PRIMARY),
                ),
              ),
            ],
          ),
             SliverGap(8), 


            GetBuilder<PostController>(
              builder: (controller) {
                if (controller.isLoading.value) {
                  return SliverMasonryGrid.count(
                    crossAxisCount: 1,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childCount: 6, // Show 6 shimmer items
                    itemBuilder: (context, index) {
                      return  ShimmerPostWidget();
                    },
                  );
                }

                if (controller.posts.isEmpty) {
                  return  SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No posts available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                return SliverMasonryGrid.count(
                  crossAxisSpacing: 16,
                 mainAxisSpacing: 8,
                  crossAxisCount: 1,
                  childCount: controller.posts.length,
                  itemBuilder: (context, index) {
                    Post post = controller.posts[index];
                    return PostWidget(post: post,
                     onEdit: () {
                                    controller.selectItemAndNavigateToUpdatePage(post);
                                  },
                                  onDelete: () async {
                                   controller.delete(post.id!); 
                                  },
                    ); // Display PostWidget
                  },
                );
              },
            ),

            // Show scroll loading indicator
            if (controller.isScrollLoading.value)
              SliverToBoxAdapter(
                child: Padding(
                  padding:  EdgeInsets.all(8.0),
                  child: Column(
                    children: List.generate(
                      3, // Number of shimmer items during scroll loading
                      (index) =>  ShimmerPostWidget(),
                    ),
                  ),
                ),
              ),

            // Add bottom gap
             SliverGap(100),
          ],
        ),
      ),
    );
  }
}
