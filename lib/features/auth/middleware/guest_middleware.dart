// features/auth/middleware/auth_middleware.dart
import 'package:flutter/material.dart';
import 'package:geolocation/core/localdata/secure_storage.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';

class GuestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
     final token = SecureStorage().readSecureData('token');
    
    // If the token doesn't exist, redirect to the login page
    if (token != null) {
    return const RouteSettings(name: '/home-main');
    }

    // // If the user is logged in but hasn't completed onboarding, redirect to onboarding
    // bool isOnboardingComplete = false; // Example flag, adjust logic as needed
    // if (!isOnboardingComplete) {
    //   return const RouteSettings(name: '/onboarding');
    // }

    // If everything is fine, allow access to the requested route
    return null;
  
  }
}