
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/auth/model/available_user.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/features/auth/model/position_option.dart';
import 'package:geolocation/features/council_positions/pages/council_member_position_list_page.dart';
import 'package:get/get.dart';

class CouncilPositionController extends GetxController {
  static CouncilPositionController controller = Get.find();
  var positions = <CouncilPosition>[].obs;
  var availablePositions = <PositionOption>[].obs;
  
  // Separate loading variables
  var isLoadingCouncilPositions = false.obs;
  var isLoadingAvailableUsers = false.obs;
  var isLoadingAvailablePositions = false.obs;
  var createOrUpdateLoading = false.obs;
  var isSearchingUsers = false.obs;
  
  
  var isFetchingMore = false.obs;
  var isLastPage = false.obs;
  var errorMessage = ''.obs;
  var page = 1.obs;
  var perPage = 20.obs;
  var councilId = 0.obs;

  // To manage available users and search
  var availableUsers = <AvailableUser>[].obs;
  var filteredAvailableUsers = <AvailableUser>[].obs;


  // Selected user and form key for creating/editing council positions
  var selectedUser = Rx<AvailableUser?>(null);
  var formKey = GlobalKey<FormBuilderState>();

  // Method to load initial council positions
  void clearCouncilPositions() {
    positions.clear();
    page(1);
    isLastPage(false);
    isLoadingCouncilPositions(false);
    isFetchingMore(false);
    errorMessage('');
  }

  Future<void> loadCouncilPositions() async {
    isLoadingCouncilPositions(true);
    errorMessage('');
    page(1);
    isLastPage(false);
    positions.clear();

    var response = await ApiService.getAuthenticatedResource(
      'councils/${councilId.value}/positions',
      queryParameters: {'page': page.value, 'perPage': perPage.value},
    );

    response.fold(
      (failure) {
        isLoadingCouncilPositions(false);
        errorMessage(failure.message ?? 'Failed to load council positions');
      },
      (success) {
        var positionData = (success.data['data'] as List<dynamic>);
        var fetchedPositions = positionData.map((json) => CouncilPosition.fromJson(json)).toList();

        positions.addAll(fetchedPositions);
        isLastPage(fetchedPositions.length < perPage.value);
        page.value++;
        isLoadingCouncilPositions(false);
      },
    );
  }

  // Method to load more council positions for infinite scroll
  Future<void> loadMoreCouncilPositions() async {
    if (isLastPage.value || isFetchingMore.value) return;

    isFetchingMore(true);

    var response = await ApiService.getAuthenticatedResource(
      'councils/${councilId.value}/positions',
      queryParameters: {'page': page.value, 'perPage': perPage.value},
    );

    response.fold(
      (failure) {
        isFetchingMore(false);
        errorMessage(failure.message ?? 'Failed to load more council positions');
      },
      (success) {
        var positionData = success.data['data'] as List<dynamic>;
        var fetchedPositions = positionData.map((json) => CouncilPosition.fromJson(json)).toList();

        positions.addAll(fetchedPositions);
        isLastPage(fetchedPositions.length < perPage.value);
        page.value++;
        isFetchingMore(false);
      },
    );
  }

  // Method to delete a council position
  Future<void> deleteCouncilPosition(int positionId) async {
    Modal.loading(content: const Text('Deleting position...'));
    var response = await ApiService.deleteAuthenticatedResource(
      'councils/${councilId.value}/positions/$positionId',
    );

    response.fold(
      (failure) {
        Get.back(); // Close the modal
        Modal.error(content: Text(failure.message!));
      },
      (success) {
        Get.back(); // Close the modal
        positions.removeWhere((p) => p.id == positionId);
        Modal.success(content: const Text('Council position deleted successfully!'));
      },
    );
  }

  // Method to create a council position
 // Controller methods
Future<void> createCouncilPosition() async {
  if (formKey.currentState!.saveAndValidate()) {
    if (selectedUser.value == null) {
      Modal.error(content: const Text('Please select a user.'));
      return;
    }

    var positionData = {
      'council_id': councilId.value,
      'user_id': selectedUser.value!.id,
      'position': formKey.currentState?.fields['position']?.value,
    };

    // Set loading to true
    createOrUpdateLoading(true);
    
    var response = await ApiService.postAuthenticatedResource(
      'councils/${councilId.value}/positions',
      positionData,
    );

    response.fold(
      (failure) {
        createOrUpdateLoading(false); // Stop loading on failure
        Modal.error(content: Text(failure.message!));
      },
      (success) async{
        createOrUpdateLoading(false); // Stop loading on success
        
        await loadCouncilPositions(); 
        Get.offUntil(
          MaterialPageRoute(builder: (_) => CouncilMemberPositionListPage()),
          (route) => route.isFirst, // Keep removing until we reach the first route (list page)
        );
        // Refresh the council positions list after creation
      },
    );
  }
}

Future<void> updateCouncilPosition(int positionId) async {
  if (formKey.currentState!.saveAndValidate()) {
    if (selectedUser.value == null) {
      Modal.error(content: const Text('Please select a user.'));
      return;
    }

    var positionData = {
      'council_id': councilId.value,
      'user_id': selectedUser.value!.id,
      'position': formKey.currentState?.fields['position']?.value,
    };

    // Set loading to true
    createOrUpdateLoading(true);
    
    var response = await ApiService.putAuthenticatedResource(
      'councils/${councilId.value}/positions/$positionId',
      positionData,
    );

    response.fold(
      (failure) {
        createOrUpdateLoading(false); // Stop loading on failure
        Modal.error(content: Text(failure.message!));
      },
      (success) {
        createOrUpdateLoading(false); // Stop loading on success
        Modal.success(content: const Text('Council position updated successfully!'));
        loadCouncilPositions(); // Refresh the council positions list after updating
      },
    );
  }
}


  // Method to fetch available users for assigning to a position
  Future<void> fetchAvailableUsers() async {
  var response = await ApiService.getAuthenticatedResource(
    'councils/$councilId/available-users',
  );

  response.fold(
    (failure) {
      // Handle the failure case
      print('Failed to load available users');
    },
    (success) {
      var userData = (success.data['data'] as List<dynamic>);
      
      // This ensures each item in the list is treated as a Map<String, dynamic>
      availableUsers.value = userData.map((json) => AvailableUser.fromMap(json as Map<String, dynamic>)).toList();
      filteredAvailableUsers.value = availableUsers;

      // Update loading state
      isLoadingAvailableUsers(false);
    },
  );
}



  // Method to fetch available positions for dropdown
  Future<void> fetchPositions() async {
    isLoadingAvailablePositions(true);
    var response = await ApiService.getAuthenticatedResource('positions');
    response.fold(
      (failure) {
        isLoadingAvailablePositions(false);
        errorMessage(failure.message ?? 'Failed to load positions');
      },
      (success) {
        var positionData = success.data['data'] as List<dynamic>;
        availablePositions.value = positionData.map((e) => PositionOption.fromJson(e)).toList();
        isLoadingAvailablePositions(false);
      },
    );
  }

  // Method to search available users based on input
  Future<void> searchUsersInDatabase(String query) async {
  // isSearchingUsers(true); // Start loading state

  var response = await ApiService.getAuthenticatedResource(
    'councils/$councilId/available-users',
    queryParameters: {
      'search': query, // Assuming 'search' is the query parameter for searching users on the server
    },
  );

  response.fold(
    (failure) {
      isSearchingUsers(false); // Stop loading on failure
      Modal.error(content: Text(failure.message!));
    },
    (success) {
      print(success.data);
      // var userData = (success.data['data'] as List<dynamic>);
      
      // // This ensures each item in the list is treated as a Map<String, dynamic>
      // availableUsers.value = userData.map((json) => AvailableUser.fromMap(json as Map<String, dynamic>)).toList();
      // filteredAvailableUsers.value = availableUsers;
      // print('_________SErch');
      // print(userData);
      
      // isSearchingUsers(false); // Stop loading on success
    },
  );
}

// Method to decide whether to fetch or search users
Future<void> searchAvailableUsers(String query) async {
  if (query.isEmpty) {
    // Fetch the full list of users when the query is empty
    await fetchAvailableUsers();
  } else {
    // Search in the database when a query is provided
    await searchUsersInDatabase(query);
  }
}

}
