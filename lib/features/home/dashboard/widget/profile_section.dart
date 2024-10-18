import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/localdata/sample_data.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/notification/notification_page.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class ProfileSection extends StatelessWidget {
const ProfileSection({ Key? key }) : super(key: key);


  @override
  Widget build(BuildContext context){
    var authcontroller = Get.find<AuthController>();
    return Obx(
      ()=> ToSliver(
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
                        RippleContainer(
                          onTap: () => Get.to(() => NotificationPage(),
                              transition: Transition.cupertino),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Palette.LIGH_BACKGROUND,
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: SizedBox(
                              height: 60,
                              width: 60,
                              child: Stack(
                                clipBehavior:
                                    Clip.none, // Ensure the badge is not clipped
                                children: [
                                  Center(
                                    child: HeroIcon(
                                      HeroIcons.bell,
                                      color: Palette.BLACK,
                                    ),
                                  ),
                                  if (notifications.isNotEmpty)
                                    Positioned(
                                      top: 4,
                                      right:
                                          8, // Adjusted position to make sure the badge appears correctly
                                      child: Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Palette.ORANGE_DARK,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        constraints: BoxConstraints(
                                          minWidth: 14,
                                          minHeight: 14,
                                        ),
                                        child: Text(
                                          '${notifications.length}',
                                          style: Get.textTheme.bodySmall
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}