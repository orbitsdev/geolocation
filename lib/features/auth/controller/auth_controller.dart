import 'package:flutter/material.dart';
import 'package:geolocation/core/api/dio/api_service.dart';
import 'package:geolocation/core/constant/path.dart';
import 'package:geolocation/core/globalwidget/images/local_lottie_image.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/localdata/secure_storage.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AuthController extends GetxController {
  // Separate form keys for login and signup
  final loginFormKey = GlobalKey<FormBuilderState>();
  final signupFormKey = GlobalKey<FormBuilderState>();

  var obscurePassword = true.obs;
  var obscureConfirm = true.obs;
  var isLoading = false.obs;

  // Toggle password visibility
  void togglePassword() => obscurePassword.value = !obscurePassword.value;

  // Toggle confirm password visibility
  void togglePasswordConfirm() => obscureConfirm.value = !obscureConfirm.value;

  // Login Function
  Future<void> login() async {
    if (!loginFormKey.currentState!.saveAndValidate()) return;

    isLoading.value = true;

    final formData = loginFormKey.currentState!.value;
    final loginData = {
      'email': formData['email'],
      'password': formData['password'],
    };

    final response = await ApiService.postPublicResource('/login', loginData);

    response.fold(
      (failure) {
        isLoading.value = false;
        Modal.error(
          content: Text('${failure.message}'),
          visualContent: LocalLottieImage(path: lottiesPath('error.json')),
        );
      },
      (success) {
        isLoading.value = false;
        final data = success.data;
        SecureStorage().writeSecureData('token', data['access_token']);
        // Navigate to home after login
        Get.offAllNamed('/home');
      },
    );
  }

  // Register Function
  Future<void> register() async {
    if (!signupFormKey.currentState!.saveAndValidate()) return;

    isLoading.value = true;

    final formData = signupFormKey.currentState!.value;
    final registerData = {
      'first_name': formData['first_name'],
      'last_name': formData['first_name'],
      'email': formData['email'],
      'password': formData['password'],
      'password_confirmation': formData['password_confirmation'],
    };

    print(formData);

    final response = await ApiService.postPublicResource('/register', registerData);

    response.fold(
      (failure) {
        isLoading.value = false;
        Modal.error(
          content: Text('${failure.message}'),
                    visualContent: LocalLottieImage(path: lottiesPath('error.json')),
        );
      },
      (success) {
        isLoading.value = false;
        final data = success.data;
        SecureStorage().writeSecureData('token', data['access_token']);
        Get.offAllNamed('/home');
      },
    );
  }
}
