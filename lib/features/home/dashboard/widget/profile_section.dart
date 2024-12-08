import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/notification_badge_global.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/notification/controller/notification_controller.dart';
import 'package:geolocation/features/notification/notification_page.dart';
import 'package:geolocation/features/settings/profile_page.dart';
import 'package:get/get.dart';

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

        return ToSliver(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity, // Constrain the width to prevent unbounded errors
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min, // Prevent infinite width issues
                  children: [
                    RippleContainer(
                      onTap: () => Get.to(() => const ProfilePage()),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        height: 60,
                        width: 60,
                        child: OnlineImage(
                          imageUrl: authController.user.value.image ?? '',
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                    ),
                    const Gap(16),
                    Flexible(
                      fit: FlexFit.loose, // Avoid forcing infinite width
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Get.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Palette.BLACK,
                            ),
                          ),
                          Text(
                            position,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: Palette.BLACK,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                GetBuilder<NotificationController>(
                  builder: (notificationController) {
                    final unreadCount = notificationController.notifications
                            ?.where((notification) => notification.read_at == null)
                            .length ??
                        0;

                    return NotificationBadgeGlobal(
                      value: unreadCount,
                      action: () {
                        Get.to(
                          () =>  NotificationPage(),
                          transition: Transition.cupertino,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
