import 'package:flutter/material.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/localdata/secure_storage.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    
    return null;
  }
}