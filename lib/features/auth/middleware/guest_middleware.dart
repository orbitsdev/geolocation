import 'package:flutter/material.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/localdata/secure_storage.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';

class GuestMiddleware extends GetMiddleware {
   @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find<AuthController>();
    print('GUEST MIDDLWARE-------------');
    print('${authController.token.value}');
    print('${authController.token.value.isNotEmpty}');

    // Check if the token is not empty, meaning the user is already logged in
    if (authController.token.value.isNotEmpty) {
      // Redirect authenticated users to the home page
      return RouteSettings(name: '/home-main');
    }
      // If the token is empty, allow access to guest routes
    print('GUEST MIDDLWARE----------------');
    
      return null;
  }

  // @override
  // GetPage? onPageCalled(GetPage? page) {
  //   // TODO: implement onPageCalled
  //   final AuthController authController = Get.find<AuthController>();
  //   print('page called');
  //   print(authController.token.value);
  //   return super.onPageCalled(page);
  // }

  // @override
  // GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
  //   // TODO: implement onPageBuildStart
  //   final AuthController authController = Get.find<AuthController>();
  //   print('page start');
  //   print(authController.token.value);
  //   return super.onPageBuildStart(page);
  // }

  // @override
  // Widget onPageBuilt(Widget page) {
  //   final AuthController authController = Get.find<AuthController>();
  //   print('page built');
  //   print(authController.token.value);
  //   return super.onPageBuilt(page);
  // }
}
