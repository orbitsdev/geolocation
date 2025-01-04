import 'package:flutter/material.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/images/local_image_widget.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/pages/switch_position_page.dart';
import 'package:get/get.dart';

class ForbiddenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Palette.LIGH_BACKGROUND_GREEN2,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: Get.size.height),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // User's Default Position Details
                  GetBuilder<AuthController>(
                    builder: (controller) {
                      final defaultPosition = controller.user.value.defaultPosition;
                      if (defaultPosition != null) {
                        return Column(
                          children: [
                            // Profile Image
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    height: 70,
                                    width: 70,
                                    child: OnlineImage(
                                      imageUrl: defaultPosition.image ?? '',
                                      borderRadius: BorderRadius.circular(50),
                                      fit: BoxFit.cover,
                                      noImageIconSize: 50,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Name and Role
                                  Text(
                                    defaultPosition.fullName ?? 'N/A',
                                    style: Get.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${defaultPosition.position ?? 'N/A'} - ${defaultPosition.councilName ?? 'N/A'}',
                                    style: Get.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Access Rights
                                  Text(
                                    defaultPosition.grantAccess == true
                                        ? "Granted"
                                        : "Restricted",
                                    style: Get.textTheme.bodySmall!.copyWith(
                                      color: defaultPosition.grantAccess == true
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Text(
                            'Default position not set. Please reach out to the administrator for assistance.',
                            textAlign: TextAlign.center,
                            style: Get.textTheme.bodyMedium,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Display the Forbidden Image
                  LocalImage(
                    height: 300,
                    imageUrl: imagePath('forbidden.png'),
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 24),
                  // Error Message
                  Text(
                    '403 Forbidden Access',
                    style: Get.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // "Switch Account" Button
                  GetBuilder<AuthController>(
                    builder: (authController) {
                      final hasPositions = (authController.user.value.councilPositions ?? []).isNotEmpty;

                      if (hasPositions) {
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => Get.to(() => SwitchPositionPage()),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Palette.ORANGE, // Button color
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Switch Account',
                                  style: Get.textTheme.bodyLarge!.copyWith(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Or',
                              style: Get.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 8),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        AuthController.controller.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.PRIMARY, // Button color
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: Get.textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
