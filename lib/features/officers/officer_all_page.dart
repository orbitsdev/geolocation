import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/features/officers/controller/officer_controller.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/post/widget/post_card.dart';
import 'package:get/get.dart';

import '../post/model/post.dart';

class OfficerAllPage extends StatefulWidget {
const OfficerAllPage({ Key? key }) : super(key: key);

  @override
  State<OfficerAllPage> createState() => _OfficerAllPageState();
}

class _OfficerAllPageState extends State<OfficerAllPage> {
  var  officerController = Get.find<OfficerController>();

  @override
  void initState() {
    super.initState();

    officerController.loadAllPageData();
    print('all page called');
  }

  @override
  Widget build(BuildContext context){
    return GetBuilder<PostController>(
      builder: (postController) {
        return CustomScrollView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                 slivers: [
                 ToSliver(
  child: Container(
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8.0,),
    height: 300,
    color: Colors.red,
    child: ListView.builder(
      scrollDirection: Axis.horizontal, // Enables horizontal scrolling
      itemCount: 10, // Adjust the number of items
      itemBuilder: (context, index) {
        return Container(
          width: Get.size.width / 1.2, // Set the width for each item
          margin: const EdgeInsets.symmetric(horizontal: 8), // Spacing between items
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              'Item $index',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    ),
  ),
),

        SliverAlignedGrid.count(
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              itemCount: postController.posts.length,
                              crossAxisCount: 1,
                              itemBuilder: (context, index) {
                                Post post = postController.posts[index];
                                return PostCard(
                                  onEdit: (){},
                                  onDelete: (){
                                
                                  },
                                post: post,
                                );
                              })
                  
        
                 ],
                );
      }
    );
  }
}