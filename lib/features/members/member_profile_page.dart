import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/images/online_image_full_screen_display.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/task/task_page.dart';
import 'package:get/get.dart';

class MemberProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 RippleContainer(
                                      onTap: ()=> Get.to(()=>  OnlineImageFullScreenDisplay(imageUrl: 'https://i.pravatar.cc/300')),

                   child: Container(
                    height: 80,
                    width: 80,
                    
                    child: OnlineImage(imageUrl: 'https://i.pravatar.cc/300', borderRadius: BorderRadius.circular(100),),),
                 ),
                  SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'john.doe@example.com',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Mayor (2021-2024)',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              
              // Task Overview
              Text(
                'Task Overview',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTaskCard('Total Tasks', 120),
                  _buildTaskCard('Submitted', 90),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTaskCard('Remaining', 30),
                  _buildTaskCard('Due Soon', 10),
                ],
              ),
              
              // Biography Section
              SizedBox(height: 24),
              Text(
                'Biography',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'John Doe is a dedicated public servant with over 20 years of experience in municipal government. As the Mayor, he has led numerous initiatives aimed at improving the quality of life for residents...',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
              
              // Social Media Links Section
              SizedBox(height: 24),
              Text(
                'Social Media',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.link, color: Palette.DARK_PRIMARY),
                  SizedBox(width: 8),
                  Text(
                    'LinkedIn Profile',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(String title, int count,) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          Get.to(()=> TaskPage(), transition: Transition.cupertino);
        },
        child: Card(
          // color: Palette.LIGH_BACKGROUND_GREEN,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Palette.PRIMARY,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Palette.DARK_PRIMARY,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
