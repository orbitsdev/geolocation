import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MemberUserCard extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Container(
                      margin: EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                 
                                    border: Border.all(
                                        width: 2, color: Palette.ACTIVE),
                                    borderRadius: BorderRadius.circular(60)),
                                height: 60,
                                width: Get.size.width / 6,
                                child: OnlineImage(
                                  imageUrl: 'https://i.pravatar.cc/300',
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              // Text(data)
                            ],
                          ),
                          Gap(2),

                          Text('Mayor', style: Get.textTheme.bodySmall?.copyWith(color: Palette.LIGHT_TEXT),)
                        ],
                      ),
                    );
  }
}