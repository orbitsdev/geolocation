import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class LoginController  extends GetxController{

  static LoginController controller = Get.find();
   final formKey = GlobalKey<FormBuilderState>();
   bool obscureText = true;

}