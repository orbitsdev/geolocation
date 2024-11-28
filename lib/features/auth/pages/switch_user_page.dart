import 'package:flutter/material.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/user.dart';

class SwitchUserPage extends StatelessWidget {
  final User user;
  const SwitchUserPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Switch User', style: TextStyle(color: Colors.white)),
        backgroundColor: Palette.PRIMARY,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Current User Section
          _buildCurrentUserSection(user),
          Divider(),
          // Council Positions Section
          Expanded(
            child: Obx(() {
              final councilPositions = controller.user.value?.councilPositions ?? [];
              return ListView.builder(
                itemCount: councilPositions.length,
                itemBuilder: (context, index) {
                  final position = councilPositions[index];
                  return _buildPositionTile(
                    position: position,
                    isActive: position.isLogin ?? false,
                    onTap: () => _handleSwitchPosition(controller, position.id!),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Build Current User Section
  Widget _buildCurrentUserSection(User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(user.image ?? ''),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName ?? 'Full Name',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                user.email ?? 'email@example.com',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.PRIMARY,
                  foregroundColor: Colors.white,
                ),
                child: const Text('My Account'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build Position Tile
  Widget _buildPositionTile({
    required CouncilPosition position,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: isActive ? Palette.PRIMARY : Colors.grey[300],
        child: Icon(
          isActive ? Icons.check : Icons.person_outline,
          color: Colors.white,
        ),
      ),
      title: Text(
        position.position ?? 'Unknown Position',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        position.councilName ?? 'Unknown Council',
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: isActive
          ?  Text(
              'Current',
              style: TextStyle(color: Palette.PRIMARY, fontWeight: FontWeight.bold),
            )
          : null,
      onTap: isActive ? null : onTap,
    );
  }

  // Handle Switch Position with Loading Modal
  void _handleSwitchPosition(AuthController controller, int positionId) {
    Modal.confirmation(
      titleText: 'Switch Position',
      contentText: 'Are you sure you want to switch to this position?',
      onConfirm: () => controller.switchPosition(positionId),
    );
  }
}
