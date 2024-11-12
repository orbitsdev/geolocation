import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';

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


  void fullScreenDisplay( List<MediaFile> media, MediaFile file) {
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
             Get.to(() => BrowserViewerPage(file: file,)); 
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
      update();
    });
  }

  void selectTaskAndNavigateToFullDetails(Task task) {
    selectedTask(task);
    update();
    Get.to(
      () => TaskDetailsPage(),
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

    print(data);

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

  void loadTaskOnScroll(BuildContext context) async {
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

  Future<void> uploadFile() async {
    Modal.confirmation(
      titleText: "Confirm Upload File",
      contentText:
          "Are you sure you want to upload files",
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
             var data = success.data['data'];
            Task taskDetails = Task.fromMap(data);
            selectedTask(taskDetails);
            update();
            (success.data['data']['media'] as List<dynamic>).forEach((e){
              print(e);
            });
            Modal.success( message: 'Upload  File! Success 🎉');
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
          Modal.success(message: 'Task updated successfully');
          Get.offNamedUntil('/tasks', (route) => route.isFirst);
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
}
