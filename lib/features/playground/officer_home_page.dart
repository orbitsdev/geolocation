import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/globalwidget/sliver_gap.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/home/dashboard/widget/profile_section.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/post/model/post.dart';
import 'package:geolocation/features/post/widget/post_card.dart';
import 'package:geolocation/features/post/widget/post_widget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';


class OfficerHomePage extends StatefulWidget {
const OfficerHomePage({ Key? key }) : super(key: key);

  @override
  State<OfficerHomePage> createState() => _OfficerHomePageState();
}

class _OfficerHomePageState extends State<OfficerHomePage> {

   final PostController controller = Get.find<PostController>();
  final ScrollController newScrollController = ScrollController();


   @override
   void initState() {
     super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
       controller.loadData();
      // if (controller.posts.isEmpty) {
       
      // }

      newScrollController.addListener(() async {
        if (newScrollController.position.pixels >=
            newScrollController.position.maxScrollExtent - 200) {
          controller.loadDataOnScroll();
        }
      });
    });

   }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => controller.loadData(),
        child: SafeArea(
          child: CustomScrollView(
        controller: newScrollController,
          shrinkWrap: true,
          physics:  AlwaysScrollableScrollPhysics(),
            slivers: [
              ProfileSection(),
              SliverGap(24),
        
               GetBuilder<PostController>(
                 builder: (postcontroller) {
                   return SliverAlignedGrid.count(
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                itemCount: postcontroller.posts.length,
                                crossAxisCount: 2,
                                itemBuilder: (context, index) {
                                  Post post = postcontroller.posts[index];
        
                                   return PostCard(post: post); // Display PostWidget
        
                                });
                 }
               )
        
            ],
          ),
        ),
      ),
    );
  }
}