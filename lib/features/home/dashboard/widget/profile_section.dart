import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/notification_badge_global.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/chat/chat_room_page.dart';
import 'package:geolocation/features/notification/controller/notification_controller.dart';
import 'package:geolocation/features/notification/notification_page.dart';
import 'package:geolocation/features/settings/profile_page.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class ProfileSection extends StatefulWidget {
  const ProfileSection({Key? key}) : super(key: key);

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<NotificationController>()) {
        NotificationController.controller.loadNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        final fullName = authController.user.value.fullName ?? 'User';
        final position =
            authController.user.value.defaultPosition?.position ?? 'Super Admin';
         final user = authController.user.value;

        return ToSliver(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white, // Light background
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
         // Profile Section
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Gap(16),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                fullName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Get.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Palette.deYork900, // Dark green text
                                ),
                              ),
                              Text(
                                position,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Get.textTheme.bodySmall?.copyWith(
                                  color: Palette.deYork700, // Mid-tone green
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    
                    // Notification and Profile Section
                    Row(
                      children: [
                            
                         IconButton(
      icon: HeroIcon(HeroIcons.chatBubbleBottomCenterText,  size: 28), // Chat icon
      onPressed: () {
        // Navigate to Chat Page using Council ID
        Get.to(() => ChatRoomPage(
          councilId: user.defaultPosition!.councilId.toString(),
          councilName: user.defaultPosition!.councilName ?? "Council Chat",
          userId: user.id.toString(),
          userName: user.fullName ?? "Unknown",
          userImage: user.image,
        ), transition: Transition.cupertino);
      },
    ),
             
                        
                        GetBuilder<NotificationController>(
                          builder: (notificationController) {
                            final unreadCount = notificationController.notifications
                                .where((notification) => notification.read_at == null)
                                .length;

                            return NotificationBadgeGlobal(
                              iconSize: 34,
                              color: Palette.deYork600, // Icon color
                              value: unreadCount,
                              action: () {
                                Get.to(
                                  () => NotificationPage(),
                                  transition: Transition.cupertino,
                                );
                              },
                            );
                          },
                        ),
                        RippleContainer(
                          onTap: () => Get.to(() => ProfilePage()),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: Palette.deYork200, // Background for profile image
                            ),
                            height: 40,
                            width: 40,
                            child: OnlineImage(
                              imageUrl: authController.user.value.image ?? '',
                              borderRadius: BorderRadius.circular(60),
                            ),
                          ),
                        ),
                        const Gap(16),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
