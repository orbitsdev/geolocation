import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/auth/model/user.dart';
import 'package:geolocation/features/auth/pages/switch_position_page.dart';
import 'package:geolocation/features/profile/edit_profile_page.dart';
import 'package:geolocation/features/reports/report_controller.dart';
import 'package:get/get.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.FBG,
      appBar: AppBar(
        
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Palette.gray900),
          onPressed: () => Get.back(),
        ),
        title: const Text(
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
                  const Gap(16),
                  _buildUserDetails(user),
                  if (defaultPosition != null) _buildCouncilDetailsCard(defaultPosition),
                  if ((user.councilPositions ?? []).isNotEmpty) _buildActionButtons(),
                    const Gap(16),
                  if (defaultPosition != null) _buildDownloadSection(defaultPosition),
                    const Gap(16),
                  _buildLogoutButton(controller),
                  const Gap(16),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: const Center(
            child: Text(
              "Geolocation v1.0.0",
              style: TextStyle(color: Palette.gray600, fontSize: 12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetails(User user) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Palette.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
                  onTap: () => Get.to(() => EditProfilePage()),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Palette.deYork600,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.edit,
                      size: 20,
                      color: Palette.gray50,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          Text(
            user.fullName ?? 'N/A',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Palette.gray900,
            ),
          ),
          Text(
            user.email ?? 'N/A',
            style: const TextStyle(fontSize: 16, color: Palette.gray600),
          ),
        ],
      ),
    );
  }

  Widget _buildCouncilDetailsCard(CouncilPosition defaultPosition) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Palette.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            defaultPosition.councilName ?? "No Council",
            style:  TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Palette.deYork700,
            ),
          ),
          const Gap(8),
          Text(
            defaultPosition.position ?? "No Position",
            style: const TextStyle(fontSize: 14, color: Palette.gray600),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Palette.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: TextButton.icon(
        onPressed: () => Get.to(() => SwitchPositionPage()),
        icon:  Icon(Icons.swap_horiz, color: Palette.deYork500),
        label:  Text(
          "Switch Position",
          style: TextStyle(fontSize: 16, color: Palette.deYork500),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          backgroundColor: Palette.deYork50,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildDownloadSection(CouncilPosition defaultPosition) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Palette.gray300.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildActionTile(
            icon: Icons.download,
            color: Colors.orange.shade700,
            backgroundColor: Colors.orange.shade50,
            title: 'Download Attendance',
            subtitle: 'Get attendance records for your current council position.',
            onTap: () {
              ReportController.controller.exportAttendanceByCouncilPosition(
                councilId: defaultPosition.councilId!,
                councilPositionId: defaultPosition.id!,
              );
            },
          ),
          const Divider(height: 1, color: Palette.gray100),
          _buildActionTile(
            icon: Icons.download,
            color: Colors.green.shade700,
            backgroundColor: Colors.green.shade50,
            title: 'Download Tasks',
            subtitle: 'Export tasks assigned to your current council position.',
            onTap: () {
              ReportController.controller.exportTasksByCouncilPosition(
                councilPositionId: defaultPosition.id!,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(AuthController controller) {
    return _buildListTile(
      icon: Icons.logout,
      title: "Log Out",
      color: Palette.deYork700,
      onTap: () => controller.logout(),
    );
  }

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
            offset: const Offset(0, 4),
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

  Widget _buildActionTile({
    required IconData icon,
    required Color color,
    required Color backgroundColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(subtitle),
      onTap: onTap,
    );
  }
}
