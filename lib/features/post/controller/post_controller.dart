import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
import 'package:geolocation/features/file/model/media_file.dart';
import 'package:geolocation/features/post/create_or_edit_post_page.dart';
import 'package:geolocation/features/post/model/post.dart';
import 'package:geolocation/features/video/file_viewer.dart';
import 'package:geolocation/features/video/local_video_player.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:dio/dio.dart' as dio;

class PostController extends GetxController {
  static PostController controller = Get.find();

  final formKey = GlobalKey<FormBuilderState>();

  var mediaFiles = <File>[].obs;
  var uploadProgress = 0.0.obs;

  var isLoading = false.obs;
  var isPageLoading = false.obs;
  var isScrollLoading = false.obs;
  var page = 1.obs;
  var perPage = 10.obs;
  var lastTotalValue = 0.obs;
  var hasData = false.obs;
  var posts = <Post>[].obs;
  var selectedItem = Post().obs;
  var isPublish = true.obs;





  void selectItemAndNavigateToUpdatePage(Post item)  async {
    
    selectedItem(item);
  update(); 

  print('VALUE WHEN SELECT');
  print(selectedItem.value); // Debug print to check the selected item
  print('VALUE WHEN SELECT-----------------');

  await Get.to(() => CreateOrEditPostPage(), arguments: {
    'post': item,
    'isEditMode': true, // Set this flag to indicate edit mode
  }, transition: Transition.cupertino);
  // Get.to(() => CreateOrEditPostPage(isEditMode: true), arguments: collection);
}

  void setSelectedItemAndFillForm(Post item){
    WidgetsBinding.instance.addPostFrameCallback((_) {
    selectedItem(item);
    update();
    fillForm();

    });
  }

  Future<void> loadData() async {
     isLoading(true);
    page(1);
    perPage(20);
    lastTotalValue(0);
    posts.clear();
    update();
    var councilId = AuthController.controller.user.value.defaultPosition?.councilId;
    Map<String, dynamic> data = {
      'page': page,
      'per_page': perPage,
      'councilId': councilId,
    };

    print(data);

    var response = await ApiService.getAuthenticatedResource(
        '/posts/council/${councilId}',
        queryParameters: data);
    response.fold((failed) {
      isLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      var data = success.data;
      List<Post> newData = (data['data'] as List<dynamic>)
          .map((task) => Post.fromMap(task))
          .toList();
      posts(newData);
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value = posts.length < lastTotalValue.value;
      isLoading(false);
      update();
    });
  }
  Future<void> loadDataOnScroll() async {
    if (isScrollLoading.value) return;

    isScrollLoading(true);
    update();
    var councilId =
        AuthController.controller.user.value.defaultPosition?.councilId;
    Map<String, dynamic> data = {
      'page': page,
      'per_page': perPage,
      'councilId': councilId,
    };

    var response = await ApiService.getAuthenticatedResource(
          '/posts/council/${councilId}',
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
        loadData();
        return;
      }

      if (posts.length == data['pagination']['total']) {
        return;
      }

      List<Post> newData = (data['data'] as List<dynamic>)
          .map((task) => Post.fromMap(task))
          .toList();
      posts.addAll(newData);
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value = posts.length < lastTotalValue.value;
      update();
    });
  }

  Future<void> createPost() async {
  if (formKey.currentState?.saveAndValidate() ?? false) {
    isLoading(true);
    update();

    try {
      Modal.loading();
      // Gather form data
      var formValues = formKey.currentState!.value;

      // Debug print to log form data
      print("Form Data:------------");
      formValues.forEach((key, value) {
        print("$key: $value");
      });

      // Prepare FormData for API request
      var formData = dio.FormData();

      // Add form fields to FormData
      // Add form fields to FormData
formValues.forEach((key, value) {
  // Ensure boolean for `is_publish` field
  if (key == 'is_publish' && value is bool) {
    formData.fields.add(MapEntry(key, value ? '1' : '0')); // Send as 1 or 0 for boolean
  } else {
    formData.fields.add(MapEntry(key, value.toString()));
  }
});

      // is_publish

      // Add media files to FormData
      for (var file in mediaFiles) {
        formData.files.add(MapEntry(
          'media[]',
          await dio.MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ));
      }

      // Debug print to log media files
      print("Media Files------------------");
      for (var file in mediaFiles) {
        print("File Path: ${file.path}");
      }
      // return;
      // API Endpoint


      
    formData.fields.forEach((field) {
  print('Field: ${field.key} = ${field.value}');
});
      String endpoint = '/posts';

      // Make API call
      var response = await ApiService.filePostAuthenticatedResource(
        endpoint,
        formData,
        onSendProgress: (int sent, int total) {
          uploadProgress.value = sent / total;
          update();
        },
      );

      response.fold(
        (failure) {
          Get.back();
          isLoading(false);
          uploadProgress.value = 0.0;
          update();
          Modal.errorDialog(failure: failure);
        },
        (success) {
             Get.back();
          isLoading(false);
          uploadProgress.value = 0.0;
          
          Modal.success(message: 'Post created successfully!');
          Get.offNamedUntil('/posts', (route) => route.isFirst);

            WidgetsBinding.instance.addPostFrameCallback((_) {
               isLoading(false);
                uploadProgress.value = 0.0;
                  clearForm();
                   Get.offNamedUntil('/posts', (route) => route.isFirst);
                    Modal.success(message: 'Post updated successfully!');
            });
            
        },
      );
    } catch (e) {
      isLoading(false);
      uploadProgress.value = 0.0;
      update();
      Modal.errorDialog(message: 'An error occurred. Please try again. ${e}');
    } finally {
      update();
    }
  } else {
    Modal.showToast(msg: 'Please complete the form.');
  }
}
Future<void> updatePost() async {
  if (formKey.currentState?.saveAndValidate() ?? false) {
    // Show loading modal
    Modal.loading();
    isLoading(true);
    update();

    try {
      // Extract form values
      var formValues = formKey.currentState!.value;

      // Prepare FormData for the API request
      var formData = dio.FormData();

      // Add form fields
      formValues.forEach((key, value) {
        if (key == 'is_publish' && value is bool) {
          // Convert boolean to 1/0
          formData.fields.add(MapEntry(key, value ? '1' : '0'));
        } else {
          formData.fields.add(MapEntry(key, value.toString()));
        }
      });

      // Add media files
      for (var file in mediaFiles) {
        formData.files.add(MapEntry(
          'media[]',
          await dio.MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        ));
      }

      // Debug log to ensure data is being sent correctly
      print("FormData being sent:");
      formData.fields.forEach((field) {
        print('${field.key}: ${field.value}');
      });

      // API endpoint for updating the post
      String endpoint = '/posts/${selectedItem.value.id}';

      // Call the API
      var response = await ApiService.filePutAuthenticatedResource(
        endpoint,
        formData,
        onSendProgress: (int sent, int total) {
          uploadProgress.value = sent / total;
          update();
        },
      );

      // Handle the API response
      response.fold(
        (failure) {
          // On failure, close the loading modal and show error
          Get.back(); // Close the modal
          isLoading(false);
          uploadProgress.value = 0.0;
          update();
          Modal.errorDialog(failure: failure);
        },
        (success) {
          // On success, clear form and return to the post list
          Get.back(); // Close the modal
          isLoading(false);
          uploadProgress.value = 0.0;
          mediaFiles.clear();
          clearForm();
          update();
          Get.offNamedUntil('/posts', (route) => route.isFirst);
          Modal.success(message: 'Post updated successfully!');
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      isLoading(false);
      uploadProgress.value = 0.0;
      update();
      Modal.errorDialog(message: 'An error occurred. Please try again. $e');
    } finally {
      // Always update state at the end
      update();
    }
  } else {
    // If validation fails, show a toast
    Modal.showToast(msg: 'Please complete the form.');
  }
}





  Future<void> deletePost() async {}
  Future<void> getPost() async {}

  void confirmDeleteMedia(int index) {
    final mediaFile = selectedItem.value.media?[index];
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
  Future<void> deleteMediaFromServer(int mediaId) async {
    try {
      Modal.loading();
      final response = await ApiService.deleteAuthenticatedResource(
        'posts/${selectedItem.value.id}/media/$mediaId',
      );
      response.fold(
        (failure) {
          Get.back();
          Modal.errorDialog(failure: failure);
        },
        (success) {
          Get.back();
          selectedItem.value.media?.removeWhere((media) => media.id == mediaId);
          update();
          loadData();
          Modal.success(message: 'File deleted successfully');
        },
      );
    } catch (e) {
      Modal.errorDialog(message: 'An unexpected error occurred');
    }
  }
  Future<void> removeFileFromDatabase() async {}
  void removeFileLocal(int index) {
    if (index >= 0 && index < mediaFiles.length) {
      mediaFiles.removeAt(index);
      update();
    }
  }

  void fillForm() {
   
     print('---------------VALUE IN FILE FORM BEFORE FILL---------------');
  print(selectedItem.value);
  print('---------------');
    WidgetsBinding.instance.addPostFrameCallback((_) {
     

    final formData = {
      'title': selectedItem.value.title ?? '',
      'content': selectedItem.value.content ?? '',
      'description': selectedItem.value.description ?? '',
       'is_publish': selectedItem.value.isPublish ?? true,
    };
      formKey.currentState?.patchValue(formData); // Populate the form with 
      update(); 
    });
  }
  void clearForm() {
    mediaFiles.clear();
    formKey.currentState?.reset();
     update();
     // Reset the form fields
  }
  void viewFile(File file) {
    if (file.path.endsWith(".mp4")) {
      Get.to(() => LocalVideoPlayer(filePath: file.path));
    } else {
      Get.to(() => LocalFileImageFullScreenDisplay(imagePath: file.path));
    }
  }



  Future<void> pickFile() async {
  const int maxFileSize = 50 * 1024 * 1024; // 50 MB in bytes
  const allowedExtensions = ['jpg', 'jpeg', 'png', 'mp4', 'mov', 'avi', 'webm']; // Expanded video formats

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
      type: FileType.custom,
      allowedExtensions: allowedExtensions, // Allow common video formats
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

        // Check if file type is allowed
        final fileExtension = file.extension?.toLowerCase();
        if (fileExtension == null || !allowedExtensions.contains(fileExtension)) {
          Modal.showToast(
            msg: 'File "${file.name}" is not a valid format. Allowed formats are: ${allowedExtensions.join(", ")}.',
            color: Palette.RED,
            toastLength: Toast.LENGTH_LONG,
          );
          continue; // Skip invalid file types
        }

        // Additional check for video files
        if (['mov', 'avi', 'webm'].contains(fileExtension) && !file.path!.endsWith(".mp4")) {
          Modal.showToast(
            msg: 'File "${file.name}" may not be viewable on all devices. Converting to mp4 is recommended.',
            color: Palette.YELLOW,
            toastLength: Toast.LENGTH_LONG,
          );
        }

        // Limit to 6 files
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

  Future<void> playFile() async {}


  void fullScreenDisplayOnline(List<MediaFile> media, MediaFile file) {
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
  void fullScreenDisplay(List<File> files, File file) {
    int initialIndex = files.indexOf(file);
    if (file.path.endsWith('.mp4')) {
      Get.to(() => LocalVideoPlayer(filePath: file.path));
    } else {
      Get.to(() => LocalFileImageFullScreenDisplay(imagePath: file.path));
    }
  }

  Future<void> delete(int id) async {
    Modal.confirmation(
      titleText: "Confirm Delete",
      contentText:
          "Are you sure you want to delete this record? This action cannot be undone.",
      onConfirm: () async {
        final councilId = AuthController.controller.user.value.defaultPosition?.councilId;
        Modal.loading(content: const Text('Deleting record...'));
        var response = await ApiService.deleteAuthenticatedResource(
          '/posts/${id}',
        );

        response.fold(
          (failure) {
            Get.back(); // Close the modal
            Modal.errorDialog(failure: failure);
          },
          (success) {
            Get.back(); // Close the modal
            posts.removeWhere((t) => t.id == id);
            update();
            Modal.success(message: 'Post deleted successfully!');
          },
        );
      },
      onCancel: () {
        Get.back();
      },
    );
  }


}
