// import 'package:flutter/material.dart';
// import 'package:geolocation/core/globalwidget/empty_state.dart';
// import 'package:geolocation/core/globalwidget/ripple_container.dart';
// import 'package:geolocation/core/modal/modal.dart';
// import 'package:geolocation/core/theme/palette.dart';
// import 'package:geolocation/features/council_positions/pages/create_or_edit_council_member_page.dart';
// import 'package:geolocation/features/council_positions/pages/council_member_profile_page.dart';
// import 'package:geolocation/features/council_positions/widget/council_position_card.dart';
// import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
// import 'package:get/get.dart';

// class CouncilMemberPositionListPage extends StatefulWidget {
//   @override
//   _CouncilMemberPositionListPageState createState() =>
//       _CouncilMemberPositionListPageState();
// }

// class _CouncilMemberPositionListPageState
//     extends State<CouncilMemberPositionListPage> {
//   final CouncilPositionController _controller =Get.put(CouncilPositionController());
//   final ScrollController newScrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (_controller.councilMembers.isEmpty) {
//         _controller.fetchCouncilMembers();
//       }

//       newScrollController.addListener(() async {
//         if (newScrollController.position.pixels ==
//             newScrollController.position.maxScrollExtent) {
//           double threshold = 200.0;

//           if (newScrollController.position.pixels >=
//               newScrollController.position.maxScrollExtent - threshold) {
//             _controller.fetchCouncilMembersOnScroll();
//           }
//         }
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Palette.bg,
//       appBar: AppBar(
//           surfaceTintColor: Colors.transparent,
//         backgroundColor: Colors.white,
//         title: const Text('Members'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Get.to(() => CreateOrEditCouncilMemberPage(),
//                   transition: Transition.cupertino);
//             },
//             child: Text(
//               'New Member',
//               style: Get.textTheme.bodyMedium?.copyWith(color: Palette.card1),
//             ),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         if (_controller.isPageLoading.value) {
//           return const Center(
//               child: CircularProgressIndicator()); // Show loading indicator
//         }
//         if (_controller.councilMembers.isEmpty) {

//           return EmptyState();
//           // return const Center(
//           //     child: Text('No members found')); // Show empty state
//         }

//         return RefreshIndicator(
//           triggerMode: RefreshIndicatorTriggerMode.anywhere,
//           onRefresh: () async {
//             _controller.fetchCouncilMembers(); // Refresh the list on pull down
//           },
//           child: ListView.builder(
//             controller: newScrollController,

//             physics:
//                 const AlwaysScrollableScrollPhysics(), // Ensure always scrollable
//             itemCount: _controller.councilMembers.length +
//                 1, // +1 for the loading indicator at the end
//             itemBuilder: (context, index) {
//               if (index == _controller.councilMembers.length) {
//                 return _controller.isScrollLoading.value
//                     ? const Padding(
//                         padding: EdgeInsets.all(8.0),
//                         child: Center(
//                             child:
//                                 CircularProgressIndicator()), // Show loading indicator at the end
//                       )
//                     : const SizedBox.shrink(); // No additional data to load
//               }

//               final position = _controller.councilMembers[index];
//               return RippleContainer(
//                 onTap: () {
//                       _controller.selectMember(position);
//                 },
//                 child: CouncilPositionCard(
//                   position: position,
//                   onEdit: () {
//                     Get.to(() =>
//                         CreateOrEditCouncilMemberPage(position: position));
//                   },
//                   onDelete: () {
//                     if (position.id != null) {
//                       Modal.confirmation(
//                         titleText: "Confirm Delete",
//                         contentText:
//                             "Are you sure you want to delete this member? All associated data, including files and records, will be permanently lost.",
//                         onConfirm: () {
//                           _controller.deleteCouncilPosition(position.id!);
//                         },
//                         onCancel: () {
//                           Get.back();
//                         },
//                       );
//                     }
//                   },
//                 ),
//               );
//             },
//           ),
//         );
//       }),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:geolocation/core/globalwidget/empty_state.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/council_positions/pages/create_or_edit_council_member_page.dart';
import 'package:geolocation/features/council_positions/pages/council_member_profile_page.dart';
import 'package:geolocation/features/council_positions/widget/council_position_card.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

class CouncilMemberPositionListPage extends StatefulWidget {
  @override
  _CouncilMemberPositionListPageState createState() =>
      _CouncilMemberPositionListPageState();
}

class _CouncilMemberPositionListPageState
    extends State<CouncilMemberPositionListPage> {
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
        if (newScrollController.position.pixels >=
            newScrollController.position.maxScrollExtent - 200) {
          _controller.fetchCouncilMembersOnScroll();
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
        title: const Text('Members'),
        actions: [
          TextButton(
            onPressed: () {
              Get.to(() => CreateOrEditCouncilMemberPage(),
                  transition: Transition.cupertino);
            },
            child: Text(
              'New Member',
              style: Get.textTheme.bodyMedium?.copyWith(color: Palette.card2),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          _controller.fetchCouncilMembers(); // Refresh the list on pull down
        },
        child: Obx(() {
          if (_controller.isPageLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.councilMembers.isEmpty) {
            return EmptyState();
          }

          return CustomScrollView(
            controller: newScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              ToSliver(
                child: SizedBox(height: 8),
              ),
              SliverMasonryGrid.count(
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                crossAxisCount: 1,
                childCount: _controller.councilMembers.length,
                itemBuilder: (context, index) {
                  final position = _controller.councilMembers[index];
                  return RippleContainer(
                    onTap: () {
                      _controller.selectMember(position);
                    },
                    child: CouncilPositionCard(
                      position: position,
                      onEdit: () {
                        Get.to(() =>
                            CreateOrEditCouncilMemberPage(position: position));
                      },
                      onDelete: () {
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
                    ),
                  );
                },
              ),
              if (_controller.isScrollLoading.value)
                ToSliver(
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ToSliver(
                child: SizedBox(height: 50),
              ),
            ],
          );
        }),
      ),
    );
  }
}
