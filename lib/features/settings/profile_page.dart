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
      appBar: AppBar(
        
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Palette.FBG
      
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GetBuilder<AuthController>(
            builder: (controller) {
              final user = controller.user.value;
              final defaultPosition = user.defaultPosition;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  // User Details Section
                  _buildUserDetails(user),

                  const Gap(20),
                  Divider(color: Colors.grey.shade300, thickness: 1),

                  // Council Details Section
                  if (defaultPosition != null) _buildCouncilDetailsCard(defaultPosition),

                  const Gap(20),
                  Divider(color: Colors.grey.shade300, thickness: 1),

                  // Action Buttons Section
                  _buildActionButtons(controller),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // User Details Section
  Widget _buildUserDetails(User user) {
    return Center(
      child: Column(
        children: [
          Container(
            height: 100,
            width: 100,
           
            child: OnlineImage(imageUrl: '${user.image}'),
          ),
          const Gap(10),
          Text(
            "${user.fullName}",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${user.email}",
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
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
        borderRadius: BorderRadius.circular(12),
     ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              defaultPosition.councilName ?? "No Council",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              defaultPosition.position ?? "No Position",
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Action Buttons Section
  Widget _buildActionButtons(AuthController controller) {
    return Column(
      children: [
        // Switch Position Button
        TextButton.icon(
          onPressed: () {
            Get.to(()=> SwitchPositionPage());
            // Add logic for switching position or account
          },
          icon: const Icon(
            Icons.swap_horiz,
            color: Colors.green,
          ),
          label: const Text(
            "Switch Position",
            style: TextStyle(
              fontSize: 16,
              color: Colors.green,
            ),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            backgroundColor: Colors.green.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const Gap(10),
        Divider(color: Colors.grey.shade300, thickness: 1),

        // Edit Profile and Log Out Buttons
        _buildListTile(
          icon: Icons.edit,
          title: "Edit Profile",
          onTap: () {
            Get.to(()=>  EditProfilePage());
          },
        ),
        _buildListTile(
          icon: Icons.logout,
          title: "Log Out",
          onTap: () {
            controller.logout();
          },
        ),
      ],
    );
  }

  // Reusable ListTile for Action Options
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Palette.PRIMARY),
      title: Text(title),
      trailing:  Icon(Icons.arrow_forward_ios, size: 16, color: Palette.FBG,),
      onTap: onTap,
    );
  }
}
