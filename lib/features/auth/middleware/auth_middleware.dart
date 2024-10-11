import 'package:flutter/material.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/localdata/secure_storage.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    
    final AuthController authController = Get.find<AuthController>();

    // Check if the token is not empty
    if (authController.token.value.isNotEmpty) {
      return null; // Let the user proceed
    } else {
      // If the token is empty, redirect to the login page
      return RouteSettings(name: '/login');
    }
  }
}