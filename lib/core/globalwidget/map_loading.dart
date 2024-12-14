import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/images/local_lottie_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';

class MapLoading extends StatelessWidget {
 String? label;
  String? path;
  MapLoading({
    Key? key,
    this.label ,
    this.path ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
      return   Container(
                    child:  Center(
                      child: LocalLottieImage(
                        height: Get.size.height,
                        width: Get.size.width,
                        path: path?? lottiesPath('map.json') ),
                    ),
                   );
  }
}