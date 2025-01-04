import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geolocation/core/globalwidget/empty_state.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/councils/pages/council_form_page.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/councils/controller/council_controller.dart';
import 'package:geolocation/features/councils/model/council.dart';

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
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 200 &&
            !_councilController.isFetchingMore.value &&
            _councilController.councils.length < _councilController.totalItems.value) {
          _councilController.fetchCouncilsOnScroll();
        }
      });
    });

    return Scaffold(
      backgroundColor: Palette.gray100,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text(
          'Councils',
          style: TextStyle(color: Palette.gray900),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Palette.gray900),
            onPressed: () {
              Get.to(() => CouncilFormPage(isEdit: false), transition: Transition.cupertino);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _councilController.reloadCouncils();
        },
        child: Obx(() {
          if (_councilController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_councilController.councils.isEmpty) {
            return Container(
              
              width: Get.size.width,
              child: Center(child: EmptyState()));
          }

          return ListView.builder(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: _councilController.councils.length + 1,
            itemBuilder: (context, index) {
              if (index == _councilController.councils.length) {
                return _councilController.isFetchingMore.value
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox.shrink();
              }

              Council council = _councilController.councils[index];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Slidable(
                    key: ValueKey(council.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            _councilController.deleteCouncil(council.id!);
                          },
                          backgroundColor: Palette.deYork900,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Palette.gray200,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child:  Icon(Icons.groups, color: Palette.DARK_PRIMARY),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                      onTap: () {
                        positionController.selectAndNavigateToCouncilMemberPageAdmin(council.id ?? 0);
                      },
                      title: Text(
                        council.name ?? 'Unnamed Council',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Palette.gray900,
                        ),
                      ),
                      subtitle: (council.councilPositions == null || (council.councilPositions ?? []).isEmpty)
                          ? null
                          : Text(
                              'Members: ${council.councilPositions?.length ?? 0}',
                              style: const TextStyle(color: Palette.gray600, fontSize: 14),
                            ),
                      trailing: InkWell(
                        onTap: () {
                          Get.to(
                            () => CouncilFormPage(isEdit: true, councilId: council.id!),
                            transition: Transition.cupertino,
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children:  [
                            Icon(Icons.edit, color: Palette.DARK_PRIMARY),
                            SizedBox(height: 4),
                            Text(
                              'Edit',
                              style: TextStyle(fontSize: 12, color: Palette.gray600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
      // bottomSheet:  GetBuilder<AuthController>(
      //     builder: (auth) {
      //       return  Text(
      //         'Councils ${auth.user.value.toJson()}',
      //         style: TextStyle(color: Palette.gray900),
      //       );
      //     }
      //   ),
    );
  }
}