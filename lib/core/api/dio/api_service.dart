import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocation/core/api/dio/failure.dart';
import 'package:geolocation/core/error/error_handler.dart';
import 'package:geolocation/core/api/dio/typedef.dart';
import 'package:geolocation/core/localdata/secure_storage.dart';

// EitherModel typedef for response type
typedef EitherModel<T> = Either<Failure, T>;

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://geolocation.me/',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Retrieve the token from SecureStorage for authenticated requests
  Future<Map<String, dynamic>> _getAuthHeaders({Map<String, dynamic>? additionalHeaders}) async {
    String? token = await SecureStorage().readSecureData('token');
    Map<String, dynamic> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }

  // GET request for public resources
  static Future<EitherModel<Response>> getPublicResource(String endpoint) async {
    try {
      Response response = await _dio.get(endpoint);
      return right(response);  // On success, return the response
    } on DioException catch (e) {
      return left(ErrorHandler.handleError(e));  // On error, return Failure
    }
  }

  // POST request for public resources
  static Future<EitherModel<Response>> postPublicResource(String endpoint, dynamic data) async {
    try {
      Response response = await _dio.post(endpoint, data: data);
      return right(response);
    } on DioException catch (e) {
      return left(ErrorHandler.handleError(e));
    }
  }

  // GET request for authenticated resources
  Future<EitherModel<Response>> getAuthenticatedResource(String endpoint,
    {Map<String, dynamic>? additionalHeaders, Object? data, Map<String, dynamic>? queryParameters}) async {
  try {
    final options = Options(headers: await _getAuthHeaders(additionalHeaders: additionalHeaders));
    Response response = await _dio.get(endpoint, options: options, queryParameters: queryParameters, data: data);
    return right(response);
  } on DioException catch (e) {
    return left(ErrorHandler.handleError(e));
  }
}

  // POST request for authenticated resources
  Future<EitherModel<Response>> postAuthenticatedResource(String endpoint, dynamic data,
      {Map<String, dynamic>? headers}) async {
    try {
      final options = Options(headers: await _getAuthHeaders(additionalHeaders: headers));
      Response response = await _dio.post(endpoint, data: data, options: options);
      return right(response);
    } on DioException catch (e) {
      return left(ErrorHandler.handleError(e));
    }
  }
}
