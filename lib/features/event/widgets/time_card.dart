import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/images/online_image_full_screen_display.dart';
import 'package:geolocation/features/attendance/model/attendance.dart';
import 'package:get/get.dart';

class TimeCard extends StatelessWidget {
  final Attendance attendance;

  const TimeCard({Key? key, required this.attendance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (attendance.checkInTime != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Check-In Image
                if (attendance.checkInSelfieUrl != null)
                  GestureDetector(
                    onTap: ()=> Get.to(()=> OnlineImageFullScreenDisplay(imageUrl: attendance.checkInSelfieUrl!)),
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(right: 12), // Spacing between image and text
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: OnlineImage(imageUrl: attendance.checkInSelfieUrl!),
                    ),
                  ),
                // Check-In Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check In',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        attendance.checkInTime ?? 'N/A',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis, // Prevents overflow
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16), // Spacing between Check-In and Check-Out
          if (attendance.checkOutTime != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Check-Out Image
                if (attendance.checkOutSelfieUrl != null)
                  GestureDetector(
                                        onTap: ()=> Get.to(()=> OnlineImageFullScreenDisplay(imageUrl: attendance.checkInSelfieUrl!)),
                    child: Container(
                      height: 50,
                      width: 50,
                      margin: const EdgeInsets.only(right: 12), // Spacing between image and text
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey.shade200,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: OnlineImage(imageUrl: attendance.checkOutSelfieUrl!),
                    ),
                  ),
                // Check-Out Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Check Out',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        attendance.checkOutTime ?? 'N/A',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis, // Prevents overflow
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
