import 'package:flutter/material.dart';
import 'package:geolocation/features/notification/widget/model/notification_model.dart';
import 'package:get/get.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  NotificationItem({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
     
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFFF9F9F9), // Light background color for card
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Timestamp Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${notification.data?.title ??''}',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333), // Dark text color
                    ),
                  ),
                ),
                Text(
                  notification.created_at ?? '',
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: Color(0xFF888888), // Light text color for timestamp
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0),

            // Notification Body
            Text(
              notification.data?.body ?? '',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Color(0xFF555555), // Medium text color for body
                height: 1.4,
              ),
            ),

            SizedBox(height: 8.0),

            // Optional Additional Context (Highlight dynamic details)
           
          ],
        ),
      ),
    );
  }
}
