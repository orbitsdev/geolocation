// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:get/get.dart';

class OfficerCard extends StatelessWidget {

  CouncilPosition officer;
   OfficerCard({
    Key? key,
    required this.officer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
         
          boxShadow: [
            // BoxShadow(
            //   color: Colors.grey.withOpacity(0.1),
            //   spreadRadius: 3,
            //   blurRadius: 5,
            //   offset: Offset(0, 2),
            // ),
          ],
        ),
        width: Get.size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image
           Container(
            width: 90,
            height: 90,
            child: OnlineImage(imageUrl: '${officer.image}')),
            const SizedBox(height: 12),
      
            // Name
             Text(
              '${officer.fullName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
      
            // Job Title
            const SizedBox(height: 4),
             Text(
              '(${officer.position})',
              style: TextStyle(
                fontSize: 14,
                color: Palette.lightText,
              ),
              textAlign: TextAlign.center,
            ),
            Gap(4),
             Text(
              '(${officer.email})',
              style: Get.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
      
            // Experience
            
          ],
        ),
      );
  }
}
