import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/files/pages/media_resource_browser_viewer_page.dart';
import 'package:geolocation/features/files/widget/media_resource_viewer.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/files/model/media_resource.dart';

import 'package:geolocation/features/auth/controller/auth_controller.dart';


class MediaController extends GetxController {
  static MediaController controller = Get.put(MediaController());

  /// Observables
  var isLoading = false.obs;
  var isScrollLoading = false.obs;
  var mediaResources = <MediaResource>[].obs;
  var page = 1.obs;
  var perPage = 20.obs;
  var lastTotalValue = 0.obs;
  var hasData = false.obs;

  /// Fetch Media Resources
  Future<void> loadMediaResources() async {
    isLoading(true);
    page(1);
    perPage(20);
    lastTotalValue(0);
    mediaResources.clear();
    update();

    // Access councilId dynamically from AuthController
    var councilId = AuthController.controller.user.value.defaultPosition?.councilId;

    if (councilId == null) {
      isLoading(false);
      update();
      Modal.errorDialog(message: 'No council ID found for the current user.');
      return;
    }

    Map<String, dynamic> data = {
      'page': page.value,
      'per_page': perPage.value,
    };

    // API Call
    var response = await ApiService.getAuthenticatedResource(
        'media/by-council/$councilId',
        queryParameters: data);
    response.fold((failed) {
      isLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      var data = success.data;

      // Parse media resources
      List<MediaResource> newData = (data['data'] as List<dynamic>)
          .map((media) => MediaResource.fromMap(media))
          .toList();

      mediaResources(newData);
      page.value++;
      lastTotalValue.value = data['meta']['total'];
      hasData.value = mediaResources.length < lastTotalValue.value;
      isLoading(false);
      update();
    });
  }

  /// Load More Media on Scroll
  Future<void> loadMediaOnScroll() async {
    if (isScrollLoading.value) return;

    isScrollLoading(true);
    update();

    // Access councilId dynamically from AuthController
    var councilId = AuthController.controller.user.value.defaultPosition?.councilId;

    if (councilId == null) {
      isScrollLoading(false);
      update();
      Modal.errorDialog(message: 'No council ID found for the current user.');
      return;
    }

    Map<String, dynamic> data = {
      'page': page.value,
      'per_page': perPage.value,
    };

    // API Call
    var response = await ApiService.getAuthenticatedResource(
        'media/by-council/$councilId',
        queryParameters: data);
    response.fold((failed) {
      isScrollLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      isScrollLoading(false);
      update();

      var data = success.data;
      if (lastTotalValue.value != data['meta']['total']) {
        loadMediaResources();
        return;
      }

      if (mediaResources.length == data['meta']['total']) {
        return;
      }

      // Append new media resources
      List<MediaResource> newData = (data['data'] as List<dynamic>)
          .map((media) => MediaResource.fromMap(media))
          .toList();
      mediaResources.addAll(newData);
      page.value++;
      lastTotalValue.value = data['meta']['total'];
      hasData.value = mediaResources.length < lastTotalValue.value;
      update();
    });
  }

  /// Full-Screen Display
  void fullScreenDisplay(List<MediaResource> mediaResources, MediaResource selectedResource) {
    int initialIndex = mediaResources.indexOf(selectedResource);

    if (selectedResource.type?.startsWith('image') == true ||
        selectedResource.type?.startsWith('video') == true) {
      Get.to(() => MediaResourceViewer(
            mediaResources: mediaResources,
            initialIndex: initialIndex,
          ));
    } else {
      Get.to(() => MediaResourceBrowserViewerPage(file: selectedResource));
    }
  }
}
