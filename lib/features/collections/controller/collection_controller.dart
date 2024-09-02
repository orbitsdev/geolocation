import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class CollectionController  extends GetxController{

  final formKey = GlobalKey<FormBuilderState>();
  final List<String> chartTypes = ['Pie Chart', 'Bar Chart', 'Line Chart'];
  
  void createCollection() async {
    // Handle save collection action
                  if (formKey.currentState?.saveAndValidate() ?? false) {
                    final collectionData = formKey.currentState?.value;
                    print('Collection Data: $collectionData');
                    // Implement your save logic here
                    Get.back(); // Go back to the previous page after saving
                  }
  }
}