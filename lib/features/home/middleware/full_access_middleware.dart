import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';

class FullAccessMiddleware extends GetMiddleware {
  // Priority determines the order in which the middleware runs.
  // Lower priority middleware runs first.
  @override
  int? priority = 1;

  @override
  RouteSettings? redirect(String? route) {
  
    final AuthController authController = Get.find<AuthController>();
  
     if (authController.user.value.hasAccess() || authController.user.value.isAdmin()) {
    
      return null;
    } 
    
    return const RouteSettings(name: '/forbidden');
  
  }
}
