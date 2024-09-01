import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:get/get.dart';

class MemberController extends GetxController{  

  final formKey = GlobalKey<FormBuilderState>();
  static MemberController controller = Get.find();


  void createMember() async{

    Modal.showToast(msg: 'Create Member soon');
    Get.back();
      // if (formKey.currentState!.saveAndValidate()) {


      //  }
  }  

}