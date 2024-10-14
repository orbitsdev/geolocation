import 'package:flutter/material.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/councils/pages/council_form_page.dart';
import 'package:geolocation/features/council_positions/pages/council_member_position_list_page.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/councils/controller/council_controller.dart';

class CouncilListPage extends StatelessWidget {
  final CouncilController _councilController = Get.put(CouncilController());
  final CouncilPositionController positionController = Get.find<CouncilPositionController>();
  final ScrollController _scrollController = ScrollController(); // Add ScrollController

  @override
  Widget build(BuildContext context) {
    // Add scroll listener to load more data when reaching the bottom
    _scrollController.addListener(() {
      double threshold = 200.0;
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - threshold &&
          !_councilController.isFetchingMore &&
          !_councilController.isLastPage) {
        _councilController.loadMoreCouncils(); // Load more councils
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Councils'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(() => CouncilFormPage(isEdit: false), transition: Transition.cupertino);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _councilController.loadCouncils(); // Reload councils on refresh
        },
        child: GetBuilder<CouncilController>(
          builder: (controller) {
            if (controller.isLoading) {
              return Center(child: CircularProgressIndicator()); // Show initial loading indicator
            } else if (controller.errorMessage.isNotEmpty) {
              return Center(child: Text(controller.errorMessage));
            } else if (controller.councils.isEmpty) {
              return Center(child: Text('No councils available.'));
            }

            return ListView.builder(
              controller: _scrollController, // Attach ScrollController
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: controller.councils.length + 1, // +1 for loading indicator at the end
              itemBuilder: (context, index) {
                if (index == controller.councils.length) {
                  return controller.isFetchingMore
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink(); // Empty space if not fetching more
                }

                final council = controller.councils[index];
                return ListTile(
                  onTap: () {
                    positionController.councilId.value = council.id!; // Set the new council ID
                    positionController.clearCouncilPositions(); // Clear previous council data
                    Get.to(() => CouncilMemberPositionListPage(), transition: Transition.cupertino);
                  },
                  title: Text(council.name ?? 'Unnamed Council'),
                  subtitle: Text('Created at: ${council.createdAt ?? 'Unknown'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Get.to(() => CouncilFormPage(isEdit: true, councilId: council.id!),
                              transition: Transition.cupertino);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          controller.deleteCouncil(council.id!);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
