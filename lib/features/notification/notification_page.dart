// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/shimmer_widget.dart';
import 'package:geolocation/core/localdata/sample_data.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/notification/controller/notification_controller.dart';
import 'package:geolocation/features/notification/widget/model/notification_model.dart';
import 'package:geolocation/features/notification/widget/notificatio_item.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';


class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

      var notificationController = Get.find<NotificationController>();

   @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {  
      // notificationController.markNotificationsAsRead(context);

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
 backgroundColor: Palette.LIGHT_BACKGROUND,
      appBar: AppBar(
       
        title: Text('Notifications '),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
         
            Get.back();
          },
        ),
        
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh:  ()=> notificationController.loadNotifications(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Expanded(
                child: GetBuilder<NotificationController>(
                  builder: (controller) {

                  return ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context,index){
                    return NotificationItem(notificaiton: NotificationModel());

                        });

                  // if(controller.isLoading.value){
                  // return Center( child: CircularProgressIndicator(color: Palette.PRIMARY ,));
        
                  // }else{
                  //     return controller.notifications.isNotEmpty ? ListView.builder(
                  //       itemCount: controller.notifications.length,
                  //       itemBuilder: (context,index){
                  //         M.Notification notificaiton =  controller.notifications[index];
        
                  //       return NotificationItem(notificaiton:notificaiton ,);
                  //     }): Center(child: LocalLottieImage(imagePath: lottiesPath('empty.json')) ,);
                  // }
                   
                  }
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationItemLoading extends StatelessWidget {
 
  
  @override
  Widget build(BuildContext context) {

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
         
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerWidget(width:  Get.size.width * 0.80 ,  height: 8,),
          Gap(4),
          ShimmerWidget(width:  Get.size.width ,  height: 8,),
          Gap(4),
          ShimmerWidget(width:  Get.size.width ,  height: 8,),
          Gap(4),
          ShimmerWidget(width:  Get.size.width ,  height: 8,),
        ],
      ),
    );
   
  }
}