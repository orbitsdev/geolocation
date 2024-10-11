import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocation/core/api/dio/failure.dart';
import 'package:geolocation/core/localdata/secure_storage.dart';
import 'package:geolocation/features/auth/model/user.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/modal/modal.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';

class ErrorHandler {
  static Failure handleError(DioException exception) {
    if (exception.response != null) {
      switch (exception.response?.statusCode) {
        case 400:
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
            statusCode: exception.response?.statusCode?.toInt(),
          );

        case 401:
          // Handle unauthorized access and check if token exists
          final AuthController authController = Get.find<AuthController>();
          if (authController.token.value.isNotEmpty) {
            // If token exists, call logout and clear data
            _handleLogout();
          }
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: "Unauthorized. Logging out...",
            statusCode: exception.response?.statusCode?.toInt(),
          );

        case 403:
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
            statusCode: exception.response?.statusCode?.toInt(),
          );

        case 404:
          return Failure(
            exception: exception,
            message: exception.response!.data['message'],
            icon: FaIcon(
              FontAwesomeIcons.exclamationCircle,
              size: 40,
            ),
            statusCode: exception.response?.statusCode?.toInt(),
          );

        case 500:
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
            statusCode: exception.response?.statusCode?.toInt(),
          );

        default:
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
            statusCode: exception.response?.statusCode?.toInt(),
          );
      }
    } else {
      return Failure(
        exception: exception,
        message: exception.message,
        icon: FaIcon(
          FontAwesomeIcons.triangleExclamation,
          size: 40,
        ),
      );
    }
  }

  // Handle logout when 401 error occurs
  static Future<void> _handleLogout() async {
    final AuthController authController = Get.find<AuthController>();
    
    // Show loading modal
    Modal.loading(
      content: Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 12),
          Text("Logging out..."),
        ],
      ),
    );
    
    try {
      // Call logout API
      final response = await authController.logout();
      
      if (response) {
        // If logout API call succeeds, clear local storage
        await SecureStorage().deleteSecureData('token');
        await SecureStorage().deleteSecureData('user');

        // Clear user observable
        authController.user.value = User();
        authController.token.value = '';

        // Redirect to login page
        Get.offAllNamed('/login');
      }
    } catch (error) {
      // Handle logout API failure
      print('Error during logout: $error');
    } finally {
      // Dismiss loading modal
      Get.back();
    }
  }
}
