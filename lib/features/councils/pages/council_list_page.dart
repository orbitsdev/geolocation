import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/council_positions/pages/council_member_position_list_page.dart';
import 'package:geolocation/features/councils/model/council.dart';
import 'package:geolocation/features/councils/pages/council_form_page.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/councils/controller/council_controller.dart';

class CouncilListPage extends StatefulWidget {
  @override
  State<CouncilListPage> createState() => _CouncilListPageState();
}

class _CouncilListPageState extends State<CouncilListPage> {
  final CouncilController _councilController = Get.put(CouncilController());

  final CouncilPositionController positionController = Get.find<CouncilPositionController>();

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
 _councilController.fetchCouncils();
    _scrollController.addListener(() {
      // Scroll threshold of 200 pixels before bottom to trigger loading more councils
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
          !_councilController.isFetchingMore.value &&
          _councilController.councils.length < _councilController.totalItems.value) {
        _councilController.fetchCouncilsOnScroll(); // Load more councils when scrolling to the bottom
      }
    });
    });
   

    return Scaffold(
      appBar: AppBar(
        title: const Text('Councils'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => CouncilFormPage(isEdit: false), transition: Transition.cupertino);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _councilController.reloadCouncils(); // Reload councils on refresh
        },
        child: Obx(() {
          // Show loading indicator while loading
          if (_councilController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show empty state if no councils are available
          if (_councilController.councils.isEmpty) {
            return const Center(child: Text('No councils available.'));
          }

          // Show the list of councils
          return ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh
            itemCount: _councilController.councils.length + 1, // Add 1 for the loading indicator at the end
            itemBuilder: (context, index) {
              if (index == _councilController.councils.length) {
                return _councilController.isFetchingMore.value
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()), // Show loading indicator at the bottom
                      )
                    : const SizedBox.shrink(); // No additional data to load
              }

            Council council = _councilController.councils[index];

           return Slidable(
                          key: const ValueKey(0),
                          startActionPane: null,
                          endActionPane: ActionPane(
                            motion: ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  _councilController.deleteCouncil(council.id!);
                                },
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child:ListTile(
                onTap: () {
                  positionController.selectAndNavigateToCouncilMemberPage(council.id ?? 0); // Set council ID and navigate
                },
                title: Text(council.name ?? 'Unnamed Council'),
                subtitle:(council.councilPositions == null || (council.councilPositions??[]).isEmpty) ? null : Text('Members  (${council.councilPositions?.length ?? 0})'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Get.to(() => CouncilFormPage(isEdit: true, councilId: council.id!),
                            transition: Transition.cupertino);
                      },
                    ),
                    
                  ],
                ),
              )
  //                          Container(
  //   width: double.infinity,  // Use double.infinity for full width without explicit Get.size.width
  //   padding: const EdgeInsets.all(8),
  //   decoration: BoxDecoration(
  //     color: Colors.white,  // Add a background color for better contrast
  //     borderRadius: BorderRadius.circular(8),
  //     boxShadow: [
  //       BoxShadow(
  //         color: Colors.grey.withOpacity(0.1),  // Light shadow for subtle depth
  //         spreadRadius: 1,
  //         blurRadius: 5,
  //         offset: Offset(0, 3),  // Shadow position
  //       ),
  //     ],
  //   ),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     children: [
  //       Text(
  //         council.name ?? 'Unnamed Council',  // Add fallback text for null name
  //         style: Get.textTheme.titleMedium?.copyWith(
  //           fontWeight: FontWeight.bold,  // Bold for improved readability
  //         ),
  //       ),
  //       Text(
  //         'Members: ${council.councilPositions?.length ?? 0}',
  //         style: Get.textTheme.bodyMedium?.copyWith(
  //           color: Palette.TEXT_LIGHT,
  //         ),
  //       ),
  //     ],
  //   ),
  // ),
                        );
              
            },
          );
        }),
      ),
    );
  }
}
