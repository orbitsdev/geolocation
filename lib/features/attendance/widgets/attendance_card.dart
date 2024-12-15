import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/attendance/model/attendance.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';

class AttendanceCard extends StatelessWidget {
  final Attendance attendance;

  const AttendanceCard({
    Key? key,
    required this.attendance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Row
          if (!attendance.owner(AuthController.controller.user.value.defaultPosition?.id))
            Row(
              children: [
                // Profile Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: attendance.councilPosition?.image != null
                        ? OnlineImage(
                            imageUrl: attendance.councilPosition!.image!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.account_circle, size: 40, color: Colors.grey),
                  ),
                ),
                const Gap(12),
                // Full Name
                Expanded(
                  child: Text(
                    attendance.councilPosition?.fullName ?? 'No Name',
                    style: const TextStyle(
                     
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          if (!attendance.owner(AuthController.controller.user.value.defaultPosition?.id)) const Gap(12),

          // Event Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Icon(Icons.event, size: 18, color: Palette.PRIMARY),
              const Gap(6),
              Expanded(
                child: Text(
                  attendance.event?.title ?? 'No Event',
                  style:  TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Palette.PRIMARY,
                  ),
                  
                ),
              ),
            ],
          ),
          const Gap(8),

          // Event Date
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
              const Gap(6),
              Text(
                attendance.event?.dateOnly ?? "No Date",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          const Gap(12),

          // Check-In Time Row
          Row(
            children: [
              const Icon(Icons.login, size: 18, color: Colors.green),
              const Gap(6),
              const Text(
                "In:",
                style: TextStyle(
                 
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const Gap(6),
              Expanded(
                child: Text(
                  attendance.checkInTime ?? "No Check-In",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const Gap(8),

          // Check-Out Time Row
          Row(
            children: [
              const Icon(Icons.logout, size: 18, color: Colors.red),
              const Gap(6),
              const Text(
                "Out:",
                style: TextStyle(
                 
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const Gap(6),
              Expanded(
                child: Text(
                  attendance.checkOutTime ?? "No Check-Out",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
