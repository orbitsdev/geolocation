import 'package:flutter/material.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/localdata/secure_storage.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';

class GuestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Access AuthController

      final AuthController authController = Get.find<AuthController>();
      print('reidr');
      print(authController.token.value);
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
