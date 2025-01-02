// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class NotificationBadgeGlobal extends StatelessWidget {

  final int value;
  final VoidCallback action;
   Color? badgeColor; 
   Color? textColor; 
   Color? color; 
   double? width;
   double? height;
   double? iconSize;
   
   NotificationBadgeGlobal({
    Key? key,
    required this.value,
    required this.action,
    this.badgeColor,
    this.textColor,
    this.color,
    this.width,
    this.height,
    this.iconSize,
  }) : super(key: key);
  @override
  Widget build(BuildContext context){
    return RippleContainer(
                                  onTap:  action,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      // color: Palette.LIGH_BACKGROUND,
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    child: SizedBox(
                                      height:60,
                                      width: 60,
                                      child: Stack(
                                        clipBehavior:
                                            Clip.none, // Ensure the badge is not clipped
                                        children: [
                                          Center(
                                            child: HeroIcon(
                                              size: iconSize ?? 24,
                                              // style:HeroIconStyle.solid,
                                              HeroIcons.bell,
                                              color: color ?? Palette.BLACK,
                                              // color: Palette.BLACK,
                                            ),
                                          ),
                                          if (value > 0)
                                            Positioned(
                                              top: 4,
                                              right:
                                                  8, // Adjusted position to make sure the badge appears correctly
                                              child: Container(
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Palette.ORANGE_DARK,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                constraints: BoxConstraints(
                                                  minWidth: 14,
                                                  minHeight: 14,
                                                ),
                                                child:Text( value > 0 ? '$value': '0',
  style: Get.textTheme.bodySmall?.copyWith(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
  textAlign: TextAlign.center,
),

                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
  }
}
