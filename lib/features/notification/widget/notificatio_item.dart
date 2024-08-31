
import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/notification/widget/model/notification_model.dart';
import 'package:get/get.dart';

class NotificationItem extends StatelessWidget {
  
final  NotificationModel notificaiton;
   NotificationItem({
    Key? key,
    required this.notificaiton,
  });

  @override
  Widget build(BuildContext context) {
   return Card(
  elevation: 0,
  margin: EdgeInsets.symmetric(vertical: 8.0),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  child: Container(
    padding: EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(
          'Mayor Assign Task '.toUpperCase(),
         style: Get.textTheme.bodyMedium?.copyWith(
                color: Palette.LIGHT_TEXT,
              ),
        ),
           
          ],
        ),
       
        SizedBox(height: 8.0),
        Text(
          'Need to provide financial Report on November 24',
          style:  Get.textTheme.bodyMedium?.copyWith(
                
              ),
        ),

         Text(
              '${notificaiton.created_at ?? ''}',
              style: Get.textTheme.bodySmall?.copyWith(
                color: Palette.TEXT_LIGHT
              ),
            ),
       
      ],
    ),
  ),
);

  }
}
