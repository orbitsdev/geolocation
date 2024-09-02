import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocation/features/profile/model/user_profile.dart';
import 'package:get/get.dart';

class ProfileController extends  GetxController {
  final formKey = GlobalKey<FormBuilderState>();
  static  ProfileController controller = Get.find();


  var userProfile = UserProfile(
    fullName: 'John Doe',
    email: 'john.doe@example.com',
    councilPosition: 'President',
    year: '2023-2024',
    profileImageUrl: 'https://i.pravatar.cc/300',
  ).obs;

  void updateProfile() {

     if (formKey.currentState?.saveAndValidate() ?? false) {
                  final selectedRole = formKey.currentState?.value['role'];
                  print('Selected Role: $selectedRole');
                  // Perform any actions with the selected role
                } else {
                  print('Validation failed');
                }

  
  }

}