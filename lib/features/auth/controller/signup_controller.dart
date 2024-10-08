import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocation/features/role/login_selection_page.dart';
import 'package:get/get.dart';

class SignupController  extends GetxController{

  static SignupController controller = Get.find();
   final formKey = GlobalKey<FormBuilderState>();
   bool obscurePassword = true;
   bool obscureConfirm = true;


   void register(){
        Get.to(()=> LoginSelectionPage(), transition: Transition.cupertino);
    //  if (formKey.currentState!.saveAndValidate()) {
      
    //   String name = formKey.currentState?.instantValue['name'];
    //   String email = formKey.currentState?.instantValue['email'];
    //   String password = formKey.currentState?.instantValue['password'];
    //   String password_confirmation = formKey.currentState?.instantValue['password_confirmation'];

    //     Map<String ,dynamic> data = {
    //       "name": name,
    //       "email": email,
    //       "password": password,
    //       "password_confirmation": password_confirmation,
    //     };

      

    //  }
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