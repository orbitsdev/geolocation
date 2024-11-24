import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/images/online_image_full_screen_display.dart';
import 'package:geolocation/features/attendance/model/attendance.dart';
import 'package:get/get.dart';

class AttendanceWidget extends StatelessWidget {
  final Attendance attendance;

  const AttendanceWidget({
    Key? key,
    required this.attendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
          // border: Border.all(color: Colors.grey.shade300, width: 1.5),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Council Member Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 50,
                  height: 50,
                  child: OnlineImage(
                    imageUrl: '${attendance.councilPosition?.image}',
                    borderRadius: BorderRadius.circular(50),
                    shimmer: const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                    noImageIconSize: 24,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Gap(12),
              // Name and Position
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${attendance.councilPosition?.fullName ?? "Unknown"}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Gap(4),
                  Text(
                    '${attendance.councilPosition?.position ?? "No Position"}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Gap(16),
          const Divider(color: Colors.grey, thickness: 1),
          const Gap(16),

          // Check-In Section
          if (attendance.checkInTime != null || attendance.checkInSelfieUrl != null)
            _buildSection(
              title: 'Check-In',
              time: attendance.checkInTime,
              imageUrl: attendance.checkInSelfieUrl,
              placeholderText: 'No Check-In Selfie',
            ),

          if (attendance.checkInTime != null || attendance.checkInSelfieUrl != null)
            const Gap(16),

          // Check-Out Section
          if (attendance.checkOutTime != null || attendance.checkOutSelfieUrl != null)
            _buildSection(
              title: 'Check-Out',
              time: attendance.checkOutTime,
              imageUrl: attendance.checkOutSelfieUrl,
              placeholderText: 'No Check-Out Selfie',
            ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    String? time,
    String? imageUrl,
    required String placeholderText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image Section
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: GestureDetector(
            onTap: imageUrl != null && imageUrl.isNotEmpty
                ? () => Get.to(() => OnlineImageFullScreenDisplay(imageUrl: '${imageUrl}'))
                : null,
            child: Container(
              width: 60,
              height: 60,
              child: OnlineImage(
                imageUrl: '${imageUrl}',
                borderRadius: BorderRadius.circular(8),
                shimmer: const SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
                noImageIconSize: 32,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Gap(16),
        // Time and Title
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Gap(4),
              Text(
                time ?? 'No time available',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
