import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';

class ProfilePage extends GetView<AuthController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Palette.PRIMARY,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Section
              Container(
                padding: const EdgeInsets.all(16),
                color: Palette.PRIMARY,
                child: Row(
                  children: [
                    // User Avatar
                    SizedBox(
                      width: 70,
                      height: 70,
                      child: OnlineImage(
                        borderRadius: BorderRadius.circular(45),
                        imageUrl: '${controller.user.value?.image}',
                      ),
                    ),
                    const SizedBox(width: 16),
                    // User Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.user.value?.fullName ?? 'Full Name',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.user.value?.email ?? 'email@example.com',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed('/edit-profile');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Palette.PRIMARY,
                            ),
                            child: const Text('Edit Profile'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Council Positions Section
              _buildSectionHeader('COUNCIL POSITIONS'),
              Obx(
                () {
                  final positions = controller.user.value?.councilPositions ?? [];
                  if (positions.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No council positions found.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: positions.length,
                    itemBuilder: (context, index) {
                      final position = positions[index];
                      return ListTile(
                        leading: Icon(
                          position.isLogin == true
                              ? Icons.check_circle
                              : Icons.circle,
                          color: position.isLogin == true
                              ? Palette.PRIMARY
                              : Colors.grey,
                        ),
                        title: Text(
                          position.position ?? 'Unknown Position',
                          style: const TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          '${position.councilName}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          // Switch position
                          controller.switchPosition(position.id!);
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // Logout Section
              _buildSettingsItem(
                icon: Icons.logout,
                text: 'Logout',
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () {
                  controller.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build settings items
  Widget _buildSettingsItem({
    required IconData icon,
    required String text,
    Color textColor = Colors.black,
    Color iconColor = Colors.black,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Helper widget to build section header
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Palette.LIGHT_BACKGROUND,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
