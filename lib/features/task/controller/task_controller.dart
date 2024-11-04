import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:get/get.dart';

class TaskController  extends GetxController{
  TaskController controlelr = Get.find<TaskController>();
 
  final formKey = GlobalKey<FormBuilderState>();

  var selectedOfficer = CouncilPosition().obs;
  
  static TaskController controller = Get.find();
  void createTask() async {
      Modal.showToast(msg: 'Create Task IS coming soond');
    Get.back();
  }
}