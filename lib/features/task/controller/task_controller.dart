import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/council_position.dart';

import 'package:geolocation/features/task/admin_members_task_page.dart';
import 'package:geolocation/features/task/model/task.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class TaskController extends GetxController {
  static TaskController controller = Get.find<TaskController>();



  var isLoading = false.obs;
  var isScrollLoading = false.obs;
  var page = 1.obs;
  var perPage = 20.obs;
  var lastTotalValue = 0.obs;
  var hasData = false.obs;
  var tasks = <Task>[].obs;

  var isRemoving = false.obs;

  final taskFormKey = GlobalKey<FormBuilderState>();
  var selectedOfficer = CouncilPosition().obs;
  var selectedTask = Task().obs;
void initializeFormForEdit(Task task) {
  selectedOfficer.value = task.assignedCouncilPosition ?? CouncilPosition();

  // Parse the human-readable date
  DateTime? dueDate;
  if (task.dueDate != null) {
    try {
      dueDate = DateFormat('MMMM d, yyyy, h:mm a').parse(task.dueDate!);
      print('Parsed due date: $dueDate'); // Debugging output
    } catch (e) {
      print('Error parsing due date: ${task.dueDate}');
    }
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    taskFormKey.currentState?.patchValue({
      'title': task.title,
      'task_details': task.taskDetails,
      'due_date': dueDate, // Set initial value for picker
    });
    update(); // Ensure GetX reflects state
  });
}



  void selectTaskAndNavigateToFullDetails(Task task){
    selectedTask(task);
    Get.to(()=> AdminTaskCardPage(), transition: Transition.cupertino);

  }
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

    var response = await ApiService.getAuthenticatedResource('tasks', queryParameters: data);
    response.fold((failed) {
      isLoading(false);
      update();
      Modal.errorDialog( failure: failed);
    }, (success) {
      var data = success.data;  
      
      List<Task> newData = (data['data'] as List<dynamic>).map((task) => Task.fromMap(task)).toList();
      tasks(newData);
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value = tasks.length < lastTotalValue.value;
      isLoading(false);
      update();
      // tasks.forEach((e){
      //   print('___________');
      //   print(e.toJson());
      //   print('__________________');
      // });
    });

   
  }

  void loadTaskOnScroll(BuildContext context) async {
   
    if (isScrollLoading.value) return;

    isScrollLoading(true);
    update();
  
     Map<String, dynamic> data = {
      'page': page,
      'per_page': perPage,
      'councilId':  AuthController.controller.user.value.defaultPosition?.councilId,
    };

    var response = await ApiService.getAuthenticatedResource('tasks', queryParameters: data);
    response.fold((failed) {
      isScrollLoading(false);
      update();
      Modal.errorDialog(failure: failed);
    }, (success) {
      isScrollLoading(false);
      update();

      var data = success.data;
      if (lastTotalValue.value != data['pagination']['total']) {
        loadTask();
        return;
      }

       if (tasks.length == data['pagination']['total']) {
          return;
        }

      List<Task> newData = (data['data'] as List<dynamic>)
          .map((task) => Task.fromMap(task))
          .toList();
      tasks.addAll(newData);
      page.value++;
      lastTotalValue.value = data['pagination']['total'];
      hasData.value = tasks.length < lastTotalValue.value;
      update();
    });

    
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
      print(formData);

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


  void updateTask(int id) async {
    if (taskFormKey.currentState!.saveAndValidate()) {
    var formData = taskFormKey.currentState!.value;

    if (selectedOfficer.value.id == null) {
      Modal.errorDialog(message: 'Please select an officer.');
      return;
    }

    print(formData);

   String formattedDueDate =DateFormat('yyyy-MM-dd HH:mm:ss').format(formData['due_date']);
    print(formattedDueDate);



    var data = {
        'council_position_id': selectedOfficer.value.id,
        'title': formData['title'],
        'task_details': formData['task_details'],
        'due_date': formattedDueDate,
      };

       print(data);

  

    

    
     Modal.androidDialogNoContext();

    
   var response = await ApiService.putAuthenticatedResource('tasks/$id', data);

    response.fold(
      (failure) {
        Get.back(); // Close loading modal
        Modal.errorDialog(failure: failure);
      },
      (success) {
        print(success.data);
         Get.back(); // Close loading modal
         Modal.success(message: 'Task updated successfully');
         Get.offNamedUntil('/tasks', (route) => route.isFirst); 
      },
    );
  }
  }

  
  Future<void> deleteCouncilPosition(int taskId) async {
    Modal.loading(content: const Text('Deleting position...'));
    var response = await ApiService.deleteAuthenticatedResource(
      'tasks/${taskId}',
    );

    response.fold(
      (failure) {
        Get.back(); // Close the modal
        Modal.errorDialog(failure: failure);
      },
      (success) {
        Get.back(); // Close the modal
        tasks.removeWhere((t) => t.id == taskId);
        update();
        Modal.success(message: 'Task deleted successfully!');
      },
    );
  }
}
