import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geolocation/core/api/dio/failure.dart';
import 'package:geolocation/core/error/error_handler.dart';
import 'package:geolocation/core/api/dio/typedef.dart';
import 'package:geolocation/core/localdata/secure_storage.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as D;
// EitherModel typedef for response type
typedef EitherModel<T> = Either<Failure, T>;

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://geolocation.me/api/',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  )
  )
   ..interceptors.add(_getInterceptor());  // Add the interceptor to Dio

  // Retrieve the token from SecureStorage for authenticated requests
  static Future<Map<String, dynamic>> _getAuthHeaders({Map<String, dynamic>? additionalHeaders}) async {
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
  static Future<EitherModel<D.Response>> getPublicResource(String endpoint) async {
    try {
      D.Response response = await _dio.get(endpoint);
      return right(response); // On success, return the response
    } on DioException catch (e) {
      return left(ErrorHandler.handleDio(e)); // On error, return Failure
    }
  }

  // POST request for public resources
  static Future<EitherModel<D.Response>> postPublicResource(String endpoint, dynamic data) async {
    try {
      D.Response response = await _dio.post(endpoint, data: data);
      return right(response);
    } on DioException catch (e) {
      return left(ErrorHandler.handleDio(e));
    }
  }

  // GET request for authenticated resources
  static Future<EitherModel<D.Response>> getAuthenticatedResource(
    String endpoint, {
    Map<String, dynamic>? additionalHeaders,
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final options = Options(headers: await _getAuthHeaders(additionalHeaders: additionalHeaders));
      D.Response response = await _dio.get(endpoint, options: options, queryParameters: queryParameters, data: data);
      return right(response);
    } on DioException catch (e) {
      return left(ErrorHandler.handleDio(e));
    }
  }

  // POST request for authenticated resources
  static Future<EitherModel<D.Response>> postAuthenticatedResource(
    String endpoint, dynamic data, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: await _getAuthHeaders(additionalHeaders: headers));
      D.Response response = await _dio.post(endpoint, data: data, options: options);
      return right(response);
    } on DioException catch (e) {
      return left(ErrorHandler.handleDio(e));
    }
  }

  // PUT request for authenticated resources
  static Future<EitherModel<D.Response>> putAuthenticatedResource(
    String endpoint, dynamic data, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: await _getAuthHeaders(additionalHeaders: headers));
      D.Response response = await _dio.put(endpoint, data: data, options: options);
      return right(response);
    } on DioException catch (e) {
      return left(ErrorHandler.handleDio(e));
    }
  }

  // PATCH request for authenticated resources
  static Future<EitherModel<D.Response>> patchAuthenticatedResource(
    String endpoint, dynamic data, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: await _getAuthHeaders(additionalHeaders: headers));
      D.Response response = await _dio.patch(endpoint, data: data, options: options);
      return right(response);
    } on DioException catch (e) {
      return left(ErrorHandler.handleDio(e));
    }
  }

  // DELETE request for authenticated resources
  static Future<EitherModel<D.Response>> deleteAuthenticatedResource(
    String endpoint, {
    Map<String, dynamic>? headers,
  }) async {
    try {
      final options = Options(headers: await _getAuthHeaders(additionalHeaders: headers));
      D.Response response = await _dio.delete(endpoint, options: options);
      return right(response);
    } on DioException catch (e) {
      return left(ErrorHandler.handleDio(e));
    }
  }

  // Global interceptor for handling 401 Unauthorized errors
  static Interceptor _getInterceptor() {
    return InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) async {

        if (e.response?.statusCode == 401) {

           String? savedToken = await SecureStorage().readSecureData('token');
          // Token expired or session unauthorized
        
         
          Failure failure = Failure(exception: e);
          if(savedToken != null){
           print('! =  bnull');
           print(savedToken);
          AuthController.controller.localLogout(failure:failure ); // Call the logout function

          }else{
            print('null');
          }
        }
        return handler.next(e); // Continue with error handling
      },
    );
  }
}
