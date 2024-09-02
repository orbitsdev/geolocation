import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/profile/controller/profile_controller.dart';
import 'package:geolocation/features/profile/edit_profile_page.dart';
import 'package:get/get.dart';

class UserProfilePage extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Palette.PRIMARY, Palette.DARK_PRIMARY],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  
                  Positioned(
                    top: 130,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(controller.userProfile.value.profileImageUrl),
                          backgroundColor: Palette.LIGHT_BACKGROUND,
                        ),
                        SizedBox(height: 8),
                        Text(
                          controller.userProfile.value.fullName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          '@${controller.userProfile.value.email.split('@').first}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Palette.LIGHT_TEXT,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 130,
                    right: 16,
                    child: IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        Get.to(() => EditProfilePage());
                      },
                    ),
                  ),
                  
                ],
              ),
              SizedBox(height: 60), // Adjust this based on the height of the profile image
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(Get.size.height * 0.10),
                    _buildProfileDetail('Council Position', controller.userProfile.value.councilPosition),
                    _buildProfileDetail('Year', controller.userProfile.value.year),
                    _buildProfileDetail('Email', controller.userProfile.value.email),
                    // Add more fields if necessary
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            _getIconForLabel(label),
            color: Palette.PRIMARY,
            size: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: Palette.DARK_PRIMARY,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Council Position':
        return Icons.work;
      case 'Year':
        return Icons.calendar_today;
      case 'Email':
        return Icons.email;
      default:
        return Icons.info;
    }
  }
}
