import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/progress_bar_submit.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';

import 'package:geolocation/features/attendance/controller/attendance_controller.dart';

class ConfirmAttendancePage extends StatelessWidget {
  const ConfirmAttendancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AttendanceController controller = Get.find<AttendanceController>();

    final arguments = Get.arguments;

    // Extract arguments
    final bool isCheckIn = arguments['isCheckIn'];
    controller.clearSelfie();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isCheckIn ? 'Confirm In' : 'Confirm Out',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title and Instructions
            Text(
              'Take a selfie to verify your ${isCheckIn ? "In" : "Out"}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Make sure your face is clearly visible and well-lit.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
                                      if (controller.isUploading.value) {
                                        return Container(
                                              margin: EdgeInsets.only(bottom: 12),
                                              child:  ProgressBarSubmit(
                                                      progress:
                                                          controller
                                                              .uploadProgress.value)
                                                  );
                                      } else {
                                        return SizedBox(
                                              height:
                                                  8); // Placeholder when not loading
                                      }
                                    }),

            // Display the captured selfie or a placeholder
            Obx(() {
              return GestureDetector(
                onTap: () => controller.takeSelfie(), // Open camera when tapped
                child: controller.selfiePath.value.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(controller.selfiePath.value),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tap to Take Selfie',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
              );
            }),
            const SizedBox(height: 30),

            // Confirm Attendance Button
            
          ],
        ),
      ),
      bottomSheet: Container(
            height: Get.size.height * 0.11,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                color: Color(0x000000).withOpacity(0.03),
                offset: Offset(0, -4),
                blurRadius: 3,
                spreadRadius: 0,
              )
            ]),
            child: Container(
              width: Get.size.width,
              constraints: const BoxConstraints(minWidth: 150),
              height: Get.size.height,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.GREEN3,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                      controller.takeAttendance(isCheckIn);
                },
                child: Text(
                  'Confirm Attendance',
                  style: Get.textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
