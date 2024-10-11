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



  final loginFormKey = GlobalKey<FormBuilderState>();
  final signupFormKey = GlobalKey<FormBuilderState>();

  var obscureText = true.obs;
  var obscurePassword = true.obs;
  var obscureConfirm = true.obs;

  var isLoginLoading = false.obs;
  var isSignupLoading = false.obs;

  var rememberMe = false.obs;

  var user = User().obs;
  var token = ''.obs;  //
  var isTokenLoaded = false.obs;  // Flag to check if the token is loaded

  Future<void> loadTokenAndUser() async {
  try {
    // Retrieve token from SecureStorage
    String? savedToken = await SecureStorage().readSecureData('token');
    
    if (savedToken != null && savedToken.isNotEmpty) {
      token.value = savedToken;

      // Retrieve user data if token exists
      String? userJson = await SecureStorage().readSecureData('user');
      
      if (userJson != null && userJson.isNotEmpty) {
        // Parse and update user data
        user(User.fromJson(jsonDecode(userJson))); 
      } else {
        print("User data is missing in SecureStorage");
      }
    } else {
      print("Token not found or empty");
    }
  } catch (e) {
    print("Error loading token and user: $e");
  } finally {
    // Ensure this flag is always set, even if errors occur
    isTokenLoaded.value = true;  // Mark token loading as complete
  }
}


  bool isLoggedIn() {
    return token.isNotEmpty;  // Simple check to see if user is logged in
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

  Future<void> login() async {
    if (loginFormKey.currentState?.saveAndValidate() ?? false) {
      final formData = loginFormKey.currentState?.value;

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
        'email': formData?['email'],
        'password': formData?['password'],
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

          final data = success.data;
          await SecureStorage().writeSecureData('token', data['access_token']);
          await SecureStorage().writeSecureData('user', data['user']);
          fetchUserFromStorage();
          Get.offAllNamed('/home-main');
        },
      );

      isLoginLoading(false);
    } else {
      Modal.error(content: Text('Please fill all fields.'));
    }
  }

  // Handle signup
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
          failure.printError(); // Use Failure's error printing
          Modal.error(
            content: Text(failure.message ?? 'Something went wrong.'),
            visualContent: failure.icon,
          );
        },
        (success) async {
          final data = success.data['data'];
          await SecureStorage().writeSecureData('token', data['access_token']);
          await SecureStorage().writeSecureData('user', jsonEncode(data['user'])); 
          fetchUserFromStorage();
          Get.offAllNamed('/home-main');
         
        },
      );
      isSignupLoading(false);
    }
  }

  // Handle logout with API call
  Future<void> logout() async {
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

    final apiService = ApiService();

    final response = await apiService.postAuthenticatedResource('logout', {});

    Get.back();

    response.fold(
      (failure) {
        failure.printError();
        Modal.error(
          content: Text(failure.message ?? 'Logout failed.'),
          visualContent: failure.icon,
        );
      },
      (success) async {
        await SecureStorage().deleteSecureData('token');
        await SecureStorage().deleteSecureData('user');

        user(User());


        Get.offAllNamed('/login');
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
}
