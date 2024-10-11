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
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
            statusCode: exception.response?.statusCode?.toInt(),
          );
        case 422:
          // Handle unauthorized access and check if token exists
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
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

}
