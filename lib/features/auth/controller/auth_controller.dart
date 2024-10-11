import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/images/local_image_widget.dart';
import 'package:geolocation/core/globalwidget/images/local_lottie_image.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/auth/model/user.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/localdata/secure_storage.dart';
import 'package:geolocation/core/api/dio/failure.dart'; // Import your Failure model

class AuthController extends GetxController {
  static AuthController controller = Get.find();


  final signupFormKey = GlobalKey<FormBuilderState>();

  var obscureText = true.obs;
  var obscurePassword = true.obs;
  var obscureConfirm = true.obs;

  var isLoginLoading = false.obs;
  var isSignupLoading = false.obs;

  var rememberMe = false.obs;

  var user = User().obs;
  var token = ''.obs; 
  var isTokenLoaded = false.obs; 

  Future<void> loadTokenAndUser() async {
    try {
      String? savedToken = await SecureStorage().readSecureData('token');

      if (savedToken != null && savedToken.isNotEmpty) {
        token.value = savedToken;

        String? userJson = await SecureStorage().readSecureData('user');
        if (userJson != null && userJson.isNotEmpty) {
          user(User.fromJson(jsonDecode(userJson)));
        }
      }
    } catch (e) {
      print("Error loading token and user: $e");
    } finally {
      isTokenLoaded.value = true;
   
      await fetchAndUpdateUserDetails();
    }
  }

  Future<void> fetchAndUpdateUserDetails() async {
   
    if (token.value.isNotEmpty) {
      final response = await ApiService.getAuthenticatedResource('user');

      response.fold(
        (failure) {
          print('Error fetching user details: ${failure.message}');
        },
        (success) async {
           final updatedUser = User.fromJson(success.data['data']);
  

  print('Fetched user: ${updatedUser.toJson()}');
  print('Local stored user: ${user.value.toJson()}');
  

  if (updatedUser != user.value) {
    print('User details are different. Updating local user...');
    

    user(updatedUser);

  
    await SecureStorage().writeSecureData(
      'user',
      jsonEncode(updatedUser.toJson()),  
    );

    print('User details updated locally.');
  } else {
    print('No updates in user details.');
  }
        },
      );
    }
  }

  bool isLoggedIn() {
    return token.isNotEmpty;
  }

  void togglePassword() {
    obscureText.value = !obscureText.value;
  }

  void togglePasswordSignup() {
    obscurePassword.value = !obscurePassword.value;
  }

  void togglePasswordConfirm() {
    obscureConfirm.value = !obscureConfirm.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  Future<void> login(Map<String, dynamic>? formData) async {
    
    
    isLoginLoading(true);
    Modal.loading(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 24),
          CircularProgressIndicator(),
          SizedBox(width: 36),
          Text(
            "Logging in...",
            style: Get.textTheme.titleMedium,
          ),
        ],
      ),
    );

    final response = await ApiService.postPublicResource('login', {
      'email': formData!['email'],
      'password': formData['password'],
    });

    Get.back();

    response.fold(
      (failure) {
        failure.printError();
        Modal.error(
          content: Text(failure.message ?? 'Something went wrong.'),
          visualContent: LocalLottieImage(
            path: lottiesPath('error.json'),
            repeat: false,
          ),
        );
      },
      (success) async {
        final data = success.data['data'];
        print('DATA----------------');
        print(data);
        print('DATA--------------');
        await SecureStorage().writeSecureData('token', data['access_token']);
        await SecureStorage().writeSecureData('user', jsonEncode(data['user']));
      //  await fetchUserFromStorage();
      await loadTokenAndUser();
       Get.offAllNamed('/home-main');
      },
    );

    isLoginLoading(false);
  }

 
  Future<void> register() async {
    if (signupFormKey.currentState?.saveAndValidate() ?? false) {
      final formData = signupFormKey.currentState?.value;

      isSignupLoading(true);
      Modal.loading(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 24),
            CircularProgressIndicator(),
            SizedBox(width: 36),
            Text(
              "Signing up...",
              style: Get.textTheme.titleMedium,
            ),
          ],
        ),
      );

      final response = await ApiService.postPublicResource('register', {
        'first_name': formData?['first_name'],
        'last_name': formData?['last_name'],
        'email': formData?['email'],
        'password': formData?['password'],
        'password_confirmation': formData?['password_confirmation'],
      });

      Get.back(); // Dismiss loading modal

      response.fold(
        (failure) {
          failure.printError(); 
          Modal.error(
            content: Text(failure.message ?? 'Something went wrong.'),
            visualContent: failure.icon,
          );
        },
        (success) async {
          final data = success.data['data'];
          await SecureStorage().writeSecureData('token', data['access_token']);
          await SecureStorage() .writeSecureData('user', jsonEncode(data['user']));
         await loadTokenAndUser();
          Get.offAllNamed('/home-main');
        },
      );
      isSignupLoading(false);
    }
  }
 Future<void> clearLocalData() async {
    await SecureStorage().deleteSecureData('token');
    await SecureStorage().deleteSecureData('user');
    user.value = User();  // Clear user data in-memory
    token.value = '';     // Clear token in-memory
  }

  // Logout function that returns a bool (true for success, false for failure)
  Future<bool> logout() async {
    // Show loading modal
    Modal.loading(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 24),
          CircularProgressIndicator(),
          SizedBox(width: 36),
          Text(
            "Logging out...",
            style: Get.textTheme.titleMedium,
          ),
        ],
      ),
    );

    // Call the logout API
    final response = await ApiService.postAuthenticatedResource('logout', {});

    // Close the loading modal
    Get.back();

    // Handle success or failure response
    return response.fold(
      (failure) {
        // Handle logout failure and show error modal
        failure.printError();
        Modal.error(
          content: Text(failure.message ?? 'Logout failed.'),
          visualContent: failure.icon,
        );
        return false;  // Return false indicating failure
      },
      (success) async {
        // Clear local data on successful logout
        await clearLocalData();

        // Redirect to login page after successful logout
        Get.offAllNamed('/login');
        return true;  // Return true indicating success
      },
    );
  }

  Future<void> fetchUserFromStorage() async {
    String? userJson = await SecureStorage().readSecureData('user');

    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      user(User.fromJson(userMap));

      print(user.toJson());
    } else {
      print('No user found in storage');
    }
  }

  Future<void> updateUserDetailsLocal(User updatedUser) async {
  
  user.value = user.value.copyWith(
    firstName: updatedUser.firstName ?? user.value.firstName,
    lastName: updatedUser.lastName ?? user.value.lastName,
    email: updatedUser.email ?? user.value.email,
    image: updatedUser.image ?? user.value.image,
   
  );

 
  await SecureStorage().writeSecureData(
    'user',
    jsonEncode(user.value.toJson()), 
  );

  print('User details updated locally with selected fields.');
}

}
