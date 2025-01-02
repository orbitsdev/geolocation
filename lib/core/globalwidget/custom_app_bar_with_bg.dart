// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';



class CustomAppBarWithBg extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return ToSliver(child: Container(
          color: Palette.BG_DARK,
          height: Get.size.height * 0.23,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
            
              Positioned.fill(
                top: 5,
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2),
                    margin: EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    // padding: globalPadding,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(18),
                          bottomRight: Radius.circular(10)),
                    ),
                    height: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        
                       
                      ],
                    ),
                  )
                ,
              ),
            ],
          ),
        ));
  }
}
