import 'package:flutter/material.dart';
import 'package:geolocation/features/councils/pages/council_form_page.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/councils/controller/council_controller.dart';

class CouncilListPage extends StatelessWidget {
  final CouncilController _councilController = Get.put(CouncilController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Councils'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Navigate to the council creation form (to be implemented later)
               Get.to(() => CouncilFormPage(isEdit: false), transition: Transition.cupertino);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_councilController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (_councilController.errorMessage.isNotEmpty) {
          return Center(child: Text(_councilController.errorMessage.value));
        } else if (_councilController.councils.isEmpty) {
          return Center(child: Text('No councils available.'));
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                !_councilController.isFetchingMore.value) {
              _councilController.loadMoreCouncils(); // Load more councils when scrolled to the bottom
              return true;
            }
            return false;
          },
          child: ListView.builder(
            itemCount: _councilController.councils.length + 1, // +1 for loading indicator
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
                title: Text(council.name ?? 'Unnamed Council'),
                subtitle: Text('Created at: ${council.createdAt ?? 'Unknown'}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {// Navigate to the edit form (to be implemented later)
                       Get.to(() => CouncilFormPage(isEdit: true, councilId: council.id!), transition: Transition.cupertino);
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
