// features/auth/middleware/auth_middleware.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';

class Page2Middleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // final AuthController authController = Get.find<AuthController>();

    // // Log for debugging
    // print('AuthMiddleware is running for route: $route');
    // print('User Authenticated: ${authController.isNew.value}');

    // // Check if the user is authenticated
    // if (!authController.isNew.value) {
    //   // Log the redirection to login
    //   print('User not authenticated. Redirecting to login...');
    //   return const RouteSettings(name: '/page3');
    // }

    // // Otherwise, allow access to the route
    // print('User authenticated. Access allowed to $route.');
    return null;
  }
}