import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class LoginController  extends GetxController{

  static LoginController controller = Get.find();
   final formKey = GlobalKey<FormBuilderState>();
   bool obscureText = true;
   bool rememberme = false;


   void login(){
     if (formKey.currentState!.saveAndValidate()) {
      String email = formKey.currentState?.instantValue['email'];
      String password = formKey.currentState?.instantValue['password'];

        Map<String ,dynamic> data = {
          "email": email,
          "password": password,
         
        };

        print(data);
     }
   }

   void toggleRememberMe(){
     rememberme = !rememberme;
    update();
   }
   void togglePassword(){
     obscureText = !obscureText;
    update();
   }

}