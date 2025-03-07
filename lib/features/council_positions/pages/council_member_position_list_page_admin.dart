import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocation/core/globalwidget/empty_state.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/council_positions/pages/create_or_edit_council_member_page.dart';
import 'package:geolocation/features/council_positions/pages/council_member_profile_page.dart';
import 'package:geolocation/features/council_positions/widget/council_position_card.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:get/get.dart';

class CouncilMemberPositionListAdmin extends StatefulWidget {
  @override
  _CouncilMemberPositionListAdminState createState() =>
      _CouncilMemberPositionListAdminState();
}

class _CouncilMemberPositionListAdminState
    extends State<CouncilMemberPositionListAdmin> {
  final CouncilPositionController _controller =
      Get.put(CouncilPositionController());
  final ScrollController newScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_controller.councilMembers.isEmpty) {
        _controller.fetchCouncilMembers();
      }

      newScrollController.addListener(() async {
        if (newScrollController.position.pixels ==
            newScrollController.position.maxScrollExtent) {
          double threshold = 200.0;

          if (newScrollController.position.pixels >=
              newScrollController.position.maxScrollExtent - threshold) {
            _controller.fetchCouncilMembersOnScroll();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bg,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text('Admin Mimbers'),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => CreateOrEditCouncilMemberPage(),
                  transition: Transition.cupertino);
            },
            child: Text(
              'New Member',
              style:
                  Get.textTheme.bodyMedium?.copyWith(color: Palette.deYork600),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (_controller.isPageLoading.value) {
          return const Center(
              child: CircularProgressIndicator()); // Show loading indicator
        }
        if (_controller.councilMembers.isEmpty) {
          return EmptyState();
          // return const Center(
          //     child: Text('No members found')); // Show empty state
        }

        return RefreshIndicator(
  triggerMode: RefreshIndicatorTriggerMode.anywhere,
  onRefresh: () async {
    _controller.fetchCouncilMembers(); // Refresh the list on pull down
  },
  child: ListView.builder(
    controller: newScrollController,
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: _controller.councilMembers.length + 1, // +1 for the loading indicator
    itemBuilder: (context, index) {
      if (index == _controller.councilMembers.length) {
        return _controller.isScrollLoading.value
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ), // Show loading indicator at the end
              )
            : const SizedBox.shrink(); // No additional data to load
      }

      final position = _controller.councilMembers[index];

      return Column(
        children: [
          Slidable(
            key: ValueKey(position.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {
                    if (position.id != null) {
                      Modal.confirmation(
                        titleText: "Confirm Delete",
                        contentText:
                            "Are you sure you want to delete this member? All associated data, including files and records, will be permanently lost.",
                        onConfirm: () {
                          _controller.deleteCouncilPosition(position.id!);
                        },
                        onCancel: () {
                          Get.back();
                        },
                      );
                    }
                  },
                  backgroundColor: Palette.deYork900,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: RippleContainer(
              onTap: () {
                // Handle on-tap action for the council position card
              },
              child: CouncilPositionCard(
                position: position,
                onDelete: () {

                },
                onEdit: () {
                  Get.to(() =>
                      CreateOrEditCouncilMemberPage(position: position));
                },
              ),
            ),
          ),
          if (index < _controller.councilMembers.length - 1)
            Divider(
              color: Palette.gray200, // Divider color
              thickness: 0.8, // Divider thickness
            ),
        ],
      );
    },
  ),


        );
      }),
    );
  }
}
