import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/constant/style.dart';
import 'package:geolocation/core/globalwidget/file_preview.dart';
import 'package:geolocation/core/globalwidget/preview_file_card.dart';
import 'package:geolocation/core/globalwidget/progress_bar_submit.dart';
import 'package:geolocation/core/globalwidget/thumbnail_helper.dart';
import 'package:geolocation/core/globalwidget/to_sliver.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/task/model/task.dart';
import 'package:geolocation/features/task/widget/remarks_widget.dart';
import 'package:geolocation/features/task/widget/staus_widget.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class TaskDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xff333333)),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Task Details',
          style: TextStyle(color: Color(0xff333333)),
        ),
        actions: [
 GetBuilder<TaskController>(
  builder: (controller) {
    final user = AuthController.controller.user.value;
    final task = TaskController.controller.selectedTask.value;

    // Admin logic: Admin can always see "MANAGE"
    final isAdmin = user.defaultPosition?.grantAccess == true;

    // Officer logic: Officers can see "MANAGE" if they are assigned to the task
    final isOfficerAssigned = user.defaultPosition?.id == task.assignedCouncilPosition?.id;

    // Determine if the "MANAGE" button should be visible
    final canManage = isAdmin || (isOfficerAssigned && task.status != Task.STATUS_COMPLETED);

    if (canManage) {
      return TextButton(
        onPressed: () {
          controller.showApprovalModal();
        },
        child: const Text('MANAGE'),
      );
    }

    // Return an empty widget if the condition is not met
    return const SizedBox.shrink();
  },
),








        ],
      ),
      body: GetBuilder<TaskController>(builder: (taskController) {
        return RefreshIndicator(
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () => taskController.refreshSelectedDetails(),
          child: Column(
            children: [
             if (taskController.selectedTask.value.approvedByCouncilPosition?.id != null)
  Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Palette.PRIMARY, Palette.GREEN2],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
     
    ),
    child: Padding(
      padding: EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white, size: 24), // Approve icon
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Approved by:',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  taskController.selectedTask.value.approvedByCouncilPosition?.fullName ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                       
                      // Title
                      ToSliver(
                        child: SizedBox(height: 12),
                      ),
                      ToSliver(
                        child: Text(
                          '${taskController.selectedTask.value.title ?? ''}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff333333),
                          ),
                        ),
                      ),
                      ToSliver(
                        child: SizedBox(height: 12),
                      ),

                      // Status
                      ToSliver(
                        child: StatusRowWidget(
                          label: 'Status',
                          status: taskController.selectedTask.value.status ??
                              'Unknown',
                        ),
                      ),
                      ToSliver(
                        child: SizedBox(height: 12),
                      ),

                      // Due Date
                      ToSliver(
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today,
                                color: Color(0xff888888), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Due: ${taskController.selectedTask.value.dueDate ?? ''}',
                              style: TextStyle(
                                color: Color(0xff555555),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      ToSliver(
                        child: SizedBox(height: 16),
                      ),

                     

                      // Task Details Header
                      ToSliver(
                        child: Text(
                          'Task Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff333333),
                          ),
                        ),
                      ),
                      ToSliver(
                        child: SizedBox(height: 8),
                      ),

                      // Task Details Description
                      ToSliver(
                        child: Text(
                          '${taskController.selectedTask.value.taskDetails ?? ''}',
                          style: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 14,
                          ),
                        ),
                      ),

                      ToSliver(
                        child: SizedBox(height: 16),
                      ),

                      // Remarks if Need Revision
                      if (taskController.selectedTask.value
                          .ifNeedRevisionOrRejected())
                        ToSliver(
                          child: RemarkWidget(
                            title: 'Remarks',
                            message:
                                '${taskController.selectedTask.value.remarks}',
                            icon: Icons.warning_amber_rounded,
                          ),
                        ),
                      ToSliver(
                        child: SizedBox(height: 12),
                      ),
                      // Last Updated
                      if (taskController.selectedTask.value.statusChangedAt !=
                          null)
                        ToSliver(
                          child: Text(
                            'Last Updated: ${taskController.selectedTask.value.statusChangedAt}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        ),

                      SliverGap(8), // Extra spacing

                      Obx(() {
                        if (taskController.isLoading.value) {
                          return ToSliver(
                            child: Container(
                                margin: EdgeInsets.only(bottom: 12),
                                child: taskController.mediaFiles.isNotEmpty
                                    ? ProgressBarSubmit(
                                        progress:
                                            taskController.uploadProgress.value)
                                    : LinearProgressIndicator()),
                          );
                        } else {
                          return ToSliver(
                            child: SizedBox(height: 8),
                          ); // Placeholder when not loading
                        }
                      }),

                      if (taskController.selectedTask.value
                          .isTaskNotCompleteAndAssignedToCurrentOfficer())
                        ToSliver(
                          child: SizedBox(
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // Prevents separate scrolling
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, // Number of items in a row
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: taskController.mediaFiles.length +
                                  1, // +1 for the add button
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  // Add button (always in the first position)
                                  return GestureDetector(
                                    onTap: () {
                                      taskController.pickFile();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Palette
                                            .PRIMARY_BG, // Placeholder color for add button
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Palette.grayTextLight,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  File file =
                                      taskController.mediaFiles[index - 1];
                                  return GestureDetector(
                                    onTap: () {
                                      taskController.viewFile(file);
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        FilePreviewWidget(filePath: file.path),
                                        // "X" button to remove the file
                                        Positioned(
                                          top: -10,
                                          right: -10,
                                          child: GestureDetector(
                                            behavior: HitTestBehavior
                                                .opaque, // Makes the entire area tappable
                                            onTap: () => taskController
                                                .removeFile(index - 1),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black
                                                        .withOpacity(0.7),
                                                    Colors.black
                                                        .withOpacity(0.4),
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                              ),
                                              padding: EdgeInsets.all(
                                                  4), // Larger touch area
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                        ),

                      ToSliver(
                        child: SizedBox(height: 16),
                      ),
                      ToSliver(child: Text('Files')),
                      ToSliver(
                        child: SizedBox(height: 16),
                      ),
                      SliverAlignedGrid.count(
                        itemCount:
                            taskController.selectedTask.value.media?.length ??
                                0,
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        itemBuilder: (context, index) {
                          final file =
                              taskController.selectedTask.value.media![index];
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  taskController.fullScreenDisplay(
                                    taskController.selectedTask.value.media ??
                                        [],
                                    file,
                                  );
                                },
                                child: MediaFileCard(file: file),
                              ),
                              if (taskController.selectedTask.value
                                  .isTaskNotCompleteAndAssignedToCurrentOfficer())
                                Positioned(
                                  top: -12, // Adjust the position as needed
                                  right:
                                      -12, // Adjust to make it more visible and larger
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => taskController
                                        .confirmDeleteMedia(index),
                                    child: Container(
                                      height:
                                          28, // Increased size for better visibility
                                      width:
                                          28, // Increased size for better visibility
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.black.withOpacity(0.7),
                                            Colors.black.withOpacity(
                                                0.5), // Adjust transparency for better contrast
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size:
                                            20, // Increased icon size for better visibility
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),

                      if (taskController.selectedTask.value
                          .isTaskNotCompleteAndAssignedToCurrentOfficer())
                        ToSliver(
                          child: SizedBox(height: 16),
                        ),
                    ],
                  ),
                ),
              ),
              if (taskController.mediaFiles.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Shadow color
                        spreadRadius: 2, // Spread radius
                        blurRadius: 8, // Blur radius
                        offset: Offset(0, 4), // Offset in the x and y direction
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 50,
                        width: Get.size.width,
                        child: GradientElevatedButton(
                          onPressed: () {
                            taskController.uploadFile();
                          },
                          style: GRADIENT_ELEVATED_BUTTON_STYLE,
                          child: Text(
                            'Upload Files',
                            style: Get.textTheme.bodyLarge
                                ?.copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileChip(String name, String avatarPath) {
    return Chip(
      avatar: CircleAvatar(
        backgroundImage: AssetImage(avatarPath),
      ),
      label: Text(name),
    );
  }
}
