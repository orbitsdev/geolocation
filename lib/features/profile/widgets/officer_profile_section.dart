import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/notification_global.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/chat/chat_room_page.dart';
import 'package:geolocation/features/notification/controller/notification_controller.dart';
import 'package:geolocation/features/notification/notification_page.dart';
import 'package:geolocation/features/settings/profile_page.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class OfficerProfileSection extends StatelessWidget {
  const OfficerProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        // Load notifications after the widget is rendered
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (Get.isRegistered<NotificationController>()) {
            NotificationController.controller.loadNotifications();
          }
        });

        final user = authController.user.value;
        final position = user.defaultPosition?.position ?? 'N/A';

        return SliverAppBar(
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // User Information Section
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.fullName ?? 'Unknown User',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Palette.gray900,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        position,
                        style:  TextStyle(
                          fontSize: 14,
                          color: Palette.card3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Notification and Profile Picture Section
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
                    // Notification Icon 
                    //Testwith Badge
                    GetBuilder<NotificationController>(
                      builder: (notificationController) {
                        final unreadCount = notificationController.notifications
                            .where((notification) => notification.read_at == null)
                            .length;

                        return NotificationGlobal(
                          value: unreadCount, // Badge value
                          action: () {
                            Get.to(() => NotificationPage(), transition: Transition.cupertino);
                          },
                          // badgeColor: Palette.GREEN3,
                          textColor: Colors.white,
                        );
                      },
                    ),
                    const SizedBox(width: 8),

                    // Profile Picture
                    RippleContainer(
                      onTap: () => Get.to(() => const ProfilePage(), transition: Transition.cupertino),
                      child: Container(
                         height: 45,
                        width: 45,
                        child: OnlineImage(
                          borderRadius: BorderRadius.circular(45),
                          imageUrl: user.image ?? '',
                        
                        ),
                      ),
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
