import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/images/online_image_full_screen_display.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/council_positions/pages/filtered_task_page.dart';
import 'package:geolocation/features/task/model/task.dart';
import 'package:geolocation/features/task/task_page.dart';
import 'package:get/get.dart';

class CouncilMemberProfilePage extends StatelessWidget {
  final positionController = Get.find<CouncilPositionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.gray100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Council Member Profile',
          style: TextStyle(color: Palette.text),
        ),
        iconTheme: IconThemeData(color: Palette.text),
        elevation: 0,
      ),
      body: Obx(
        () => RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            positionController.refreshSelectedMemberDetails();
          },
          child: positionController.isMemberDetailsLoading.value
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileHeader(),
                        Gap(24),
                        _buildSectionTitle('Task Overview'),
                        Gap(16),
                        _buildTaskOverview(),
                        Gap(24),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    final member = positionController.selectedMember.value;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RippleContainer(
          onTap: () => Get.to(
            () => OnlineImageFullScreenDisplay(imageUrl: member.image ??''),
          ),
          child: Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: OnlineImage(
              imageUrl: member.image ??'',
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.fullName ??'',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.titleLarge?.copyWith(color: Palette.text),
              ),
              Gap(4),
              Text(
                '${member.email}',
                style: Get.textTheme.bodyMedium?.copyWith(color: Palette.lightText),
              ),
              Gap(8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: member.position,
                      style: Get.textTheme.titleMedium?.copyWith(color: Palette.card3),
                    ),
                    TextSpan(
                      text: ' (${member.councilName})',
                      style: Get.textTheme.titleMedium?.copyWith(color: Palette.card3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Palette.text,
      ),
    );
  }

  Widget _buildTaskOverview() {
    final member = positionController.selectedMember.value;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTaskCard('Todo', member.totalToDoTasks as int, Task.STATUS_TODO),
            _buildTaskCard('In Progress', member.totalInProgressTasks as int , Task.STATUS_IN_PROGRESS),
          ],
        ),
        Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTaskCard('Need Revision', member.totalNeedsRevision as int, Task.STATUS_NEED_REVISION),
            _buildTaskCard('Rejected', member.totalRejected as int, Task.STATUS_REJECTED),
          ],
        ),
        Gap(16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTaskCard('Completed', member.totalCompletedTasks as int , Task.STATUS_COMPLETED),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskCard(String title, int count, String status) {
  final member = positionController.selectedMember.value;

  return Expanded(
    child: GestureDetector(
      onTap: () => Get.to(
        () => FilteredTaskPage(
          status: status,
          councilPositionId: member.id!, // Pass the council position ID
        ),
        transition: Transition.cupertino,
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style:  TextStyle(
                fontSize: 16,
                color: Palette.PRIMARY,
              ),
            ),
            const Gap(8),
            Text(
              count.toString(),
              style:  TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Palette.DARK_PRIMARY,
              ),
            ),
          ],
        ),
      ),
    ),
  );


  }
}
