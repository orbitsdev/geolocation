// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/images/local_lottie_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';

class EmptyState extends StatelessWidget {
  String? label;
  String? path;
  EmptyState({
    Key? key,
    this.label ,
    this.path ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return   Container(
                    child: Column(
                      
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: Get.size.width,
                        ),
                        Gap(24),
                        LocalLottieImage(path: path?? lottiesPath('empty3.json') ),
                        Gap(8),
                        Text(textAlign: TextAlign.center, label ?? 'Empty', style: Get.textTheme.titleSmall!.copyWith(
                          color: Palette.TEXT_LIGHT,
                        ),),
                      ],
                    ),
                   );
  }
}
