
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/images/local_lottie_image.dart';
import 'package:get/get.dart';

class ComingSoon extends StatelessWidget {
const ComingSoon({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Container(),
          Gap(16),
          Text('COMING SOON', style: Get.textTheme.titleLarge?.copyWith(),),
          Gap(16),
          LocalLottieImage(imagePath: lottiesPath('coming-soon.json'),),
        ],
      );
  }
}