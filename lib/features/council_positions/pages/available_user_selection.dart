import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/auth/model/available_user.dart';

class AvailableUserSelectionPage extends StatefulWidget {
  @override
  _AvailableUserSelectionPageState createState() =>
      _AvailableUserSelectionPageState();
}

class _AvailableUserSelectionPageState extends State<AvailableUserSelectionPage> {
  final CouncilPositionController controller =
      Get.find<CouncilPositionController>();
  final TextEditingController searchController = TextEditingController();
  final int debounceMilliseconds = 300;

  @override
  void initState() {
    super.initState();
    // Fetch users initially when the page is opened
    controller.searchAvailableUsers('');
    debounceSearch();
  }

  void debounceSearch() {
    searchController.addListener(() {
      final query = searchController.text.trim();
      Future.delayed(Duration(milliseconds: debounceMilliseconds), () {
        if (searchController.text.trim() == query) {
          controller.searchAvailableUsers(query);
        }
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose(); // Dispose of controller to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.gray100, // Subtle gray background
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text('Select User'),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 60),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
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
        if (controller.isFetchingUsers.value || controller.isSearchingUsers.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.filteredUsers.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        return ListView.separated(
          itemCount: controller.filteredUsers.length,
          separatorBuilder: (context, index) => Divider(
            color: Palette.gray200, // Divider color for distinction
            thickness: 0.5,
            height: 1,
          ),
          itemBuilder: (context, index) {
            final AvailableUser user = controller.filteredUsers[index];
            return ListTile(
              tileColor: Colors.white,
              leading: Container(
                width: 40,
                height: 40,
                child: OnlineImage(imageUrl: '${user.image}'),
              ),
              title: Text(
                '${user.firstName} ${user.lastName}',
                style: TextStyle(color: Palette.text),
              ),
              subtitle: Text(
                user.email ?? '',
                style: TextStyle(color: Palette.lightText),
              ),
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
