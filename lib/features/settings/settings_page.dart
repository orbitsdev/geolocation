import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';

class SettingsPage extends GetView<AuthController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Palette.PRIMARY,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Section
              Container(
                padding: EdgeInsets.all(16),
                color: Palette.PRIMARY,
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      child: OnlineImage(
                        borderRadius: BorderRadius.circular(45),
                        imageUrl: '${controller.user.value?.image}')),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${controller.user.value?.fullName}' ?? 'Full Name',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${controller.user.value?.email}' ?? 'email@example.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            // Navigate to the profile page
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Palette.PRIMARY,
                          ),
                          child: Text('View profile'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // General Section
              _buildSectionHeader('GENERAL'),
              _buildSettingsItem(
                icon: Icons.info_outline,
                text: 'About us',
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: Icons.subscriptions_outlined,
                text: 'Manage subscription',
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: Icons.notifications_outlined,
                text: 'Notification',
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: Icons.question_answer_outlined,
                text: 'FAQ',
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: Icons.contact_support_outlined,
                text: 'Contact',
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: Icons.feedback_outlined,
                text: 'Share Feedback',
                onTap: () {},
              ),
              _buildSettingsItem(
                icon: Icons.rule_outlined,
                text: 'Terms of service',
                onTap: () {},
              ),

              SizedBox(height: 24),

              // Logout Section
              _buildSettingsItem(
                icon: Icons.logout,
                text: 'Logout',
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () {
                  controller.logout(); // Call the logout function from the AuthController
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
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  // Helper widget to build section header
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Palette.LIGHT_BACKGROUND,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
