import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/notification_global.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/notification/controller/notification_controller.dart';
import 'package:geolocation/features/notification/notification_page.dart';
import 'package:geolocation/features/settings/profile_page.dart';
import 'package:get/get.dart';

class OfficerProfileSection extends StatelessWidget {
  const OfficerProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<NotificationController>()) {
        NotificationController.controller.loadNotifications();
      }
    });
      return SliverAppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${controller.user.value.fullName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${controller.user.value.defaultPosition?.position}',
                          style:  TextStyle(
                            fontSize: 14,
                            color: Palette.GREEN3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GetBuilder<NotificationController>(
                        builder: (notificationController) {

                          final unreadCount = notificationController.notifications.where((notification) => notification.read_at == null).length;
                          return NotificationGlobal(
                            value: unreadCount, // Badge value
                            action: () {
                              Get.to(()=>  NotificationPage(), transition: Transition.cupertino);
                            },
                            badgeColor: Palette.GREEN3,
                            textColor: Colors.white,
                          );
                        }
                      ),
                      const SizedBox(width: 8),
                      RippleContainer(
                        onTap: ()=> Get.to(()=> ProfilePage(), transition: Transition.cupertino),
                        child: Container(
                          height: 45,
                          width: 45,
                          child: OnlineImage(
                            imageUrl: controller.user.value.image ?? '',
                            borderRadius: BorderRadius.circular(45),
                          ),
                        ),
                      ),
                    ],
                  )])));
    });
  }
}
