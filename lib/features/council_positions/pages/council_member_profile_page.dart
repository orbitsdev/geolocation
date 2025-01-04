import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/globalwidget/images/online_image.dart';
import 'package:geolocation/core/globalwidget/images/online_image_full_screen_display.dart';
import 'package:geolocation/core/globalwidget/ripple_container.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/council_positions/pages/filtered_task_page.dart';
import 'package:geolocation/features/reports/report_controller.dart';
import 'package:geolocation/features/task/model/task.dart';
import 'package:get/get.dart';

class CouncilMemberProfilePage extends StatelessWidget {
  final positionController = Get.find<CouncilPositionController>();
  final reportController = Get.find<ReportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.FBG,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Council Member Profile',
          style: TextStyle(color: Palette.text),
        ),
        iconTheme: IconThemeData(color: Palette.text),
        elevation: 1,
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
                       _buildTaskOverview(),
                         Gap(24),
                        _buildSectionContainer(
                          title: 'Report',
                          child: _buildActions(),
                        ),
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
            () => OnlineImageFullScreenDisplay(imageUrl: member.image ?? ''),
          ),
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: OnlineImage(
              imageUrl: member.image ?? '',
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member.fullName ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.titleLarge?.copyWith(color: Palette.text),
              ),
              Gap(4),
              Text(
                member.email ?? '',
                style: Get.textTheme.bodyMedium?.copyWith(color: Palette.lightText),
              ),
              Gap(8),
              Text(
                '${member.position} (${member.councilName})',
                style: Get.textTheme.titleMedium?.copyWith(color: Palette.card3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionContainer({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Palette.text,
            ),
          ),
          Gap(16),
          child,
        ],
      ),
    );
  }

  Widget _buildActions() {
  final member = positionController.selectedMember.value;

  return Column(
    children: [
      _buildActionTile(
        icon: Icons.download,
        color: Colors.orange.shade700,
        backgroundColor: Colors.orange.shade50,
        title: 'Download Attendance',
        subtitle: 'Get attendance records for this council member.',
        onTap: () {
          reportController.exportAttendanceByCouncilPosition(
            councilId: member.councilId!,
            councilPositionId: member.id!,
          );
        },
      ),
      const Divider(height: 1, color: Palette.gray100),
      _buildActionTile(
        icon: Icons.download,
        color: Colors.green.shade700,
        backgroundColor: Colors.green.shade50,
        title: 'Download Tasks',
        subtitle: 'Export tasks assigned to this council member.',
        onTap: () {
          reportController.exportTasksByCouncilPosition(
            councilPositionId: member.id!,
          );
        },
      ),
    ],
  );
}

Widget _buildActionTile({
  required IconData icon,
  required Color color,
  required Color backgroundColor,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color),
    ),
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
    ),
    subtitle: Text(
      subtitle,
      style: TextStyle(fontSize: 12, color: Colors.black54),
    ),
    onTap: onTap,
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
            _buildTaskCard('In Progress', member.totalInProgressTasks as int, Task.STATUS_IN_PROGRESS),
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
            _buildTaskCard('Completed', member.totalCompletedTasks as int, Task.STATUS_COMPLETED),
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
            councilPositionId: member.id!,
          ),
          transition: Transition.cupertino,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(width: Get.size.width,),
              Text(
                title,
                style: TextStyle(fontSize: 16, color: Palette.deYork500),
              ),
              Gap(8),
              Text(
                count.toString(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Palette.deYork500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
