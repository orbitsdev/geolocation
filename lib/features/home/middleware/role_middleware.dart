import 'package:flutter/material.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/user.dart';
import 'package:get/get.dart';

class RoleMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    
 final authController = Get.find<AuthController>();
    final user = authController.user.value;



 
    if (user.hasAnyRole([Role.ADMIN])) {
      return route == '/dashboard' ? null : const RouteSettings(name: '/dashboard');
    }
    if (user.hasAccess()) {
      return route == '/dashboard' ? null : const RouteSettings(name: '/dashboard');
    }

    
    if (!user.hasAccess() && user.defaultPosition?.id != null) {
      return route == '/home-officer' ? null : const RouteSettings(name: '/home-officer');
    }

    
    return route == '/forbidden' ? null : const RouteSettings(name: '/forbidden');
  
  }
}
