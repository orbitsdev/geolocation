import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/council_positions/pages/create_or_edit_council_member_page.dart';
import 'package:geolocation/features/council_positions/pages/council_member_profile_page.dart';
import 'package:geolocation/features/council_positions/widget/council_position_card.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:get/get.dart';

class CouncilMemberPositionListPage extends StatefulWidget {
  @override
  _CouncilMemberPositionListPageState createState() => _CouncilMemberPositionListPageState();
}

class _CouncilMemberPositionListPageState extends State<CouncilMemberPositionListPage> {
  final CouncilPositionController _controller = Get.put(CouncilPositionController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load initial council positions if the list is empty
      if (_controller.positions.isEmpty) {
        _controller.loadCouncilPositions();
      }

      // Add scroll listener for infinite scrolling
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 &&
            !_controller.isFetchingMore.value &&
            !_controller.isLastPage.value) {
          _controller.loadMoreCouncilPositions(); // Load more positions on scroll
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.LIGHT_BACKGROUND,
      appBar: AppBar(
        title: const Text('Members'),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => CreateOrEditCouncilMemberPage(), transition: Transition.cupertino);
            },
            child: Text(
              'New Member',
              style: Get.textTheme.bodyMedium?.copyWith(color: Palette.PRIMARY),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _controller.loadCouncilPositions(); // Reload positions on pull-down refresh
        },
        child: Obx(() {
          if (_controller.isLoadingCouncilPositions .value && _controller.positions.isEmpty) {
            return const Center(child: CircularProgressIndicator()); // Initial loading
          } else if (_controller.errorMessage.isNotEmpty) {
            return Center(child: Text(_controller.errorMessage.value)); // Show error message
          } else if (_controller.positions.isEmpty) {
            return const Center(child: Text('No members found')); // No data available
          } else {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent &&
                    !_controller.isFetchingMore.value &&
                    !_controller.isLastPage.value) {
                  _controller.loadMoreCouncilPositions(); // Load more positions when scrolled to the end
                  return true;
                }
                return false;
              },
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(), // Ensure it's always scrollable
                itemCount: _controller.positions.length + 1, // +1 for loading indicator at the end
                itemBuilder: (context, index) {
                  if (index == _controller.positions.length) {
                    // Show loading indicator at the bottom while fetching more data
                    return _controller.isFetchingMore.value
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink(); // Empty space if not fetching more
                  }

                  final position = _controller.positions[index];

                  // Ensure position.id is passed correctly for delete
                  return RippleContainer(
                    onTap: () => Get.to(
                      () => CouncilMemberProfilePage(),
                      transition: Transition.cupertino,
                    ),
                    child: CouncilPositionCard(
                      position: position,
                      onEdit: () {
                        Get.to(() => CreateOrEditCouncilMemberPage(position: position));
                      },
                      onDelete: () {
  if (position.id != null) {
    Modal.confirmation(
      titleText: "Confirm Delete",
      contentText: "Are you sure you want to delete this council position?",
      onConfirm: () {
        _controller.deleteCouncilPosition(position.id!); // Proceed with deletion if confirmed
      },
      onCancel: () {
        Get.back();
      },
    );
  }


                      },
                    ),
                  );
                },
              ),
            );
          }
        }),
      ),
    );
  }
}
