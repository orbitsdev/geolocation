import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/notification_global.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class OfficerProfileSection extends StatelessWidget {
  const OfficerProfileSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
      return SliverAppBar(

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
                      NotificationGlobal(
                        value: 3, // Badge value
                        action: () {
                          print('Notification Icon Clicked!');
                        },
                        badgeColor: Palette.GREEN3,
                        textColor: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        height: 45,
                        width: 45,
                        child: OnlineImage(
                          imageUrl: controller.user.value.image ?? '',
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                    ],
                  )])));
    });
  }
}
