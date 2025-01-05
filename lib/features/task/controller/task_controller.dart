import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/globalwidget/browser_view_page.dart';
import 'package:geolocation/core/globalwidget/images/local_file_image_full_screen_display.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/file/model/media_file.dart';

import 'package:geolocation/features/task/admin_members_task_page.dart';
import 'package:geolocation/features/task/model/task.dart';
import 'package:geolocation/features/task/task_details_page.dart';
import 'package:geolocation/features/video/file_viewer.dart';
import 'package:geolocation/features/video/local_video_player.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as dio;

import 'package:file_picker/file_picker.dart';
import 'dart:io';

class TaskController extends GetxController {
  static TaskController controller = Get.find<TaskController>();


  ///------------------------------------------------------------
  /// ALL
  ///-----------------------------------------

  var isLoading = false.obs;
  var isScrollLoading = false.obs;
  var page = 1.obs;
  var perPage = 20.obs;
  var lastTotalValue = 0.obs;
  var hasData = false.obs;
  var tasks = <Task>[].obs;

  var isRemoving = false.obs;
  final taskFormKey = GlobalKey<FormBuilderState>();
  var selectedOfficer = CouncilPosition().obs;
  var selectedTask = Task().obs;

  var isSpecificLoading = false.obs;

  var mediaFiles = <File>[].obs;
  var uploadProgress = 0.0.obs;




  ///------------------------------------------------------------
  /// TODO
  ///-----------------------------------------
  var todoIsLoading = false.obs;
  var todoIsScrollLoading = false.obs;
  var todoPage = 1.obs;
  var todoPerPage = 20.obs;
  var todoLastTotalValue = 0.obs;
  var todoHasData = false.obs;
  var todoTasks = <Task>[].obs;



  ///------------------------------------------------------------
  /// NEED REVISION
  ///-----------------------------------------
  var needRevisionIsLoading = false.obs;
  var needRevisionIsScrollLoading = false.obs;
  var needRevisionPage = 1.obs;
  var needRevisionPerPage = 20.obs;
  var needRevisionLastTotalValue = 0.obs;
  var needRevisionHasData = false.obs;
  var needRevisionTasks = <Task>[].obs;

  ///------------------------------------------------------------
  /// REJEC
  ///-----------------------------------------
  var rejectIsLoading = false.obs;
  var rejectIsScrollLoading = false.obs;
  var rejectPage = 1.obs;
  var rejectPerPage = 20.obs;
  var rejectLastTotalValue = 0.obs;
  var rejectHasData = false.obs;
  var rejectTasks = <Task>[].obs;


  ///------------------------------------------------------------
  /// RESUBMIT
  ///-----------------------------------------
  var resubmitIsLoading = false.obs;
  var resubmitIsScrollLoading = false.obs;
  var resubmitPage = 1.obs;
  var resubmitPerPage = 20.obs;
  var resubmitLastTotalValue = 0.obs;
  var resubmitHasData = false.obs;
  var resubmitTasks = <Task>[].obs;

  ///------------------------------------------------------------
  /// COMPLETED
  ///-----------------------------------------
  var completedIsLoading = false.obs;
  var completedIsScrollLoading = false.obs;
  var completedPage = 1.obs;
  var completedPerPage = 20.obs;
  var completedLastTotalValue = 0.obs;
  var completedHasData = false.obs;
  var completedTasks = <Task>[].obs;


  ///------------------------------------------------------------
  /// By Officer
  ///-----------------------------------------
  ///
var filteredTasks = <Task>[].obs; // For filtered tasks
var isFilteredLoading = false.obs; // Loading state for filtered tasks
var isFilteredScrollLoading = false.obs; // Scroll loading for filtered tasks
var filteredPage = 1.obs; // Current page for filtered tasks
var filteredPerPage = 20.obs; // Tasks per page for filtered tasks
var hasMoreFilteredData = true.obs; // Indicates if more filtered tasks are available

void showApprovalModal() {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      child: GetBuilder<AuthController>(
        builder: (authcontroller) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                authcontroller.user.value.hasAccess()
                    ? 'Manage Task Status'
                    : 'Task Actions',
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Access-Dependent Options
              if (authcontroller.user.value.hasAccess()) ...[
                if (selectedTask.value.status == Task.STATUS_COMPLETED &&
                    selectedTask.value.approvedByCouncilPosition == null)
                  _buildListTile(
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                    iconBackground: Colors.green.shade50,
                    title: 'Approve Task',
                    subtitle: 'Mark the task as approved.',
                    onTap: () => updateTaskStatus(Task.STATUS_COMPLETED),
                  ),
                if (selectedTask.value.status != Task.STATUS_COMPLETED)
                  _buildListTile(
                    icon: Icons.done_all,
                    iconColor: Colors.green,
                    iconBackground: Colors.green.shade50,
                    title: 'Mark as Completed',
                    subtitle: 'Complete the task.',
                    onTap: () => updateTaskStatus(Task.STATUS_COMPLETED),
                  ),
                if (selectedTask.value.status != Task.STATUS_NEED_REVISION)
                  _buildListTile(
                    icon: Icons.edit,
                    iconColor: Colors.orange,
                    iconBackground: Colors.orange.shade50,
                    title: 'Needs Revision',
                    subtitle: 'Request revisions for the task.',
                    onTap: () {
                      Get.back(); // Close the modal
                      showRemarksModal(Task.STATUS_NEED_REVISION);
                    },
                  ),
                if (selectedTask.value.status != Task.STATUS_REJECTED)
                  _buildListTile(
                    icon: Icons.close,
                    iconColor: Colors.red,
                    iconBackground: Colors.red.shade50,
                    title: 'Reject Task',
                    subtitle: 'Mark the task as rejected.',
                    onTap: () {
                      Get.back(); // Close the modal
                      showRemarksModal(Task.STATUS_REJECTED);
                    },
                  ),
                if (selectedTask.value.status != Task.STATUS_COMPLETED &&
                    selectedTask.value.isTaskNotCompleteAndAssignedToCurrentOfficer())
                  _buildListTile(
                    icon: Icons.task_alt,
                    iconColor: Colors.teal,
                    iconBackground: Colors.teal.shade50,
                    title: 'Mark as Done',
                    subtitle: 'Mark the task as done.',
                    onTap: () => updateTaskStatus(Task.STATUS_COMPLETED),
                  ),
              ] else ...[
                if (selectedTask.value.status != Task.STATUS_COMPLETED)
                  _buildListTile(
                    icon: Icons.task_alt,
                    iconColor: Colors.green,
                    iconBackground: Colors.green.shade50,
                    title: 'Mark as Done',
                    subtitle: 'Mark the task as done.',
                    onTap: () => updateTaskStatus(Task.STATUS_COMPLETED),
                  ),
                if (selectedTask.value.status != Task.STATUS_TODO &&
                    selectedTask.value.isTaskNotCompleteAndAssignedToCurrentOfficer())
                  _buildListTile(
                    icon: Icons.refresh,
                    iconColor: Colors.orange,
                    iconBackground: Colors.orange.shade50,
                    title: 'Resubmit Task',
                    subtitle: 'Resubmit the task for approval.',
                    onTap: () {
                      Get.back(); // Close the modal
                      showRemarksModal(Task.STATUS_RESUBMIT,title: 'Message');
                    },
                  ),
              ],

              // Divider for separation
              

              // Cancel Button
              // SizedBox(
              //   width: double.infinity,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.grey[200],
              //       foregroundColor: Colors.black,
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(8),
              //       ),
              //     ),
              //     onPressed: () => Get.back(),
              //     child: const Text('Cancel'),
              //   ),
              // ),
            ],
          );
        },
      ),
    ),
    isScrollControlled: true,
  );
}

Widget _buildListTile({
  required IconData icon,
  required Color iconColor,
  required Color iconBackground,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return Column(
    children: [
      ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: Get.textTheme.bodyMedium,
        ),
        subtitle: Text(
          subtitle,
          style: Get.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        onTap: onTap,
      ),
      const Divider(),
    ],
  );
}


  // Modal to input remarks
  void showRemarksModal(String status, {String? title ='Add Remarks'}) {
    final _formKey = GlobalKey<FormBuilderState>(); // FormBuilder key

    Get.defaultDialog(
      barrierDismissible: false,
      title: title ??"Add Remarks",
      content: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBuilderTextField(
              name: 'remarks',
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter ${title ?? 'Remarks'} here...",
                border: OutlineInputBorder(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(
                    errorText: "Remarks are required."),
                FormBuilderValidators.minLength(5,
                    errorText: "Remarks must be at least 5 characters long."),
                FormBuilderValidators.maxLength(500,
                    errorText: "Remarks must not exceed 500 characters."),
              ]),
            ),
          ],
        ),
      ),
      textConfirm: "Submit",
      confirmTextColor: Colors.white,
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.PRIMARY,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Confirm',
          style: Get.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          if (_formKey.currentState!.saveAndValidate()) {
            final remarks = _formKey.currentState?.value['remarks'];

            updateTaskStatusNoConfirmation(status, remarks: remarks);
           
          } 
        },
      ),
      cancel: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Cancel',
          style: Get.textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
        onPressed: () => Get.back(),
      ),
    );
  }



  void updateTaskStatusNoConfirmation(String status, {String? remarks}) async {
    String actionText;

    // Define the action text based on the status
    if (status == Task.STATUS_COMPLETED) {
      actionText = "approve this task as completed";
    } else if (status == Task.STATUS_NEED_REVISION) {
      actionText = "mark this task as needing revision";
    } else if (status == Task.STATUS_REJECTED) {
      actionText = "reject this task";
    } else {
      actionText = "update this task status";
    }
  
 try {
    bool isAdmin = selectedTask.value.status != Task.STATUS_COMPLETED &&
               (AuthController.controller.user.value.defaultPosition?.grantAccess ?? false);
          var data = {
            'status': status,
            'remarks': remarks,
            'is_admin_action': isAdmin,
          };

          print('---------------------');
          print(data);

        
          Modal.loading();
          var response = await ApiService.putAuthenticatedResource(
              '/tasks/${selectedTask.value.id}/status', data);

          response.fold(
            (failure) {
              Get.back(); // Close modal
              Get.back(); // Close modal
              Modal.errorDialog(failure: failure); // Display error
            },
            (success) {
              Get.back(); // Close modal
              Get.back(); // Close modal
              isLoading(false);

              var data = success.data['data'];
              Task taskDetails = Task.fromMap(data);
              selectedTask(taskDetails);
              
              update(); // Update UI
              loadTask();
              Modal.success(
                message: status == Task.STATUS_COMPLETED
                    ? 'Task successfully approved and marked as completed! 🎉'
                    : status == Task.STATUS_NEED_REVISION
                        ? 'Task marked as needing revision. Please provide further guidance. 🛠️'
                        : status == Task.STATUS_REJECTED
                            ? 'Task has been rejected. 🛑'
                            : 'Task status updated successfully!',
              );
            },
          );
        } catch (e) {
          Get.snackbar("Error", "Something went wrong: $e");
        }
    
    
  }

  // void updateTaskStatus(String status, {String? remarks}) async {

  //   String previusStatus = selectedTask.value.status as String;
  //   String actionText;

  //   // Define the action text based on the status
  //   if (status == Task.STATUS_COMPLETED) {
  //     actionText = "approve this task as completed";
  //   } else if (status == Task.STATUS_APPROVE) {
  //     actionText = "approve this task as completed";

  //   } else if (status == Task.STATUS_NEED_REVISION) {
  //     actionText = "mark this task as needing revision";
  //   } else if (status == Task.STATUS_REJECTED) {
  //     actionText = "reject this task";
  //   } else {
  //     actionText = "update this task status";
  //   }
  

  //   Modal.confirmation(
  //     titleText: "Confirm Action",
  //     contentText:
  //         "Are you sure you want to $actionText? This action will update the task's status and notify relevant users.",
  //     onConfirm: () async {
  //       try {
  //    bool isAdmin = AuthController.controller.user.value.defaultPosition?.grantAccess ?? false;

  //         var data = {
  //           'status': status,
  //           'remarks': remarks,
  //           'is_admin_action': isAdmin,
  //         };
         
  //         Modal.loading();
  //         var response = await ApiService.putAuthenticatedResource(
  //             '/tasks/${selectedTask.value.id}/status', data);

  //         response.fold(
  //           (failure) {
  //             Get.back(); // Close modal
  //             Get.back(); // Close modal
  //             Modal.errorDialog(failure: failure); // Display error
  //           },
  //           (success) {
  //             Get.back(); // Close modal
  //             Get.back(); // Close modal
  //             isLoading(false);
  //              loadByOfficerTask();
  //             var data = success.data['data'];
  //             Task taskDetails = Task.fromMap(data);
  //             selectedTask(taskDetails);
  //             update(); // Update UI
             
  //            // load previous task and load new task



  //            if(isAdmin){
  //               loadTask();
  //            }else{
  //                switch (status) {
  //              case Task.STATUS_TODO:
  //                loadToDoTask();
  //                break;
  //              case Task.STATUS_NEED_REVISION:
  //                loadNeedRevisionTask();
  //                break;
  //              case Task.STATUS_REJECTED:
  //                loadResubmitTask();
  //                break;
  //              case Task.STATUS_RESUBMIT:
  //                loadResubmitTask();
  //                break;
  //              case Task.STATUS_COMPLETED:
  //                loadCompletedTask();
  //                break;
  //              default: 
  //            }

  //            }



  //             Modal.success(
  //               message: status == Task.STATUS_COMPLETED
  //                   ? 'Task successfully approved and marked as completed! 🎉'
  //                   : status == Task.STATUS_NEED_REVISION
  //                       ? 'Task marked as needing revision. Please provide further guidance. 🛠️'
  //                       : status == Task.STATUS_REJECTED
  //                           ? 'Task has been rejected. 🛑'
  //                           : 'Task status updated successfully!',
  //             );
  //           },
  //         );
  //       } catch (e) {
  //         Get.snackbar("Error", "Something went wrong: $e");
  //       }
  //     },
  //     onCancel: () {
  //       Get.back(); // Close modal on cancel
  //     },
  //   );
  // }

  void updateTaskStatus(String status, {String? remarks}) async {
  String previousStatus = selectedTask.value.status as String;
  String actionText;

  // Define the action text based on the status
  switch (status) {
    case Task.STATUS_COMPLETED:
    case Task.STATUS_APPROVE:
      actionText = "approve this task as completed";
      break;
    case Task.STATUS_NEED_REVISION:
      actionText = "mark this task as needing revision";
      break;
    case Task.STATUS_REJECTED:
      actionText = "reject this task";
      break;
    default:
      actionText = "update this task status";
  }

  Modal.confirmation(
    titleText: "Confirm Action",
    contentText:
        "Are you sure you want to $actionText? This action will update the task's status and notify relevant users.",
    onConfirm: () async {
      try {
        bool isAdmin =
            AuthController.controller.user.value.defaultPosition?.grantAccess ??
                false;

        var data = {
          'status': status,
          'remarks': remarks,
          'is_admin_action': isAdmin,
        };

        Modal.loading(); // Show loading modal
        var response = await ApiService.putAuthenticatedResource(
          '/tasks/${selectedTask.value.id}/status',
          data,
        );

        response.fold(
          (failure) {
            Get.back(); // Close loading modal
            Modal.errorDialog(failure: failure); // Display error modal
          },
          (success) {
            Get.back(); 
            Get.back(); 
            // Close loading modal
            isLoading(false);

            // Update selected task
            var taskData = success.data['data'];
            Task updatedTask = Task.fromMap(taskData);
            selectedTask(updatedTask);
            update(); // Update UI

          if(isAdmin){
            loadTask();
          }else{
             loadMyTask(); 
          }
          print('Previous Status: $previousStatus');
            // Reload previous task list
            switch (previousStatus) {
              case Task.STATUS_TODO:
                loadToDoTask();
              
              case Task.STATUS_NEED_REVISION:
                loadNeedRevisionTask();
              
              case Task.STATUS_REJECTED:
                loadRejectTask();
              
              case Task.STATUS_RESUBMIT:
                loadResubmitTask();
              
              case Task.STATUS_COMPLETED:
                loadCompletedTask();
              
              default:
                loadMyTask(); // Fallback for undefined status
            }


            print('New Status: $status');

            // Reload new task list
            switch (status) {
              case Task.STATUS_TODO:
                loadToDoTask();
                break;
              case Task.STATUS_NEED_REVISION:
                loadNeedRevisionTask();
                break;
              case Task.STATUS_REJECTED:
                loadRejectTask();
                break;
              case Task.STATUS_RESUBMIT:
                loadResubmitTask();
                break;
              case Task.STATUS_COMPLETED:
                loadCompletedTask();
                break;
              default:
                loadTask(); // Fallback for undefined status
            }

            // Show success modal with appropriate message
            Modal.success(
              message: status == Task.STATUS_COMPLETED
                  ? 'Task successfully approved and marked as completed! 🎉'
                  : status == Task.STATUS_NEED_REVISION
                      ? 'Task marked as needing revision. Please provide further guidance. 🛠️'
                      : status == Task.STATUS_REJECTED
                          ? 'Task has been rejected. 🛑'
                          : 'Task status updated successfully!',
            );
          },
        );
      } catch (e) {
        Get.back(); // Close loading modal
        Get.snackbar("Error", "Something went wrong: $e");
      }
    },
    onCancel: () {
      Get.back(); // Close confirmation modal
    },
  );
}


  Future<void> deleteMediaFromServer(int mediaId) async {
    try {
      Modal.loading();
      final response = await ApiService.deleteAuthenticatedResource(
        'tasks/${selectedTask.value.id}/media/$mediaId',
      );
      response.fold(
        (failure) {
          Get.back();
          Modal.errorDialog(failure: failure);
        },
        (success) {
          Get.back();
          selectedTask.value.media?.removeWhere((media) => media.id == mediaId);
          update();
          loadTask();
          Modal.success(message: 'File deleted successfully');
        },
      );
    } catch (e) {
      Modal.errorDialog(message: 'An unexpected error occurred');
    }
  }

  // Confirmation modal before deleting
  void confirmDeleteMedia(int index) {
    final mediaFile = selectedTask.value.media?[index];
    if (mediaFile == null) return;

    Modal.confirmation(
      titleText: 'Delete File',
      contentText: 'Are you sure you want to delete this file?',
      onConfirm: () {
        deleteMediaFromServer(mediaFile.id ?? 0);
      },
      onCancel: () {
        Get.back();
        // Optional cancel logic if needed
      },
      confirmText: 'Delete',
      cancelText: 'Cancel',
      barrierDismissible: false,
    );
  }

  void fullScreenDisplay(List<MediaFile> media, MediaFile file) {
    int initialIndex = media.indexOf(file);
    if (file.type!.startsWith('video')) {
      Get.to(() => FileViewer(
            mediaFiles: media, // Pass the entire list of files
            initialIndex:
                initialIndex, // Set the initial index to the clicked file
          ));
    } else if (file.type!.startsWith('image')) {
      Get.to(() => FileViewer(
            mediaFiles: media, // Pass the entire list of files
            initialIndex:
                initialIndex, // Set the initial index to the clicked file
          ));
    } else {
      Get.to(() => BrowserViewerPage(
            file: file,
          ));
    }
  }

  Future<void> pickFile() async {
    const int maxFileSize = 50 * 1024 * 1024; // 50 MB in bytes

    if (mediaFiles.length >= 30) {
      Modal.showToast(
        msg: 'Limit Reached. You can only upload a maximum of 30 files.',
        color: Palette.RED,
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    // Show loading modal to prevent interaction during file picking
    Modal.androidDialogNoContext();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        // allowedExtensions: ['jpg', 'png', 'mp4'],
        allowMultiple: true,
      );

      if (result != null) {
        for (var file in result.files) {
          // Check file size
          if (file.size > maxFileSize) {
            Modal.showToast(
              msg: 'File "${file.name}" is too large. Maximum size is 50 MB.',
              color: Palette.RED,
              toastLength: Toast.LENGTH_LONG,
            );
            continue; // Skip this file and continue with others
          }

          if (mediaFiles.length < 6) {
            mediaFiles.add(File(file.path!));
          } else {
            Modal.showToast(
              msg: 'Limit Reached. You can only upload a maximum of 6 files.',
              color: Palette.RED,
              toastLength: Toast.LENGTH_LONG,
            );
            break;
          }
        }
        update(); // Update UI after file addition
      }
    } on PlatformException catch (e) {
      // Handle the 'already_active' error gracefully if it occurs
      if (e.code == 'already_active') {
        Modal.showToast(
          msg: 'File picker is already active. Please wait.',
          color: Palette.RED,
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Modal.showToast(
          msg: 'Error picking file. Please try again.',
          color: Palette.RED,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    } finally {
      Get.back(); // Close loading modal
    }
  }

  // Function to clear all selected files
  void clearFiles() {
    mediaFiles.clear();
    update();
  }

  // Function to remove a specific file
  void removeFile(int index) {
    if (index >= 0 && index < mediaFiles.length) {
      mediaFiles.removeAt(index);
      update();
    }
  }

  // Function to view a file (image or video)
  void viewFile(File file) {
    if (file.path.endsWith(".mp4")) {
      Get.to(() => LocalVideoPlayer(filePath: file.path));
    } else {
      Get.to(() => LocalFileImageFullScreenDisplay(imagePath: file.path));
    }
  }

  // Function to play a video file
  void playFile(File file) {
    if (file.path.endsWith(".mp4")) {
      // You can use video_player package to play the video
      Get.toNamed('/videoPlayer', arguments: file.path);
    }
  }

  void initializeFormForEdit(Task task) {
    selectedOfficer.value = task.assignedCouncilPosition ?? CouncilPosition();

    // Parse the human-readable date
    DateTime? dueDate;
    if (task.dueDate != null) {
      try {
        dueDate = DateFormat('MMMM d, yyyy, h:mm a').parse(task.dueDate!);
        print('Parsed due date: $dueDate'); // Debugging output
      } catch (e) {
        print('Error parsing due date: ${task.dueDate}');
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      taskFormKey.currentState?.patchValue({
        'title': task.title,
        'task_details': task.taskDetails,
        'due_date': dueDate, // Set initial value for picker
      });
      update(); // Ensure GetX reflects state
    });
  }

  Future<void> refreshSelectedDetails() async {
    if (selectedTask.value.id == null) return;

    if (isSpecificLoading.value == true) return;

    isSpecificLoading(true);
    update();
    var taskId = selectedTask.value.id;
    var response = await ApiService.getAuthenticatedResource('tasks/${taskId}');

    response.fold((failed) {
      isSpecificLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      isSpecificLoading(false);
      var data = success.data['data'];

      Task taskDetails = Task.fromMap(data);
      selectedTask(taskDetails);
      loadTask();
      update();
    });
  }

  void selectTaskAndNavigateToFullDetails(Task task) {
    selectedTask(task);
    update();
    Get.to(
      () => TaskDetailsPage(),
      transition: Transition.cupertino
    );
  }

  Future<void> loadTask() async {
    isLoading(true);
    page(1);
    perPage(20);
    lastTotalValue(0);
    tasks.clear();
    update();

    Map<String, dynamic> data = {
      'page': page,
      'per_page': perPage,
      'councilId':
          AuthController.controller.user.value.defaultPosition?.councilId,
    };



    var response = await ApiService.getAuthenticatedResource('tasks',
        queryParameters: data);
    response.fold((failed) {
      isLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      var data = success.data;

      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      tasks(newData);
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value = tasks.length < lastTotalValue.value;
      isLoading(false);
      update();
      // tasks.forEach((e){
      //   print('___________');
      //   print(e.toJson());
      //   print('__________________');
      // });
    });
  }

  void loadTaskOnScroll() async {
    if (isScrollLoading.value) return;

    isScrollLoading(true);
    update();

    Map<String, dynamic> data = {
      'page': page,
      'per_page': perPage,
      'councilId':
          AuthController.controller.user.value.defaultPosition?.councilId,
    };

    var response = await ApiService.getAuthenticatedResource('tasks',
        queryParameters: data);
    response.fold((failed) {
      isScrollLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      isScrollLoading(false);
      update();

      var data = success.data;
      if (lastTotalValue.value != data['pagination']['total']) {
        loadTask();
        return;
      }

      if (tasks.length == data['pagination']['total']) {
        return;
      }

      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      tasks.addAll(newData);
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value = tasks.length < lastTotalValue.value;
      update();
    });
  }

  Future<void> loadByOfficerTask() async {
    isLoading(true);
    page(1);
    perPage(20);
    lastTotalValue(0);
    tasks.clear();
    update();
    
    var officerId =  AuthController.controller.user.value.defaultPosition?.id;
    Map<String, dynamic> data = {
      'page': page,
      'per_page': perPage,
      // 'councilId':officerId,
    };

    print(data);
    // return;


    var response = await ApiService.getAuthenticatedResource('tasks/council-tasks/${officerId}',
        queryParameters: data);
    response.fold((failed) {
      isLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      var data = success.data;

      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      tasks(newData);
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value = tasks.length < lastTotalValue.value;
      isLoading(false);
      update();
      // tasks.forEach((e){
      //   print('___________');
      //   print(e.toJson());
      //   print('__________________');
      // });
    });
  }

  Future<void> loadMyTask() async {
    await Future.wait([
      loadTask(),
      loadToDoTask(),
       loadNeedRevisionTask(),
       loadResubmitTask()
        // CollectionController.controller.loadData(),
        // TaskController.controller.loadTask(),
      ]);
  }

  void loadByOfficerTaskOnScroll() async {
    if (isScrollLoading.value) return;

    isScrollLoading(true);
    update();

   
    var officerId =  AuthController.controller.user.value.defaultPosition?.id;
    Map<String, dynamic> data = {
      'page': page,
      'per_page': perPage,
      'councilId':officerId,
    };
    var response = await ApiService.getAuthenticatedResource('tasks/council-tasks/${officerId}',
        queryParameters: data);
    response.fold((failed) {
      isScrollLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      isScrollLoading(false);
      update();

      var data = success.data;
      if (lastTotalValue.value != data['pagination']['total']) {
        loadTask();
        return;
      }

      if (tasks.length == data['pagination']['total']) {
        return;
      }

      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      tasks.addAll(newData);
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value = tasks.length < lastTotalValue.value;
      update();
    });
  }

  Future<void> uploadFile() async {
    Modal.confirmation(
      titleText: "Confirm Upload File",
      contentText: "Are you sure you want to upload files",
      onConfirm: () async {
        try {
          isLoading(true);

          // Prepare form data
          var formData = dio.FormData();

          // Add media files to FormData
          for (var file in mediaFiles) {
            formData.files.add(MapEntry(
              'media[]',
              await dio.MultipartFile.fromFile(file.path,
                  filename: file.path.split('/').last),
            ));
          }
          var taskId = selectedTask.value.id;
          var response = await ApiService.filePostAuthenticatedResource(
            '/tasks/${taskId}/files',
            formData,
            onSendProgress: (int sent, int total) {
              uploadProgress.value = sent / total;
              update();
            },
          );

          response.fold((failure) {
            isLoading(false);
            // Get.back();
            uploadProgress.value = 0.0;
            update();
            Modal.errorDialog(failure: failure);
          }, (success) {
            // Get.back();
            isLoading(false);
            uploadProgress.value = 0.0;
            mediaFiles.clear();
            loadByOfficerTask();
            var data = success.data['data'];
            Task taskDetails = Task.fromMap(data);
            selectedTask(taskDetails);
            update();

            (success.data['data']['media'] as List<dynamic>).forEach((e) {
              print(e);
            });
            Modal.success(message: 'Upload  File! Success 🎉');
          });
        } catch (e) {
          Get.back();
          isLoading(false);
          uploadProgress.value = 0.0;
          update();
          Modal.errorDialog(
              message: 'An error occurred. Please try again.${e}');
        }
      },
      onCancel: () {
        Get.back();
      },
    );
  }

  void selectOfficer(CouncilPosition officer) {
    selectedOfficer(officer);
    print('---------------------------');
    print(selectedOfficer.toJson());
    print('---------------------------');
    update();
    Get.back();
  }

  void closeCreateTask() {
    selectedOfficer(CouncilPosition());
    update();
    Get.back();
  }

  void createTask() async {
    if (taskFormKey.currentState!.saveAndValidate()) {
      var formData = taskFormKey.currentState?.value;
      print(formData);

      if (selectedOfficer.value.id == null) {
        Modal.errorDialog(message: 'Please select a officer.');
        return;
      }
      String formattedDueDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(formData!['due_date']);

      Modal.androidDialogNoContext();
      var data = {
        'council_position_id': selectedOfficer.value.id,
        'title': formData['title'],
        'task_details': formData['task_details'],
        'due_date': formattedDueDate,
      };

      var response = await ApiService.postAuthenticatedResource(
        'tasks',
        data,
      );

      response.fold(
        (failure) {
          print(failure.message);
          Modal.errorDialog(failure: failure);
        },
        (success) async {
          Get.back();

          Modal.success(message: 'Task was  successfully created');
          Get.offNamedUntil('/tasks', (route) => route.isFirst);
        },
      );
    }
  }

  void updateTask(int id) async {
    if (taskFormKey.currentState!.saveAndValidate()) {
      var formData = taskFormKey.currentState!.value;

      if (selectedOfficer.value.id == null) {
        Modal.errorDialog(message: 'Please select an officer.');
        return;
      }

      print(formData);

      String formattedDueDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(formData['due_date']);
      print(formattedDueDate);

      var data = {
        'council_position_id': selectedOfficer.value.id,
        'title': formData['title'],
        'task_details': formData['task_details'],
        'due_date': formattedDueDate,
      };

      print(data);

      Modal.androidDialogNoContext();

      var response =
          await ApiService.putAuthenticatedResource('tasks/$id', data);

      response.fold(
        (failure) {
          Get.back(); // Close loading modal
          Modal.errorDialog(failure: failure);
          print(failure.exception?.message);
        },
        (success) {
          print(success.data);
          Get.back(); // Close loading modal
          Get.offNamedUntil('/tasks', (route) => route.isFirst);
          Modal.success(message: 'Task updated successfully');
        },
      );
    }
  }

  Future<void> deleteTask(int taskId) async {
    Modal.loading(content: const Text('Deleting position...'));
    var response = await ApiService.deleteAuthenticatedResource(
      'tasks/${taskId}',
    );

    response.fold(
      (failure) {
        Get.back(); // Close the modal
        Modal.errorDialog(failure: failure);
      },
      (success) {
        Get.back(); // Close the modal
        tasks.removeWhere((t) => t.id == taskId);
        update();
        Modal.success(message: 'Task deleted successfully!');
      },
    );
  }


  
  Future<void> reload(String status, {bool isAdmin = false}) async {

    if(isAdmin){
      loadTask();
      return;
    }else{
switch (status) {
      case Task.STATUS_TODO:
        loadToDoTask();
        break;
      case Task.STATUS_NEED_REVISION:
        loadNeedRevisionTask();
        break;
      case Task.STATUS_REJECTED:
        loadRejectTask();
        break;
      case Task.STATUS_RESUBMIT:
        
        loadResubmitTask();
        break;
      case Task.STATUS_COMPLETED:
        loadCompletedTask();
        break;
      default:
    }
    
    
      //loadToShipOrders(context);
    }
  }


  
  Future<void> loadToDoTask() async {
    todoIsLoading(true);
    todoPage(1);
    todoPerPage(20);
    todoLastTotalValue(0);
    todoTasks.clear();
    update();
    
    var officerId =  AuthController.controller.user.value.defaultPosition?.id;
    Map<String, dynamic> data = {
      'page': todoPage,
      'per_page': todoPerPage,
      'status': Task.STATUS_TODO,
     
    };

   

  

    var response = await ApiService.getAuthenticatedResource('tasks/council-tasks/${officerId}', queryParameters: data);
    response.fold((failed) {
      todoIsLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      var data = success.data;  

     
      print(data);

      
      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      todoTasks(newData);
      todoPage.value++;
      todoLastTotalValue.value = data['pagination']['total'];
      todoHasData.value = todoTasks.length < lastTotalValue.value;
      todoIsLoading(false);
      update();
      todoTasks.forEach((e){
        print('___________');
        print(e.toJson());
        print('__________________');
      });
    });
  }

  void loadToDoTaskOnScroll() async {
    if (todoIsScrollLoading.value) return;

    todoIsScrollLoading(true);
    update();

   
    var officerId =  AuthController.controller.user.value.defaultPosition?.id;
    Map<String, dynamic> data = {
       'page': todoPage,
      'per_page': todoPerPage,
      'status': Task.STATUS_TODO,
     
    };
    
   
    var response = await ApiService.getAuthenticatedResource('tasks/council-tasks/${officerId}',
        queryParameters: data);
    response.fold((failed) {
      todoIsScrollLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      todoIsScrollLoading(false);
      update();

      var data = success.data;
      if (todoLastTotalValue.value != data['pagination']['total']) {
        loadTask();
        return;
      }

      if (todoTasks.length == data['pagination']['total']) {
        return;
      }

      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      todoTasks.addAll(newData);
      page.value++;
      todoLastTotalValue.value = data['pagination']['total'];
      hasData.value = todoTasks.length < todoLastTotalValue.value;
      update();
    });
  }

  
  Future<void> loadRejectTask() async {
    rejectIsLoading(true);
    rejectPage(1);
    rejectPerPage(20);
    rejectLastTotalValue(0);
    rejectTasks.clear();
    update();
    
    var officerId =  AuthController.controller.user.value.defaultPosition?.id;
    Map<String, dynamic> data = {
      'page': rejectPage,
      'per_page': rejectPerPage,
      'status': Task.STATUS_REJECTED,
     
    };

  
    var response = await ApiService.getAuthenticatedResource('tasks/council-tasks/${officerId}', queryParameters: data);
    response.fold((failed) {
      rejectIsLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      var data = success.data;  

     
      print(data);

      
      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      rejectTasks(newData);
      rejectPage.value++;
      rejectLastTotalValue.value = data['pagination']['total'];
      rejectHasData.value = rejectTasks.length < lastTotalValue.value;
      rejectIsLoading(false);
      update();
      
    });
  }

  void loadRejectTaskOnScroll() async {
    if (rejectIsScrollLoading.value) return;

    rejectIsScrollLoading(true);
    update();

   
    var officerId =  AuthController.controller.user.value.defaultPosition?.id;
    Map<String, dynamic> data = {
       'page': rejectPage,
      'per_page': rejectPerPage,
      'status': Task.STATUS_REJECTED,
     
    };
    
   
    var response = await ApiService.getAuthenticatedResource('tasks/council-tasks/${officerId}',
        queryParameters: data);
    response.fold((failed) {
      rejectIsScrollLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      rejectIsScrollLoading(false);
      update();

      var data = success.data;
      if (rejectLastTotalValue.value != data['pagination']['total']) {
        loadTask();
        return;
      }

      if (rejectTasks.length == data['pagination']['total']) {
        return;
      }

      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      rejectTasks.addAll(newData);
      page.value++;
      rejectLastTotalValue.value = data['pagination']['total'];
      hasData.value = rejectTasks.length < rejectLastTotalValue.value;
      update();
    });
  }
  
  Future<void> loadResubmitTask() async {
    resubmitIsLoading(true);
    resubmitPage(1);
    resubmitPerPage(20);
    resubmitLastTotalValue(0);
    resubmitTasks.clear();
    update();
    
    var officerId =  AuthController.controller.user.value.defaultPosition?.id;
    Map<String, dynamic> data = {
      'page': resubmitPage,
      'per_page': resubmitPerPage,
      'status': Task.STATUS_RESUBMIT,
     
    };

  
  
    var response = await ApiService.getAuthenticatedResource('tasks/council-tasks/${officerId}', queryParameters: data);
    response.fold((failed) {
      resubmitIsLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      var data = success.data;  

     
      print(data);

      
      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      resubmitTasks(newData);
      resubmitPage.value++;
      resubmitLastTotalValue.value = data['pagination']['total'];
      resubmitHasData.value = resubmitTasks.length < lastTotalValue.value;
      resubmitIsLoading(false);
      update();
      
    });
  }

  void loadResubmitTaskOnScroll() async {
    if (resubmitIsScrollLoading.value) return;

    resubmitIsScrollLoading(true);
    update();

   
    var officerId =  AuthController.controller.user.value.defaultPosition?.id;
    Map<String, dynamic> data = {
       'page': rejectPage,
      'per_page': rejectPerPage,
      'status': Task.STATUS_RESUBMIT,
     
    };
    
   
    var response = await ApiService.getAuthenticatedResource('tasks/council-tasks/${officerId}',
        queryParameters: data);
    response.fold((failed) {
      resubmitIsScrollLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      resubmitIsScrollLoading(false);
      update();

      var data = success.data;
      if (resubmitLastTotalValue.value != data['pagination']['total']) {
        loadTask();
        return;
      }

      if (resubmitTasks.length == data['pagination']['total']) {
        return;
      }

      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      resubmitTasks.addAll(newData);
      page.value++;
      resubmitLastTotalValue.value = data['pagination']['total'];
      hasData.value = resubmitTasks.length < resubmitLastTotalValue.value;
      update();
    });
  }
  
  Future<void> loadCompletedTask() async {
    completedIsLoading(true);
    completedPage(1);
    completedPerPage(20);
    completedLastTotalValue(0);
    completedTasks.clear();
    update();
    
    var officerId =  AuthController.controller.user.value.defaultPosition?.id;
    Map<String, dynamic> data = {
      'page': completedPage,
      'per_page': completedPerPage,
      'status': Task.STATUS_COMPLETED,
     
    };

  
  
    var response = await ApiService.getAuthenticatedResource('tasks/council-tasks/${officerId}', queryParameters: data);
    response.fold((failed) {
      completedIsLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      var data = success.data;  

     
      print(data);

      
      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      completedTasks(newData);
      completedPage.value++;
      completedLastTotalValue.value = data['pagination']['total'];
      completedHasData.value = completedTasks.length < lastTotalValue.value;
      completedIsLoading(false);
      update();
      
    });
  }

  void loadCompletedTaskOnScroll() async {
    if (completedIsScrollLoading.value) return;

    completedIsScrollLoading(true);
    update();

   
    var officerId =  AuthController.controller.user.value.defaultPosition?.id;
    Map<String, dynamic> data = {
       'page': rejectPage,
      'per_page': rejectPerPage,
      'status': Task.STATUS_COMPLETED,
     
    };
    
   
    var response = await ApiService.getAuthenticatedResource('tasks/council-tasks/${officerId}',
        queryParameters: data);
    response.fold((failed) {
      completedIsScrollLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      completedIsScrollLoading(false);
      update();

      var data = success.data;
      if (completedLastTotalValue.value != data['pagination']['total']) {
        loadTask();
        return;
      }

      if (completedTasks.length == data['pagination']['total']) {
        return;
      }

      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      completedTasks.addAll(newData);
      page.value++;
      completedLastTotalValue.value = data['pagination']['total'];
      hasData.value = completedTasks.length < completedLastTotalValue.value;
      update();
    });
  }
  Future<void> loadNeedRevisionTask() async {
   needRevisionIsLoading(true);
   needRevisionPage(1);
   needRevisionPerPage(20);
   needRevisionLastTotalValue(0);
   needRevisionTasks.clear();
    update();
    
    var officerId =  AuthController.controller.user.value.defaultPosition?.id;
    Map<String, dynamic> data = {
      'page':needRevisionPage,
      'per_page':needRevisionPerPage,
      'status': Task.STATUS_NEED_REVISION,
     
    };

  
  
    var response = await ApiService.getAuthenticatedResource('tasks/council-tasks/${officerId}', queryParameters: data);
    response.fold((failed) {
     needRevisionIsLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      var data = success.data;  

     
      print(data);

      
      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
     needRevisionTasks(newData);
     needRevisionPage.value++;
     needRevisionLastTotalValue.value = data['pagination']['total'];
     needRevisionHasData.value =needRevisionTasks.length < lastTotalValue.value;
     needRevisionIsLoading(false);
      update();
      
    });
  }

  void loadNeedRevisionTaskOnScroll() async {
    if (needRevisionIsScrollLoading.value) return;

   needRevisionIsScrollLoading(true);
    update();

   
    var officerId =  AuthController.controller.user.value.defaultPosition?.id;
    Map<String, dynamic> data = {
       'page': rejectPage,
      'per_page': rejectPerPage,
      'status': Task.STATUS_NEED_REVISION,
     
    };
    
   
    var response = await ApiService.getAuthenticatedResource('tasks/council-tasks/${officerId}',
        queryParameters: data);
    response.fold((failed) {
     needRevisionIsScrollLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
     needRevisionIsScrollLoading(false);
      update();

      var data = success.data;
      if (completedLastTotalValue.value != data['pagination']['total']) {
        loadTask();
        return;
      }

      if (completedTasks.length == data['pagination']['total']) {
        return;
      }

      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
     needRevisionTasks.addAll(newData);
      page.value++;
     needRevisionLastTotalValue.value = data['pagination']['total'];
      hasData.value =needRevisionTasks.length <needRevisionLastTotalValue.value;
      update();
    });
  }

  Future<void> fetchFilteredTasks({
  required int councilPositionId,
  String? status,
}) async {
  isFilteredLoading(true);
  filteredPage(1); // Reset to the first page
  hasMoreFilteredData(true);
  filteredTasks.clear(); // Clear current tasks
  update();

  Map<String, dynamic> queryParams = {
    'page': filteredPage.value,
    'per_page': filteredPerPage.value,
    if (status != null) 'status': status,
  };

  try {
    final response = await ApiService.getAuthenticatedResource(
      'tasks/council-position/$councilPositionId',
      queryParameters: queryParams,
    );

    response.fold(
      (failure) {
        isFilteredLoading(false);
        update();
        Modal.errorDialog(failure: failure);
      },
      (success) {
        final fetchedTasks = (success.data['data'] as List)
            .map((task) => Task.fromMap(task))
            .toList();

        filteredTasks.assignAll(fetchedTasks);
        hasMoreFilteredData(filteredTasks.length < success.data['pagination']['total']);
        isFilteredLoading(false);
        update();
      },
    );
  } catch (e) {
    isFilteredLoading(false);
    update();
    Modal.errorDialog(message: 'Failed to fetch tasks: $e');
  }
}

Future<void> fetchFilteredTasksOnScroll({
  required int councilPositionId,
  String? status,
}) async {
  if (isFilteredScrollLoading.value || !hasMoreFilteredData.value) return;

  isFilteredScrollLoading(true);
  update();

  Map<String, dynamic> queryParams = {
    'page': filteredPage.value,
    'per_page': filteredPerPage.value,
    if (status != null) 'status': status,
  };

  try {
    final response = await ApiService.getAuthenticatedResource(
      'tasks/council-position/$councilPositionId',
      queryParameters: queryParams,
    );

    response.fold(
      (failure) {
        isFilteredScrollLoading(false);
        update();
        Modal.errorDialog(failure: failure);
      },
      (success) {
        final fetchedTasks = (success.data['data'] as List)
            .map((task) => Task.fromMap(task))
            .toList();

        filteredTasks.addAll(fetchedTasks);
        hasMoreFilteredData(filteredTasks.length < success.data['pagination']['total']);
        filteredPage.value++; // Increment page
        isFilteredScrollLoading(false);
        update();
      },
    );
  } catch (e) {
    isFilteredScrollLoading(false);
    update();
    Modal.errorDialog(message: 'Failed to load tasks on scroll: $e');
  }
}


}
