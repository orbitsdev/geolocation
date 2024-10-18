import 'package:flutter/material.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/images/local_image_widget.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class ForbiddenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.LIGH_BACKGROUND_GREEN2,
     
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the warning image
              LocalImage(imageUrl: imagePath('forbidden.png'),  fit: BoxFit.cover,),
              const SizedBox(height: 24),
              // Error message
              Text(
                '403 Forbidden Access',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Palette.DARK_PRIMARY,
                ),
              ),
              const SizedBox(height: 8),
              // Description
              Text(
                'You do not have permission to access this page.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Palette.LIGHT_TEXT,
                ),
              ),
              const SizedBox(height: 24),
              // "Back to Home" button
              SizedBox(
                width: double.infinity,
                child: GetBuilder<AuthController>(
                  builder: (controller) {
                    return ElevatedButton(
                        onPressed: () {
                          controller.logout(); 
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Palette.PRIMARY, // Button color
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Logout ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
