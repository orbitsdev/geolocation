import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/post/create_or_edit_post_page.dart';
import 'package:geolocation/features/post/model/post.dart';
import 'package:geolocation/features/post/post_details_page.dart';
import 'package:geolocation/features/post/widget/post_card.dart';
import 'package:geolocation/features/post/widget/shimmer_post_card.dart';
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

      if(postController.posts.isEmpty){
       postController.loadData();

      }

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
            SliverGap(8),

          GetBuilder<PostController>(builder: (postcontroller) {
            return MultiSliver(children: [
              if (postcontroller.isLoading.value == true)
              
                    SliverAlignedGrid.count(
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: 10,
                  crossAxisCount: 1,
                  itemBuilder: (context, index) {
                    return ShimmerPostCard();
                  }),
              SliverAlignedGrid.count(
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: postcontroller.posts.length,
                  crossAxisCount: 1,
                  itemBuilder: (context, index) {
                    Post post = postcontroller.posts[index];
                    return RippleContainer(
                      onTap: ()=> Get.to(()=>  PostDetailsPage(post: post,), transition: Transition.cupertino),
                      child: PostCard(
                        onView: (){
                        // Get.to(()=>  PostDetailsPage(post: post,), transition: Transition.cupertino);
                        },
                        onEdit: () {
                          postcontroller.selectItemAndNavigateToUpdatePage(post);
                        },
                        onDelete: () {
                          postcontroller.delete(post.id as int);
                        },
                      
                        post: post,
                      ),
                    );
                  }),

                   if (postcontroller.isScrollLoading.value)
                      SliverAlignedGrid.count(
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  itemCount: 10,
                  crossAxisCount: 1,
                  itemBuilder: (context, index) {
                    return ShimmerPostCard();
                  }),
            ]);
          }),


        ],
      ),
    );
  }
}