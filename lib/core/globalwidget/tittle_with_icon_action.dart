// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:geolocation/core/theme/palette.dart';

class TittleWithIconAction extends StatelessWidget {
final String title;
final Function onTap;
   TittleWithIconAction({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context){
    return Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${title??''}',
                  style: Get.textTheme.titleLarge
                      ?.copyWith(
                        fontWeight: FontWeight.bold),
                ),

                GestureDetector(
                  onTap: (){
                    onTap();
                  },
                  child: Row(
                    children: [
                      Text('View All', style: Get.textTheme.bodyMedium?.copyWith(
                        color: Palette.LIGHT_TEXT
                      ),),
                      Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Palette.LIGHT_TEXT ,),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
