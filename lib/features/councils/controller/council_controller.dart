import 'package:flutter/material.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/images/local_lottie_image.dart';
import 'package:geolocation/features/council_positions/controller/council_position_controller.dart';
import 'package:geolocation/features/council_positions/pages/council_member_position_list_page.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/councils/model/council.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/modal/modal.dart';

class CouncilController extends GetxController {
  bool isLoading = false; // For the initial load
  bool isFetchingMore = false; // For paginated loading (infinite scroll)
  bool isLastPage = false; // Flag to check if we have reached the last page
  List<Council> councils = []; // List of councils
  String errorMessage = ''; // Error message holder

  int currentPage = 1; // Tracks the current page being fetched
  final int perPage = 10; // Number of items to load per page

  @override
  void onInit() {
    super.onInit();
    fetchCouncils(); // Automatically fetch councils when controller is initialized
  }

  void goToCouncilMembers(int councilId) {
    CouncilPositionController.controller.councilId.value = councilId; // Set the new council ID
    CouncilPositionController.controller.clearCouncilPositions(); // Clear previous council data
    Get.to(() => CouncilMemberPositionListPage(), transition: Transition.cupertino);
  }

  // Fetch councils with pagination
  Future<void> fetchCouncils({int page = 1}) async {
    if (isFetchingMore || isLastPage) return; // Don't fetch more if already fetching or last page reached

    isLoading = page == 1;
    errorMessage = ''; // Clear error messages
    update(); // Update the UI

    final response = await ApiService.getAuthenticatedResource(
      'councils',
      queryParameters: {
        'page': page,
        'perPage': perPage,
      },
    );

    response.fold(
      (failure) {
        // Handle error
        errorMessage = failure.message ?? 'Failed to fetch councils.';
        Modal.error(content: Text(errorMessage));
        isLoading = false;
        update();
      },
      (success) {
        List<dynamic> data = success.data['data'];
        var fetchedCouncils = data.map((json) => Council.fromMap(json)).toList();

        if (fetchedCouncils.isEmpty) {
          isLastPage = true; // No more data, set the last page flag
        } else {
          if (page == 1) {
            councils = fetchedCouncils; // Replace data on first load
          } else {
            councils.addAll(fetchedCouncils); // Append data on subsequent loads
          }
        }
        currentPage = page; // Update the current page number
        isLoading = false;
        isFetchingMore = false;
        update();
      },
    );
  }

  // Load more councils (triggered when the user scrolls to the bottom)
  Future<void> loadMoreCouncils() async {
    if (!isFetchingMore && !isLastPage) {
      isFetchingMore = true;
      update();
      await fetchCouncils(page: currentPage + 1); // Increment page for loading more
    }
  }

  // Delete a council
  Future<void> deleteCouncil(int id) async {
    Modal.confirmation(
      titleText: 'Delete Council',
      contentText: 'Are you sure you want to delete this council?',
      onConfirm: () async {
        Modal.loading(content: Text('Deleting council...'));

        final response = await ApiService.deleteAuthenticatedResource('councils/$id');

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

  // Create a new council
  Future<void> createCouncil(String name) async {
    Modal.loading(content: Text('Creating council...')); // Show loading modal

    final response = await ApiService.postAuthenticatedResource(
      'councils',
      {
        'name': name,
      },
    );

    // Close the loading modal
    Get.back();

    response.fold(
      (failure) {
        Modal.error(content: Text(failure.message ?? 'Failed to create council.'));
      },
      (success) {
        fetchCouncils(); // Refresh the list of councils after creation
        Modal.success(
          visualContent: LocalLottieImage(repeat: false, path: lottiesPath('success.json')),
          content: Text('Council created successfully.'),
        );
      },
    );
  }

  // Update an existing council
  Future<void> updateCouncil(int id, String name) async {
    Modal.loading(content: Text('Updating council...')); // Show loading modal

    final response = await ApiService.putAuthenticatedResource(
      'councils/$id',
      {
        'name': name,
      },
    );

    // Close the loading modal
    Get.back();

    response.fold(
      (failure) {
        Modal.error(content: Text(failure.message ?? 'Failed to update council.'));
      },
      (success) {
        fetchCouncils(); // Refresh the list of councils after update
        Modal.success(
          visualContent: LocalLottieImage(repeat: false, path: lottiesPath('success.json')),
          content: Text('Council updated successfully.'),
        );
      },
    );
  }

  // Reload councils
  Future<void> loadCouncils() async {
    isLoading = true;
    errorMessage = '';
    update();

    var response = await ApiService.getAuthenticatedResource(
      'councils',
      queryParameters: {'page': 1, 'perPage': perPage},
    );

    response.fold(
      (failure) {
        isLoading = false;
        errorMessage = failure.message ?? 'Failed to load councils';
        update();
      },
      (success) {
        var councilData = (success.data['data'] as List<dynamic>);
        councils = councilData.map((json) => Council.fromJson(json)).toList();
        isLoading = false;
        isLastPage = councils.length < perPage;
        update();
      },
    );
  }
}
