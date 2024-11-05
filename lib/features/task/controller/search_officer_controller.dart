import 'package:flutter/material.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/constant/log_helper.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/task/controller/task_controller.dart';
import 'package:get/get.dart';

class SearchOfficerController extends GetxController {
  var searchText = ''.obs;
  var isSearchLoading = false.obs;
  var isInitialDataLoading = false.obs;
  var officers = <CouncilPosition>[].obs;
  TextEditingController textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Debounce setup
    debounce(searchText, (search) {
      handleSearch(search);
    }, time: const Duration(milliseconds: 500));

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

  void handleSearch(String search) async {
    if (search.isEmpty) {
     loadOfficers();
      return;
    }

    isSearchLoading(true);
    update();
    var councId =  AuthController.controller.user.value.defaultPosition?.councilId;
    Map<String, dynamic> data = {
      'search': search,
      'take': 20,
    };


    var response = await ApiService.getAuthenticatedResource(
        'councils/${councId}/search-officers',
        queryParameters: data);
    response.fold(
      (failure) {
        isSearchLoading(false);
        update();
       
     
      },
      (success) {
        var data = (success.data['data'] as List<dynamic>);

        officers(data .map( (json) => CouncilPosition.fromMap(json as Map<String, dynamic>)).toList());
        isSearchLoading(false);
        update();
      },
    );
  }

  Future<void> loadOfficers() async {
    var councId =  AuthController.controller.user.value.defaultPosition?.councilId;
    Map<String, dynamic> data = {
      'take': 20,
    };
    isInitialDataLoading(true);
    update();
      var response = await ApiService.getAuthenticatedResource('councils/${councId}/search-officers',
        queryParameters: data);
    response.fold(
      (failure) {
        isInitialDataLoading(false);
        update();
        print(failure);
     
      },
      (success) {
        print(success.data);
        var data = (success.data['data'] as List<dynamic>);
        officers(data.map( (json) => CouncilPosition.fromMap(json as Map<String, dynamic>)).toList());
        isInitialDataLoading(false);
        // Log.print(results);
        update();
      },
    );
  }

  void clearSearch() {
    textController.clear();
    searchText.value = '';
    officers.clear();
    update();
  }
}
