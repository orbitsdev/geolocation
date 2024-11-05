import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:geolocation/features/task/model/task.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  static TaskController controller = Get.find<TaskController>();



  var isLoading = false.obs;
  var isScrollLoading = false.obs;
  var page = 1.obs;
  var perPage = 10.obs;
  var lastTotalValue = 0.obs;
  var hasData = false.obs;
  var tasks = <Task>[].obs;

  var isRemoving = false.obs;

  final taskFormKey = GlobalKey<FormBuilderState>();
  var selectedOfficer = CouncilPosition().obs;


  Future<void> loadTask() async {
    isLoading(true);
    page(1);
    perPage(20);
    lastTotalValue(0);
    tasks.clear();
    update();

    Map<String, dynamic> data = {
      'page': page,
      'per_page': perPage,
      'councilId':  AuthController.controller.user.value.defaultPosition?.councilId,
    };


    print(data);

    var response = await ApiService.getAuthenticatedResource('tasks',
        queryParameters: data);
    response.fold((failed) {
      isLoading(false);
      update();
      Modal.errorDialog( failure: failed);
    }, (success) {
      var data = success.data;

        // CouncilPosition newCounCilPosition =  CouncilPosition.fromMap(success.data['data'][0]['assigned_council_position']);
        // print(newCounCilPosition);
      
      List<Task> newData = (data['data'] as List<dynamic>).map((task) => Task.fromMap(task)) .toList();
      tasks(newData);
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value = tasks.length < lastTotalValue.value;
      isLoading(false);
      update();
      tasks.forEach((e){
        print('___________');
        print(e.toJson());
        print('__________________');
      });
    });

   
  }

  void loadTaskOnScroll(BuildContext context) async {
    // if (isScrollLoading.value) return;

    // isScrollLoading(true);
    // update();
    // Map<String, dynamic> data = {
    //   'user_id': AuthController.controller.user.value.id,
    //   'page': page,
    //   'per_page': perPage,
    // };

    // var response = await ApiService.getAuthenticatedResource('favorite',
    //     queryParameters: data);

    // response.fold((failed) {
    //   isScrollLoading(false);
    //   update();
    //   Modal.showErrorDialog(context, failure: failed);
    // }, (success) {
    //   isScrollLoading(false);
    //   update();

    //   var data = success.data;
    //   if (lastTotalValue.value != data['total']) {
    //     loadFavorites(context);
    //     return;
    //   }

    //    if (products.length == data['total']) {
    //       return;
    //     }

    //   List<Product> newData = (data['data'] as List<dynamic>)
    //       .map((product) => Product.fromMap(product))
    //       .toList();
    //   products.addAll(newData);
    //   page.value++;
    //   lastTotalValue.value = data['total'];
    //   hasData.value = products.length < lastTotalValue.value;
    //   update();
    // });

    
  }



  void selectOfficer(CouncilPosition officer) {
    selectedOfficer(officer);
    update();
    Get.back();
  }

  void closeCreateTask() {
    selectedOfficer(CouncilPosition());
    update();
    Get.back();
  }

  void createTask() async {
    if (taskFormKey.currentState!.saveAndValidate()) {
      var formData = taskFormKey.currentState?.value;

      if (selectedOfficer.value.id == null) {
        Modal.errorDialog(message: 'Please select a officer.');
        return;
      }
      String formattedDueDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(formData!['due_date']);

      Modal.androidDialogNoContext();
      var data = {
        'council_position_id': selectedOfficer.value.id,
        'title': formData['title'],
        'task_details': formData['task_details'],
        'due_date': formattedDueDate,
      };

      var response = await ApiService.postAuthenticatedResource(
        'tasks',
        data,
      );

      response.fold(
        (failure) {
          print(failure.message);
          Modal.errorDialog(failure: failure);
        },
        (success) async {
          Get.back();

          Modal.success(message: 'Task was  successfully created');
          Get.offNamedUntil('/tasks', (route) => route.isFirst);
        },
      );
    }
  }
}
