import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/globalwidget/browser_view_page.dart';
import 'package:geolocation/core/globalwidget/images/local_file_image_full_screen_display.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/file/model/media_file.dart';
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

  Future<void> loadData() async {}
  Future<void> loadDataOnScroll() async {}
  Future<void> createPost() async {
    if (formKey.currentState?.saveAndValidate() ?? false) {
      isLoading(true);
      update();

      try {

         var formData = formKey.currentState!.value;

      // Debug print to log form data
      print("Form Data:------------");
      formData.forEach((key, value) {
        print("$key: $value");
      });

      // Prepare files for API
      var mediaFilesData = mediaFiles.map((file) => file.path).toList();

      // Debug print to log media files
      print("Media Files------------------");
      for (var file in mediaFiles) {
        print("File Path: ${file.path}");
      }
        // Prepare files for API
        // var mediaFilesData = mediaFiles.map((file) => file.path).toList();

        // var formData = dio.FormData();

        // // Add media files to FormData
        // for (var file in mediaFiles) {
        //   formData.files.add(MapEntry(
        //     'media[]',
        //     await dio.MultipartFile.fromFile(file.path,
        //         filename: file.path.split('/').last),
        //   ));
        // }
        // String endpoint = '';
        // var response = await ApiService.filePostAuthenticatedResource(
        //   endpoint,
        //   formData,
        //   onSendProgress: (int sent, int total) {
        //     uploadProgress.value = sent / total;
        //     update();
        //   },
        // );
        // response.fold((failure) {
        //   isLoading(false);

        //   uploadProgress.value = 0.0;
        //   update();
        //   Modal.errorDialog(failure: failure);
        // }, (success) {
        //   isLoading(false);
        //   uploadProgress.value = 0.0;
        //   mediaFiles.clear();
        //   Modal.success(message: 'Upload  File! Success 🎉');
        // });
      } catch (e) {
        Get.back();
        isLoading(false);
        uploadProgress.value = 0.0;
        update();
        Modal.errorDialog(message: 'An error occurred. Please try again.${e}');
      }
    }
  }

  Future<void> updatePost() async {}
  Future<void> deletePost() async {}
  Future<void> getPost() async {}
  Future<void> removeFileFromDatabase() async {}
  void removeFileLocal(int index) {
    if (index >= 0 && index < mediaFiles.length) {
      mediaFiles.removeAt(index);
      update();
    }
  }

  void fillForm() {}
  void clearForm() {}
  void viewFile(File file) {
    if (file.path.endsWith(".mp4")) {
      Get.to(() => LocalVideoPlayer(filePath: file.path));
    } else {
      Get.to(() => LocalFileImageFullScreenDisplay(imagePath: file.path));
    }
  }

  Future<void> pickFile() async {}
  Future<void> playFile() async {}

  void fullScreenDisplay(List<File> files, File file) {
    int initialIndex = files.indexOf(file);
    if (file.path.endsWith('.mp4')) {
      Get.to(() => LocalVideoPlayer(filePath: file.path));
    } else {
      Get.to(() => LocalFileImageFullScreenDisplay(imagePath: file.path));
    }
  }
}
