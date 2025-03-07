import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocation/core/api/dio/failure.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/available_user.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/features/auth/model/position_option.dart';
import 'package:geolocation/features/council_positions/model/member.dart';
import 'package:geolocation/features/council_positions/pages/council_member_position_list_page.dart';
import 'package:geolocation/features/council_positions/pages/council_member_position_list_page_admin.dart';
import 'package:geolocation/features/council_positions/pages/council_member_profile_page.dart';
import 'package:get/get.dart';

class CouncilPositionController extends GetxController {
  static CouncilPositionController controller = Get.find();
  var grantAccess = false.obs;
  
  var isFetchingCouncilPositions = false.obs;
  var isFetchingUsers = false.obs;
  var isFetchingAvailablePositions = false.obs;
  var isCreatingOrUpdating = false.obs;
  var isSearchingUsers = false.obs;

  var isPageLoading = false.obs;
  var isScrollLoading = false.obs;
  var currentPage = 1.obs;
  var itemsPerPage = 20.obs;
  var totalItems = 0.obs;
  var councilMembers = <CouncilPosition>[].obs;
  var selectedCouncilId = 0.obs;
  var usersAvailableForSelection = <AvailableUser>[].obs;
  var filteredUsers = <AvailableUser>[].obs;
  var positionOptions = <PositionOption>[].obs;
  var chosenUser = Rx<AvailableUser?>(null);
  var councilPositionFormKey = GlobalKey<FormBuilderState>();


  var selectedMember =  CouncilPosition().obs;

  var isMemberDetailsLoading = false.obs;

void selectMember(CouncilPosition member){
  selectedMember(member);
  Get.to(() => CouncilMemberProfilePage(),transition: Transition.cupertino,);
}

Future<void> refreshSelectedMemberDetails() async {
 
  isMemberDetailsLoading(true);

   var response = await ApiService.getAuthenticatedResource(
      'councils/${selectedCouncilId.value}/positions/${selectedMember.value.id}',
    );

    response.fold((failure){
      isMemberDetailsLoading(false);
      Modal.errorDialog(failure: failure);
    },  (success){
      var data = success.data['data'];
      print(data);
      selectedMember(CouncilPosition.fromMap(data));
      isMemberDetailsLoading(false);
    });
   
}

void setCouncilId(int id){    
   if(selectedCouncilId.value != id){
    councilMembers.clear();
  } 
   selectedCouncilId(id);
}

void selectAndNavigateToCouncilMemberPage(int id) {
  if(selectedCouncilId.value != id){
    councilMembers.clear();
  }
  selectedCouncilId(id);
  print('Selected Council ID: ${selectedCouncilId.value}');
  Get.to(() => CouncilMemberPositionListPage(), transition: Transition.cupertino);
}

void selectAndNavigateToCouncilMemberPageAdmin(int id) {
  if(selectedCouncilId.value != id){
    councilMembers.clear();
  }
  selectedCouncilId(id);
  print('Selected Council ID: ${selectedCouncilId.value}');
  Get.to(() => CouncilMemberPositionListAdmin(), transition: Transition.cupertino);
}




  // Fetch council members
  Future<void> fetchCouncilMembers() async {
    isPageLoading(true);
    currentPage(1);
    update(); // Using GetBuilder

    var response = await ApiService.getAuthenticatedResource(
      'councils/${selectedCouncilId.value}/positions',
      queryParameters: {'page': currentPage.value, 'perPage': itemsPerPage.value},
    );

    response.fold(
      (failure) {
        isPageLoading(false);
        Modal.error(content: Text('${failure.message}'));
        update();
      },
      (success) {
          

        var data = success.data;
        // print(selectedCouncilId.value);
        // print(data['data']);
        var newData = (data['data'] as List<dynamic>)
            .map((json) => CouncilPosition.fromJson(json))
            .toList();
        councilMembers(newData);
        currentPage.value++;
        totalItems.value = data['pagination']['total'];
        isPageLoading(false);
          //   print('______________________________________');
          // newData.forEach((e){
          //   print(e);
          // });
        update();
      },
    );
  }

  // Fetch council members on scroll
  Future<void> fetchCouncilMembersOnScroll() async {
    if (isScrollLoading.value) return;
    isScrollLoading(true);
    update(); // Using GetBuilder

    var response = await ApiService.getAuthenticatedResource(
      'councils/${selectedCouncilId.value}/positions',
      queryParameters: {'page': currentPage.value, 'perPage': itemsPerPage.value},
    );

    response.fold(
      (failure) {
        isScrollLoading(false);
        Modal.error(content: Text('${failure.message}'));
        update();
      },
      (success) {
        isScrollLoading(false);
        var data = success.data;
        var newData = (data['data'] as List<dynamic>)
            .map((json) => CouncilPosition.fromJson(json))
            .toList();
        councilMembers.addAll(newData);
        currentPage.value++;
        totalItems.value = data['pagination']['total'];
        update();
      
      },
    );
  }

  Future<void> deleteCouncilPosition(int positionId) async {
    Modal.loading(content: const Text('Deleting position...'));
    var response = await ApiService.deleteAuthenticatedResource(
      'councils/${selectedCouncilId.value}/positions/$positionId',
    );

    response.fold(
      (failure) {
        Get.back(); // Close the modal
        Modal.error(content: Text(failure.message!));
      },
      (success) {
        Get.back(); // Close the modal
        councilMembers.removeWhere((p) => p.id == positionId);
        update();
        Modal.success(message: 'Council position deleted successfully!');
      },
    );
  }

Future<void> createCouncilPosition() async {
  if (councilPositionFormKey.currentState!.saveAndValidate()) {
    if (chosenUser.value == null) {
      Modal.error(content: const Text('Please select a user.'));
      return;
    }

    var positionData = {
      'council_id': selectedCouncilId.value, // Ensure correct council ID
      'user_id': chosenUser.value!.id,
      'position': councilPositionFormKey.currentState?.fields['position']?.value,
      'grant_access': councilPositionFormKey.currentState?.fields['grant_access']?.value ?? false, 
    };

    print('position data');
    // print(positionData);

    isCreatingOrUpdating(true);

    var response = await ApiService.postAuthenticatedResource(
      'councils/${selectedCouncilId.value}/positions',
      positionData,
    );

    response.fold(
      (failure) {
        isCreatingOrUpdating(false);
               Modal.errorDialog(failure: failure);
      },
      (success) async {

        // print('_________ data of created');
        // print(success.data);
        // print('_________');
        grantAccess.value = false;
        isCreatingOrUpdating(false);
        clearSelectedUser();
        await fetchCouncilMembers(); // Refresh council members
        // No need to reset selectedCouncilId
      
        
          if(AuthController.controller.user.value.isAdmin()){
         Get.offNamedUntil('/members-admin', (route) => route.isFirst);

          }else{
         Get.offNamedUntil('/members', (route) => route.isFirst);

          }

            Modal.success(message:'New Member was created successfully');
            

      },
    );
  }
}



  Future<void> updateCouncilPosition(int positionId) async {
    if (councilPositionFormKey.currentState!.saveAndValidate()) {
      if (chosenUser.value == null) {


        Modal.errorDialogMessage(message: 'Please select a user.');
        return;
      }

      var positionData = {
        'council_id': selectedCouncilId.value,
        'user_id': chosenUser.value!.id,
        'position': councilPositionFormKey.currentState?.fields['position']?.value,
         'grant_access': councilPositionFormKey.currentState?.fields['grant_access']?.value ?? false,
      };

      isCreatingOrUpdating(true);

      var response = await ApiService.putAuthenticatedResource(
        'councils/${selectedCouncilId.value}/positions/$positionId',
        positionData,
      );

      response.fold(
        (failure) {
          isCreatingOrUpdating(false);
          update();
          Modal.errorDialog(failure: failure);
        },
        (success) {
          isCreatingOrUpdating(false);
          update();
          clearSelectedUser();
          fetchCouncilMembers();
          Get.offNamedUntil( '/councils', (route) => Get.currentRoute == '/create-or-edit');
          Get.to(()=>CouncilMemberPositionListPage(),  transition: Transition.cupertino);
         
            
      Modal.success(message: 'Position updated successfully!');
        },
      );
    }
  }

  Future<void> fetchAvailableUsers() async {
    isFetchingUsers(true);
    update();
    var response = await ApiService.getAuthenticatedResource(
      'councils/$selectedCouncilId/available-users',
    );

    response.fold(
      (failure) {
        isFetchingUsers(false);
        update();
      Modal.errorDialog(failure: failure);
      },
      (success) {
        isFetchingUsers(false);
        update();
        var userData = (success.data['data'] as List<dynamic>);

        usersAvailableForSelection.value = userData.map((json) => AvailableUser.fromMap(json as Map<String, dynamic>)) .toList();
        filteredUsers.value = usersAvailableForSelection;

        isFetchingUsers(false);
      },
    );
  }

  Future<void> fetchAvailablePositions() async {
    isFetchingAvailablePositions(true);
    var response = await ApiService.getAuthenticatedResource('positions');
    response.fold(
      (failure) {
        isFetchingAvailablePositions(false);
      },
      (success) {
        var positionData = success.data['data'] as List<dynamic>;
        positionOptions.value =
            positionData.map((e) => PositionOption.fromJson(e)).toList();
        isFetchingAvailablePositions(false);
      },
    );
  }

  Future<void> searchUsersInDatabase(String query) async {
    var response = await ApiService.getAuthenticatedResource(
      'councils/$selectedCouncilId/available-users',
      queryParameters: {
        'search': query,
      },
    );

    response.fold(
      (failure) {
        isSearchingUsers(false);
      Modal.errorDialog(failure: failure);
      },
      (success) {
        print(success.data);
      },
    );
  }

  Future<void> searchAvailableUsers(String query) async {
    if (query.isEmpty) {
      await fetchAvailableUsers();
    } else {
      await searchUsersInDatabase(query);
    }
  }

  void clearSelectedUser() {
    chosenUser.value = null;
  }

  Future<void> switchPosition(int positionId) async {
 
  Modal.loading(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircularProgressIndicator(),
        const SizedBox(width: 16),
        Text('Switching position...'),
      ],
    ),
  );

  // Send the PUT request to switch the is_login status
  var response = await ApiService.putAuthenticatedResource(
    '/council-positions/$positionId/switch',
    {},
  );

  // Close the loading modal
  Get.back();

  response.fold(
    (failure) {
      // Show an error message if the API request failed

      Modal.errorDialog(failure: failure);
     
    },
    (success) {

      var data = success.data['data'];
      
      Modal.success(message: 'Position switched successfully!');
      

    },
  );
}

}
