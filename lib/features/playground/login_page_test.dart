// features/auth/pages/login_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';

class LoginPageTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authController.login();  // Simulate login
            Get.offNamed('/page2');  // Navigate to Page2 (protected)
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}
