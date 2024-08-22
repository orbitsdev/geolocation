import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/shared/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

class EventTimeLineTileActive extends StatelessWidget {
  const EventTimeLineTileActive({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TimelineTile(
        beforeLineStyle: LineStyle(
          thickness: 0.5,
          color: Colors.transparent, // Replace Palette.ORANGE with a color
        ),
        afterLineStyle: LineStyle(
          thickness: 0.5,
          color: Colors.transparent,
        ),
        lineXY: 0.3,
        indicatorStyle: IndicatorStyle(
           
            indicator: Container(),),
            // indicator: AvatarGlow(
            //   startDelay: const Duration(milliseconds: 2000),
            //   glowColor: Palette.ACTIVE,
            //   glowShape: BoxShape.circle,
            //   animate: true,
            //   curve: Curves.fastOutSlowIn,
            //   child: ClipOval(
            //     child: Container(
            //       color: Palette.ACTIVE,
            //       child: Center(
            //           child: Icon(
            //         Icons.circle,
            //         color: Palette.ACTIVE,
            //         size: 0,
            //       )),
            //     ),
            //   ),
            // )),
        alignment: TimelineAlign.manual,
        endChild: Container(

          // decoration: BoxDecoration(
          //     color: Palette.BACKGROUND,
          //     borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints(
            minWidth: 220,
            minHeight: 90
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(6),
                              Container(
                                height: 1,
                                color: Palette.LIGH_BACKGROUND,
                              ),
                          Gap(8),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Palette.LIGH_BACKGROUND_GREEN2,
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: Get.size.width,),
                        Text(
                          'Assembly Meetings',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                                     
                        SizedBox(height: 8.0),
                        Text(
                          '09:00 - 11:30',
                          style: Get.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                
                top: 8,
                right: 8,
                child: AvatarGlow(
                          startDelay: const Duration(milliseconds: 2000),
                          glowColor: Palette.ACTIVE,
                          glowShape: BoxShape.circle,
                          animate: true,
                          curve: Curves.fastOutSlowIn,
                          child: ClipOval(
                            child: Container(
                              height: 16,
                              width: 16,
                              color: Palette.ACTIVE,
                              
                            ),
                          ),
                        ))
            ],
          ),
        ),
        startChild: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 50, // Minimum width
            maxWidth: 80, // Maximum width
          ),
          child: Container(
           
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jan 24, 2024',
                  style: Get.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
