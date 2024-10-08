import 'package:dio/dio.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocation/core/api/dio/failure.dart';

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

        case 413:
          return Failure(
            exception: exception,
            icon: FaIcon(
              FontAwesomeIcons.triangleExclamation,
              size: 40,
            ),
            message: exception.response!.data['message'],
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
