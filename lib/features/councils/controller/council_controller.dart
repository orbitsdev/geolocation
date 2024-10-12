import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/councils/model/council.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/modal/modal.dart';

class CouncilController extends GetxController {
  var isLoading = false.obs;
  var councils = <Council>[].obs; // Observable list of councils
  var errorMessage = ''.obs;

  var currentPage = 1.obs;
  var isLastPage = false.obs; // To keep track of the last page
  var isFetchingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCouncils(); // Automatically fetch councils on initialization
  }

  // Fetch councils from the API with pagination
  Future<void> fetchCouncils({int page = 1}) async {
    if (isFetchingMore.value || isLastPage.value) return;

    isLoading(page == 1); // Show main loading for first page, otherwise, it's fetching more
    errorMessage('');

    final response = await ApiService.getAuthenticatedResource(
      'councils',
      queryParameters: {
        'page': page,
        'perPage': 10, // Adjust per page as needed
      },
    );

    response.fold(
      (failure) {
        errorMessage(failure.message ?? 'Failed to fetch councils.');
        Modal.error(content: Text(errorMessage.value));
      },
      (success) {
        List<dynamic> data = success.data['data'];
        var fetchedCouncils = data.map((json) => Council.fromMap(json)).toList();

        if (fetchedCouncils.isEmpty) {
          isLastPage(true); // If no more data, it's the last page
        } else {
          if (page == 1) {
            councils.value = fetchedCouncils; // Replace if it's the first page
          } else {
            councils.addAll(fetchedCouncils); // Append for subsequent pages
          }
        }
      },
    );
    currentPage(page);
    isLoading(false);
    isFetchingMore(false);
  }

  // Triggered when user scrolls to the bottom of the list
  Future<void> loadMoreCouncils() async {
    if (!isFetchingMore.value && !isLastPage.value) {
      isFetchingMore(true);
      await fetchCouncils(page: currentPage.value + 1);
    }
  }

  // Delete a council by ID
  Future<void> deleteCouncil(int id) async {
    isLoading(true);
    final response = await ApiService.deleteAuthenticatedResource('councils/$id');
    response.fold(
      (failure) {
        Modal.error(content: Text(failure.message ?? 'Failed to delete council.'));
      },
      (success) {
        councils.removeWhere((council) => council.id == id); // Remove from local list
        Modal.success(content: Text('Council deleted successfully.'));
      },
    );
    isLoading(false);
  }
}
