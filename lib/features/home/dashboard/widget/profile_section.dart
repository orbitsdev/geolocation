import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/notification_badge_global.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/localdata/sample_data.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/notification/controller/notification_controller.dart';
import 'package:geolocation/features/notification/notification_page.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class ProfileSection extends StatefulWidget {
const ProfileSection({ Key? key }) : super(key: key);

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {

   @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {  
       NotificationController.controller.loadNotifications();

    });
  }

  @override
  Widget build(BuildContext context){

    return GetBuilder<AuthController>(
      builder: (authcontroller) {
        return ToSliver(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    constraints: BoxConstraints(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  height: 60,
                                  width: 60,
                                  child: OnlineImage(
                                    imageUrl: '${authcontroller.user.value.image}',
                                    borderRadius: BorderRadius.circular(60),
                                  ),
                                ),
                                Gap(16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${authcontroller.user.value.fullName ??''}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Get.textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Palette.BLACK),
                                    ),
                                    Text(
                                      '${authcontroller.user.value.defaultPosition?.position ??'Super Admin'}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Get.textTheme.bodySmall
                                          ?.copyWith(color: Palette.BLACK),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            GetBuilder<NotificationController>(
                              builder: (notificationController) {
                                return NotificationBadgeGlobal( value: notificationController.notifications
        .where((notification) => notification.read_at == null)
        .map((notification) => notification.id)
        .toList().length, action:  () {

                      Get.to(() =>  NotificationPage(),
                          transition: Transition.cupertino);
                    });
                              }
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
      }
    );
  }
}