import 'package:flutter/material.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:get/get.dart';

class SearchOfficerController extends GetxController {

  var searchText = ''.obs; 
  var isSearchLoading = false.obs;
  var isRandomProductsIsLoading = false.obs;
  var isRelatedProductLoading = false.obs;
  var results = <CouncilPosition>[].obs;
  TextEditingController textController = TextEditingController();


  
  @override
  void onInit() {
    super.onInit();

    // Debounce setup
    debounce(
     searchText, (search) { BuildContext context = Get.context as BuildContext; handleSearch(context, search); }, time: const Duration(milliseconds: 500 )
    );

    // Listener for text changes
    textController.addListener(() {
      searchText.value = textController.text.trim();
      update();
      
    });
  }

  @override
  void onClose() {
    textController.dispose();
    super.onClose();
  }

  
  void handleSearch(BuildContext context, String search) async {
    if (search.isEmpty) {
     
      loadOfficers();
      return;
    }

    isSearchLoading(true);
    update();

    Map<String, dynamic> data = {
      'search': search,
      'take': 20,
      'council_id': AuthController.controller.user.value
    };

    var response = await ApiService.getAuthenticatedResource('global-search', queryParameters: data);
    response.fold(
      (failure) {

        isSearchLoading(false);
        results([]);
        update();
        // Modal.showErrorDialog(context);
      },
      (success) {
      
        isSearchLoading(false);
        update();

     
      },
    );
  }

  Future<void> loadOfficers() async {

  }
}