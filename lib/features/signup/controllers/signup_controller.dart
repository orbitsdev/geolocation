import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';

class SignupController  extends GetxController{

  static SignupController controller = Get.find();
   final formKey = GlobalKey<FormBuilderState>();
   bool obscurePassword = true;
   bool obscureConfirm = true;


   void register(){
     if (formKey.currentState!.saveAndValidate()) {
      
      String name = formKey.currentState?.instantValue['name'];
      String email = formKey.currentState?.instantValue['email'];
      String password = formKey.currentState?.instantValue['password'];
      String password_confirmation = formKey.currentState?.instantValue['password_confirmation'];

        Map<String ,dynamic> data = {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": password_confirmation,
        };

                print(data);

     }
   }

   
   void togglePassword(){
     obscurePassword = !obscurePassword;
    update();
   }
   void togglePasswordConfirm(){
     obscureConfirm = !obscureConfirm;
    update();
   }

}