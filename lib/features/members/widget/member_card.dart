// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/constant/style.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';

import 'package:geolocation/features/members/model/member.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class MemberCard extends StatelessWidget {
  final Member member;
  const MemberCard({
    Key? key,
    required this.member,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(60)),
                height: 60,
                width: Get.size.width / 6,
                child: OnlineImage(
                  imageUrl: 'https://i.pravatar.cc/300',
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              Gap(16),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${member.name ?? ''}',
                      style: Get.textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Mayor',
                      style: Get.textTheme.bodyLarge
                          ?.copyWith(color: Palette.TEXT_LIGHT),
                    ),
                  ],
                ),
              )
            ],
          ),
          // Gap(16),
          // Text('${member.position}')
          // Container(
          //   width: Get.size.width,
          //   decoration: BoxDecoration(
          //       color: Palette.LIGHT_BACKGROUND,
          //       borderRadius: BorderRadius.circular(10)),
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Row(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 8),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               children: [
          //                 Text('Submitted Task',
          //                     style: Get.textTheme.bodyLarge
          //                         ?.copyWith(fontWeight: FontWeight.bold)),
          //                 Text('21'),
          //               ],
          //             ),
          //           ),
          //           Padding(
          //             padding: const EdgeInsets.symmetric(horizontal: 8),
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: MainAxisAlignment.start,
          //               children: [
          //                 Text('Remaining Task',
          //                     style: Get.textTheme.bodyLarge
          //                         ?.copyWith(fontWeight: FontWeight.bold)),
          //                 Text('21'),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //       Gap(16),
                
          //     ],
          //   ),
          // )
          // SizedBox(
          //         height: 45,
          //         width: Get.size.width,
          //         child: ElevatedButton(
          //             onPressed: () {},
          //             style: ELEVATED_BUTTON_STYLE_DARK,
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Text(
          //                   'View Details',
          //                   style: Get.textTheme.bodyLarge
          //                       ?.copyWith(color: Colors.white),
          //                 ),
          //                 Gap(2),
          //                 Icon(Icons.arrow_forward_ios_rounded, size: 14,)
          //               ],
          //             )),
          //       ),
        ],
      ),
    );
  }
}
