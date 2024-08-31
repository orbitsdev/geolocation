// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:geolocation/core/theme/palette.dart';

class OverAllCard extends StatelessWidget {
final String title;
final Widget icon;
   OverAllCard({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Palette.LIGH_BACKGROUND_GREEN,
                  borderRadius: BorderRadius.circular(20)),
              constraints: BoxConstraints(
                minHeight: 120,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '${title}',
                        style: Get.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Gap(8),
                    ],
                  ),

                    Gap(6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      
                 
                      Flexible(
                        child: Text(
                          '242',
                          style: Get.textTheme.displaySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                     icon,
                      // Container(
                      //   padding: EdgeInsets.all(8),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.circular(20)),
                      //   child: Row(
                      //     children: [
                      //       Container(
                      //         height: 14,
                      //         width: 14,
                      //         decoration: BoxDecoration(
                      //             color: Palette.ORANGE_DARK,
                      //             borderRadius: BorderRadius.circular(20)),
                      //       ),
                      //       Gap(8),
                      //       Text(
                      //         '24 Not Check',
                      //         style: Get.textTheme.bodySmall
                      //             ?.copyWith(fontWeight: FontWeight.bold),
                      //       ),
                      //     ],
                      //   ),
                      // )
                    ],
                  )
                ],
              ),
            ));
  }
}
