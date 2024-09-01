import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';

class MemberUserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              // Shadow and Border for the Profile Image
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
              ),
              // Profile Image with Border
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Palette.ACTIVE),
                  borderRadius: BorderRadius.circular(35),
                ),
                height: 70,
                width: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: OnlineImage(
                    imageUrl: 'https://i.pravatar.cc/300',
                  ),
                ),
              ),
            ],
          ),
          Gap(8),
          // Position or Title
          Text(
            'Mayor',
            style: Get.textTheme.bodySmall?.copyWith(
              color: Palette.LIGHT_TEXT,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
