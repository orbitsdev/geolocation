import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/auth/model/user.dart';
import 'package:geolocation/features/auth/pages/switch_position_page.dart';
import 'package:geolocation/features/profile/edit_profile_page.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.gray100,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Palette.gray900),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "Profile",
          style: TextStyle(
            color: Palette.gray900,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GetBuilder<AuthController>(
            builder: (controller) {
              final user = controller.user.value;
              final defaultPosition = user.defaultPosition;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Gap(20),

                  // User Details Section
                  _buildUserDetails(user),

               
                  // Council Details Section
                  if (defaultPosition != null)
                    _buildCouncilDetailsCard(defaultPosition),

               
                  // Action Buttons Section
                  if ((controller.user.value.councilPositions ?? []).isNotEmpty)
                    _buildActionButtons(controller),

               
                  // Log Out Button
                  _buildListTile(
                    icon: Icons.logout,
                    title: "Log Out",
                    color: Palette.deYork700,
                    onTap: () {
                      controller.logout();
                    },
                  ),
                ],
              );
            },
          ),
          
        ),
        
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              "Geolocation v1.0.0",
              style: TextStyle(
                color: Palette.gray600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // User Details Section
  Widget _buildUserDetails(User user) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Palette.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                  width: 100,
                  height: 100,
                child: OnlineImage(
                  borderRadius: BorderRadius.circular(100),
                  imageUrl: user.image ?? '',
                
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => EditProfilePage());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Palette.deYork600,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: Palette.gray50,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(16),
          Text(
            user.fullName ?? 'N/A',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Palette.gray900,
            ),
          ),
          Text(
            user.email ?? 'N/A',
            style: TextStyle(
              fontSize: 16,
              color: Palette.gray600,
            ),
          ),
        ],
      ),
    );
  }

  // Council Details Card Section
  Widget _buildCouncilDetailsCard(CouncilPosition defaultPosition) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Palette.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            defaultPosition.councilName ?? "No Council",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Palette.deYork700,
            ),
          ),
          Gap(8),
          Text(
            defaultPosition.position ?? "No Position",
            style: TextStyle(
              fontSize: 14,
              color: Palette.gray600,
            ),
          ),
        ],
      ),
    );
  }

  // Action Buttons Section
  Widget _buildActionButtons(AuthController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Palette.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextButton.icon(
            onPressed: () {
              Get.to(() => SwitchPositionPage());
            },
            icon: Icon(
              Icons.swap_horiz,
              color: Palette.deYork500,
            ),
            label: Text(
              "Switch Position",
              style: TextStyle(
                fontSize: 16,
                color: Palette.deYork500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              backgroundColor: Palette.deYork50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable ListTile for Action Options
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Palette.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Palette.gray200,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(icon, color: Palette.gray900),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
