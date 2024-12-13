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


    if (authController.token.value.isNotEmpty) {
      
      return RouteSettings(name: '/officers-task-main');
   
    }
    
      return null;
  }

}
