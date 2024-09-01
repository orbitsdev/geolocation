import 'package:flutter/material.dart';
import 'package:geolocation/core/constant/style.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/images/online_image_full_screen_display.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/features/members/model/doctor.dart';
import 'package:get/get.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RippleContainer(
                                      onTap: ()=> Get.to(()=>  OnlineImageFullScreenDisplay(imageUrl: 'https://i.pravatar.cc/300')),

                  child: Container(
                    width: 50,
                    height: 50,
                    child: OnlineImage(
                      
                      imageUrl: 'https://i.pravatar.cc/300', borderRadius: BorderRadius.circular(30),),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Computer Studies Mayor',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4.0),
                    Text(
                      doctor.rating.toString(),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                       'Task Todo',
                      style: TextStyle(
                        fontSize: 14,
                        color: doctor.isAvailable ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total Submitted',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '21',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '300',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: () {
                
            //   },
            //  style: ELEVATED_BUTTON_STYLE2,
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text('View Profile', style: Get.textTheme.bodyMedium?.copyWith(
            //         color: Colors.white
            //       ),),
            //       SizedBox(width: 8.0),
            //       Icon(Icons.arrow_forward_ios_rounded,  color: Colors.white, size: 14,),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
