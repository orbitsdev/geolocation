import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/auth/model/available_user.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:gap/gap.dart';

class AvailableUserSelectionPage extends StatelessWidget {
  final CouncilPositionController controller = Get.find<CouncilPositionController>();

  @override
  Widget build(BuildContext context) {
    // Fetch users initially when page is opened
    Future.delayed(Duration.zero, () {
      controller.searchAvailableUsers(''); // Pass empty query to load all users initially
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select User'),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) => controller.searchAvailableUsers(value), // Search as the user types
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingAvailableUsers.value || controller.isSearchingUsers.value) {
          return const Center(child: CircularProgressIndicator()); // Show loading spinner for both fetch and search
        }

        if (controller.filteredAvailableUsers.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        return ListView.builder(
          itemCount: controller.filteredAvailableUsers.length,
          itemBuilder: (context, index) {
            final AvailableUser user = controller.filteredAvailableUsers[index];
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                child: OnlineImage(imageUrl: '${user.image}')),
              title: Text('${user.firstName} ${user.lastName}'),
              subtitle: Text(user.email ?? ''),
              onTap: () {
                Get.back(result: user); // Return the selected user
              },
            );
          },
        );
      }),
    );
  }
}
