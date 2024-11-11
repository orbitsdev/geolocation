import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/images/online_image_full_screen_display.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/task/task_page.dart';
import 'package:get/get.dart';

class CouncilMemberProfilePage extends StatelessWidget {

      var positionController = Get.find<CouncilPositionController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Obx(
        ()=>  RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
                positionController.refreshSelectedMemberDetails();
          },
          child: positionController.isMemberDetailsLoading.value ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
            
              physics: AlwaysScrollableScrollPhysics(),
              
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     RippleContainer(onTap: ()=> Get.to(()=>  OnlineImageFullScreenDisplay(imageUrl:'${positionController.selectedMember.value.image}')),
          
                       child: Container(
                        height: 80,
                        width: 80,
                        
                        child: OnlineImage(imageUrl: '${positionController.selectedMember.value.image}', borderRadius: BorderRadius.circular(100),),),
                     ),
                      SizedBox(width: 16),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${positionController.selectedMember.value.fullName}',
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                                                           '${positionController.selectedMember.value.email}',
                              style:Get.textTheme.bodyLarge?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),

                            RichText(
                              
                              text: TextSpan(text:'',children: [
                              TextSpan(text: '${positionController.selectedMember.value.position}',style: Get.textTheme.titleMedium?.copyWith(
                                color: Colors.green
                              )),
                              TextSpan(text: ' (${positionController.selectedMember.value.councilName})',style: Get.textTheme.titleMedium?.copyWith(
                                color: Colors.green
                              )),
                            ])),
                            // Text(
                            //   '${positionController.selectedMember.value.position } ',
                            //   style: TextStyle(
                            //     fontSize: 18,
                            //     color: Colors.green,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  // Task Overview
                  Text(
                    'Task Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTaskCard('Todo ',  positionController.selectedMember.value.totalToDoTasks as int),
                      _buildTaskCard('In Progress', positionController.selectedMember.value.totalInProgressTasks as int),
                    ],
                  ),
                
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildTaskCard('Need Revision', positionController.selectedMember.value.totalNeedsRevision as int),
                      _buildTaskCard('Rejected', positionController.selectedMember.value.totalRejected as int),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     
                       _buildTaskCard('Completed', positionController.selectedMember.value.totalCompletedTasks as int ),
                    ],
                  ),
                  
                  // Biography Section
                  SizedBox(height: 24),
                  // Text(
                  //   'Biography',
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 8),
                  // Text(
                  //   'John Doe is a dedicated public servant with over 20 years of experience in municipal government. As the Mayor, he has led numerous initiatives aimed at improving the quality of life for residents...',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     color: Colors.grey[800],
                  //   ),
                  // ),
                  
                  // // Social Media Links Section
                  // SizedBox(height: 24),
                  // Text(
                  //   'Social Media',
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 8),
                  // Row(
                  //   children: [
                  //     Icon(Icons.link, color: Palette.DARK_PRIMARY),
                  //     SizedBox(width: 8),
                  //     Text(
                  //       'LinkedIn Profile',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         color: Colors.deepPurple,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(String title, int count,) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          Get.to(()=> TaskPage(), transition: Transition.cupertino);
        },
        child: Container(
         margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
           color: Palette.LIGH_BACKGROUND_GREEN,
             borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Palette.PRIMARY,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Palette.DARK_PRIMARY,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
