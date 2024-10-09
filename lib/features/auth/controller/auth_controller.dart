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
import 'package:geolocation/core/api/dio/failure.dart';  // Import your Failure model

class AuthController extends GetxController {
  // Form keys for login and signup
  final loginFormKey = GlobalKey<FormBuilderState>();
  final signupFormKey = GlobalKey<FormBuilderState>();

  // Observable for password toggle in login and signup
  var obscureText = true.obs;  // For login page password
  var obscurePassword = true.obs;  // For signup page password
  var obscureConfirm = true.obs;  // For signup page confirm password

  // Loading states for login and signup
  var isLoginLoading = false.obs;
  var isSignupLoading = false.obs;

  // Remember me state
  var rememberMe = false.obs;

  // Observable for storing user details
  var user = User().obs;

  // Toggle password visibility for login
  void togglePassword() {
    obscureText.value = !obscureText.value;
  }

  // Toggle password visibility for signup
  void togglePasswordSignup() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Toggle confirm password visibility for signup
  void togglePasswordConfirm() {
    obscureConfirm.value = !obscureConfirm.value;
  }

  // Toggle Remember Me checkbox
  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  // Handle login
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

      Get.back();  // Dismiss loading modal

      response.fold(
        (failure) {
          failure.printError();  // Use Failure's error printing
          Modal.error(
            content: Text(failure.message ?? 'Something went wrong.'),
            visualContent: LocalLottieImage(path: lottiesPath('error.json'), repeat: false,),
          );
        },
        (success) async {
          final data = success.data;

          // Store token and user details
          await SecureStorage().writeSecureData('token', data['access_token']);
          await SecureStorage().writeSecureData('user', data['user']);

          // Update the user observable
          user(User.fromJson(data['user']));

          // Navigate to home after login success
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

      Get.back();  // Dismiss loading modal

      response.fold(
        (failure) {
          failure.printError();  // Use Failure's error printing
          Modal.error(
            content: Text(failure.message ?? 'Something went wrong.'),
            visualContent: failure.icon,
          );
        },
        (success) async {
          final data = success.data;

          // Store token and user details
          await SecureStorage().writeSecureData('token', data['access_token']);
          await SecureStorage().writeSecureData('user', data['user']);

          // Update the user observable
          user(User.fromJson(data['user']));

          // Navigate to home after signup success
          Get.offAllNamed('/home-main');
        },
      );
      isSignupLoading(false);
    } else {
      Modal.error(content: Text('Please fill all fields.'));
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

  // Create an instance of ApiService
  final apiService = ApiService();
  
  // Call the logout API
  final response = await apiService.postAuthenticatedResource('logout', {});

  Get.back();  // Dismiss loading modal

  response.fold(
    (failure) {
      failure.printError();
      Modal.error(
        content: Text(failure.message ?? 'Logout failed.'),
        visualContent: failure.icon,
      );
    },
    (success) async {
      // Clear token and user details
      await SecureStorage().deleteSecureData('token');
      await SecureStorage().deleteSecureData('user');

      // Clear the user observable
      user(User());

      // Navigate to login page
      Get.offAllNamed('/login');
    },
  );
}

}
