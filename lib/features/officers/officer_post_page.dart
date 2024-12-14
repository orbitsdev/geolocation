import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/post/model/post.dart';
import 'package:geolocation/features/post/widget/post_card.dart';
import 'package:get/get.dart';
import 'package:sliver_tools/sliver_tools.dart';

class OfficerPostPage extends StatefulWidget {
const OfficerPostPage({ Key? key }) : super(key: key);

  @override
  State<OfficerPostPage> createState() => _OfficerPostPageState();
}

class _OfficerPostPageState extends State<OfficerPostPage> {
   var postController = Get.find<PostController>();
   final ScrollController newScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
       postController.loadData();

        newScrollController.addListener(() async {
        if (newScrollController.position.pixels >=
            newScrollController.position.maxScrollExtent - 200) {
           postController.loadDataOnScroll();
        }
      });
    });
    
  }
  @override
  Widget build(BuildContext context){
      return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () => postController.loadData(),
      child: CustomScrollView(
        controller: newScrollController,
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [


          GetBuilder<PostController>(builder: (postcontroller) {
            return MultiSliver(children: [
              if (postcontroller.isLoading.value == true)
                ToSliver(child: LinearProgressIndicator()),
              SliverAlignedGrid.count(
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: postcontroller.posts.length,
                  crossAxisCount: 1,
                  itemBuilder: (context, index) {
                    Post post = postcontroller.posts[index];
                    return PostCard(
                      onEdit: () {},
                      onDelete: () {},
                      post: post,
                    );
                  }),

                   if (postcontroller.isScrollLoading.value)
                    ToSliver(
                      child: Center(child: CircularProgressIndicator()),
                    ),
            ]);
          }),


        ],
      ),
    );
  }
}