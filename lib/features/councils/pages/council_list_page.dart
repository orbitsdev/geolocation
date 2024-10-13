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
    // Initialize the scroll controller to listen for scroll events
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_councilController.isFetchingMore.value &&
          !_councilController.isLastPage.value) {
        // If the user is 200 pixels away from the bottom, load more councils
        _councilController.loadMoreCouncils();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Councils'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(() => CouncilFormPage(isEdit: false),
                  transition: Transition.cupertino);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_councilController.isLoading.value) {
          return Center(child: CircularProgressIndicator()); // Show initial loading indicator
        } else if (_councilController.errorMessage.isNotEmpty) {
          return Center(child: Text(_councilController.errorMessage.value));
        } else if (_councilController.councils.isEmpty) {
          return Center(child: Text('No councils available.'));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (_scrollController.position.pixels ==
                _scrollController.position.maxScrollExtent &&
                !_councilController.isFetchingMore.value &&
                !_councilController.isLastPage.value) {
              // Trigger load more when scroll reaches the end
              _councilController.loadMoreCouncils();
              return true;
            }
            return false;
          },
          child: ListView.builder(
            controller: _scrollController, // Attach ScrollController here
            itemCount: _councilController.councils.length + 1, // +1 for loading indicator at the end
            itemBuilder: (context, index) {
              if (index == _councilController.councils.length) {
                return _councilController.isFetchingMore.value
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : SizedBox.shrink(); // Hide if not fetching more
              }

              final council = _councilController.councils[index];
              return ListTile(
                onTap: (){
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
                        _councilController.deleteCouncil(council.id!);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
