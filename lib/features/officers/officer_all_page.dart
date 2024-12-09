import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/features/event/controller/event_controller.dart';
import 'package:geolocation/features/event/widgets/event_card2.dart';
import 'package:geolocation/features/officers/controller/officer_controller.dart';
import 'package:geolocation/features/post/controller/post_controller.dart';
import 'package:geolocation/features/post/widget/post_card.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../post/model/post.dart';

class OfficerAllPage extends StatefulWidget {
const OfficerAllPage({ Key? key }) : super(key: key);

  @override
  State<OfficerAllPage> createState() => _OfficerAllPageState();
}

class _OfficerAllPageState extends State<OfficerAllPage> {
  var  officerController = Get.put(OfficerController());

  @override
  void initState() {
    super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async{

     await officerController.loadAllPageData();
  });
  
    print('all page called');
  }

  @override
  Widget build(BuildContext context){
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: ()=> officerController.loadAllPageData(),
      child: CustomScrollView(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                   slivers: [
      
                   GetBuilder<EventController>(
                     builder: (eventcontroller) {
                       return ToSliver(
                               child: Container(
                             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8.0,),
                             height: 300,
                            //  color: Colors.red,
                             child: ListView.builder(
                               scrollDirection: Axis.horizontal, // Enables horizontal scrolling
                               itemCount: eventcontroller.events.length, // Adjust the number of items
                               itemBuilder: (context, index) {
                                
                                 return EventCard2(event: eventcontroller.events[index], onView: (){

                                 });
                               },
                             ),
                               ),
                             );
                     }
                   ),
      GetBuilder<PostController>(
        builder: (postcontroller) {
      return MultiSliver(children: [
      
        if(postcontroller.isLoading.value == true)ToSliver(child: LinearProgressIndicator()),
              SliverAlignedGrid.count(
                
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    itemCount: postcontroller.posts.length,
                                    crossAxisCount: 1,
                                    itemBuilder: (context, index) {
                                      Post post = postcontroller.posts[index];
                                      return PostCard(
                                        onEdit: (){},
                                        onDelete: (){
                                      
                                        },
                                      post: post,
                                      );
                                    })
      ]);
        }
      ),
      
                    
          
                   ],
                  ),
    );
  }
}