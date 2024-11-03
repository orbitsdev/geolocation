import 'package:flutter/material.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/images/local_lottie_image.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/councils/model/council.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:get/get.dart';
class CouncilController extends GetxController {
  var isLoading = false.obs; // For the initial load
  var isFetchingMore = false.obs; // For paginated loading (infinite scroll)
  var councils = <Council>[].obs; // List of councils
  var currentPage = 1.obs; // Tracks the current page being fetched
  var itemsPerPage = 10.obs; // Number of items to load per page
  var totalItems = 0.obs; // Total number of councils from the server

  @override
  void onInit() {
    super.onInit();
    // fetchCouncils(); // Automatically fetch councils when the controller is initialized
  }

  // Fetch councils
  Future<void> fetchCouncils() async {
    isLoading(true);
    currentPage(1); // Reset to the first page when fetching initially
    update();

    var response = await ApiService.getAuthenticatedResource(
      'councils',
      queryParameters: {'page': currentPage.value, 'perPage': itemsPerPage.value},
    );

    response.fold(
      (failure) {
        isLoading(false);
        Modal.error(content: Text('Failed to fetch councils.'));
        update();
      },
      (success) {
        var data = success.data;
        var newData = (data['data'] as List<dynamic>)
            .map((json) => Council.fromMap(json))
            .toList();

        councils(newData);
        currentPage.value++;
        totalItems.value = data['pagination']['total']; // Get the total number of councils
        isLoading(false);
        update();
      },
    );
  }

  // Fetch councils on scroll (pagination)
  Future<void> fetchCouncilsOnScroll() async {
    if (isFetchingMore.value || councils.length >= totalItems.value) return;

    isFetchingMore(true);
    update();

    var response = await ApiService.getAuthenticatedResource(
      'councils',
      queryParameters: {'page': currentPage.value, 'perPage': itemsPerPage.value},
    );

    response.fold(
      (failure) {
        isFetchingMore(false);
        Modal.error(content: Text(failure.message ?? 'Failed to fetch more councils.'));
        update();
      },
      (success) {
        var data = success.data;
        var newData = (data['data'] as List<dynamic>)
            .map((json) => Council.fromMap(json))
            .toList();

        councils.addAll(newData);
        currentPage.value++;
        totalItems.value = data['pagination']['total']; // Update total items count
        isFetchingMore(false);
        update();
      },
    );
  }

  // Reload councils (used for pull-to-refresh)
  Future<void> reloadCouncils() async {
    await fetchCouncils();
  }

  // Delete a council
  Future<void> deleteCouncil(int id) async {
    Modal.confirmation(
      titleText: 'Delete Council',
      contentText: 'Are you sure you want to delete this council?',
      onConfirm: () async {
        Modal.loading(content: Text('Deleting council...'));

        var response = await ApiService.deleteAuthenticatedResource('councils/$id');

        Get.back(); // Close the loading modal

        response.fold(
          (failure) {
            Modal.error(content: Text(failure.message ?? 'Failed to delete council.'));
          },
          (success) {
            councils.removeWhere((council) => council.id == id); // Remove the deleted council
            update();
            Modal.success(content: Text('Council deleted successfully.'));
          },
        );
      },
    );
  }

  Future<void> createCouncil(String name) async {
    Modal.loading(content: Text('Creating council...')); // Show loading modal

    final response = await ApiService.postAuthenticatedResource(
      'councils',
      {'name': name},
    );

    Get.back(); // Close the loading modal

    response.fold(
      (failure) {
        Modal.error(content: Text(failure.message ?? 'Failed to create council.'));
      },
      (success) {
        fetchCouncils(); // Reload the council list after successful creation
        Modal.success(content: Text('Council created successfully.'));
      },
    );
  }

  // Update an existing council
  Future<void> updateCouncil(int id, String name) async {
    Modal.loading(content: Text('Updating council...')); // Show loading modal

    final response = await ApiService.putAuthenticatedResource(
      'councils/$id',
      {'name': name},
    );

    Get.back(); // Close the loading modal

    response.fold(
      (failure) {
        Modal.error(content: Text(failure.message ?? 'Failed to update council.'));
      },
      (success) {
        fetchCouncils(); // Reload the council list after successful update
        Modal.success(content: Text('Council updated successfully.'));
      },
    );
  }
}
