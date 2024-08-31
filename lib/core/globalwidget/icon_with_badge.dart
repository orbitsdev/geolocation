// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';

class IconWithBadge extends StatelessWidget {
  final Widget icon;
  final int value;
  final VoidCallback action;
   Color? badgeColor; 
   Color? textColor; 
   IconWithBadge({
    Key? key,
    required this.icon,
    required this.value,
    required this.action,
    this.badgeColor,
    this.textColor,
  }) : super(key: key);
  


  @override
  Widget build(BuildContext context){
    return  Stack(
            children: [
            SizedBox(
              
              child: Container(

                child: IconButton(onPressed: action, icon: icon,)),),
          if( value > 0) Positioned(
                   right: 8,
                top: 0,
                child:  Container(
                  padding: EdgeInsets.all(2),
                  // color: Colors.red,
                  decoration:  BoxDecoration(
                    // border: Border.all(color: Colors.white),
                    color:badgeColor ?? Palette.DARK_PRIMARY,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  constraints: BoxConstraints(
                 minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    value > 0 ? '$value': '',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],

      );
  }
}
