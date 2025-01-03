import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/images/online_image_full_screen_display.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/model/attendance.dart';
import 'package:get/get.dart';

class AttendanceFullDetailsPage extends StatelessWidget {
  final Attendance attendance;

  const AttendanceFullDetailsPage({
    Key? key,
    required this.attendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text('Attendance Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => OnlineImageFullScreenDisplay(imageUrl: attendance.councilPosition?.image ?? ''));
                },
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: attendance.councilPosition?.image != null
                        ? OnlineImage(
                                  borderRadius: BorderRadius.circular(40),
                            imageUrl: attendance.councilPosition!.image!,
                            fit: BoxFit.cover,
                          )
                        :  Icon(Icons.account_circle, size: 80, color: Palette.lightText),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        attendance.councilPosition?.fullName ?? 'No Name',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Gap(4),
                      Text(
                        attendance.councilPosition?.position ?? 'No Position',
                        style:  TextStyle(fontSize: 16, color: Palette.lightText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(16),

            // Event Details
            _buildSectionTitle('Event Details'),
            const Gap(8),
            _buildDetailRow('Event:', attendance.event?.title ?? 'N/A'),
            _buildDetailRow('Date:', attendance.event?.dateOnly ?? 'N/A'),
            _buildDetailRow('Time:', '${attendance.event?.startTimeOnly ?? ''} - ${attendance.event?.endTimeOnly ?? ''}'),

            const Gap(16),

            // Attendance Timing
            _buildSectionTitle('Attendance Timing'),
            const Gap(8),
            _buildDetailRow('Time in:', attendance.checkInTime ?? 'N/A'),
            _buildDetailRow('Time out', attendance.checkOutTime ?? 'N/A'),

            const Gap(16),

            // Attendance Coordinates
            _buildSectionTitle('Location Coordinates'),
            const Gap(8),
            _buildDetailRow(
              'In Coordinates:',
              attendance.checkInCoordinates != null
                  ? '${attendance.checkInCoordinates!['latitude']}, ${attendance.checkInCoordinates!['longitude']}'
                  : 'N/A',
            ),
            _buildDetailRow(
              'Out Coordinates:',
              attendance.checkOutCoordinates != null
                  ? '${attendance.checkOutCoordinates!['latitude']}, ${attendance.checkOutCoordinates!['longitude']}'
                  : 'N/A',
            ),

            const Gap(16),

            // Attendance Images
            _buildSectionTitle('Attendance Images'),
            const Gap(8),
            if (attendance.checkInSelfieUrl != null)
              _buildImageSection('In Selfie', attendance.checkInSelfieUrl!),
            const Gap(12),
            if (attendance.checkOutSelfieUrl != null)
              _buildImageSection('Out Selfie', attendance.checkOutSelfieUrl!),

            const Gap(16),

            // Additional Notes
           
          ],
        ),
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  // Row with label and value
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Image Preview
  Widget _buildImageSection(String label, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const Gap(8),
        GestureDetector(
          onTap: (){
            Get.to(() => OnlineImageFullScreenDisplay(imageUrl: imageUrl));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: OnlineImage(imageUrl: imageUrl, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }
}
