import 'dart:async';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:sglab_desk/common/store/store.dart';
import 'package:sglab_desk/common/utils/utils.dart';
import 'package:sglab_desk/common/values/values.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  late Dio dio;
  CancelToken cancelToken = CancelToken();

  HttpUtil._internal() {
    // BaseOptions, Options, and RequestOptions can all be used to configure parameters.
    // The priority increases in the order of BaseOptions < Options < RequestOptions,
    // and parameters can be overridden based on their priority.

    BaseOptions options = BaseOptions(
      // Base URL for requests, which can include subpaths.
      baseUrl: SERVER_API_URL,

      // baseUrl: storage.read(key: STORAGE_KEY_APIURL) ?? SERVICE_API_BASEURL,

      // Connection timeout duration when connecting to the server, in milliseconds.
      connectTimeout: const Duration(seconds: 30),

      // The interval between two consecutive data receptions on the response stream, in milliseconds.
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),

      // HTTP request headers.
      headers: {},

      /// The Content-Type of the request. The default value is "application/json; charset=utf-8".
      /// If you want to encode request data in the "application/x-www-form-urlencoded" format,
      /// you can set this option to `Headers.formUrlEncodedContentType`.
      /// This way, [Dio] will automatically encode the request body.

      contentType: 'application/json; charset=utf-8',

      /// [responseType] specifies the expected format (method) for receiving response data.
      /// Currently, [ResponseType] supports three types: `JSON`, `STREAM`, and `PLAIN`.
      ///
      /// The default value is `JSON`. When the response header's content-type is "application/json",
      /// Dio will automatically convert the response content into a JSON object.
      /// If you want to receive response data in binary format, such as downloading a binary file,
      /// you can use `STREAM`.
      ///
      /// If you want to receive response data in text (string) format, use `PLAIN`.

      responseType: ResponseType.json,
    );

    dio = Dio(options);

    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };

    dio.httpClientAdapter = IOHttpClientAdapter(createHttpClient: () {
      final client = HttpClient();
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    });

    //  Cookie management
    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    // Add interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Do something before request is sent
        return handler.next(options); //continue
        // If you want to complete the request and return some custom data,
        // you can resolve a `Response` object using `handler.resolve(response)`.
        // This will terminate the request, and the upper-level `then` will be called,
        // with the returned data being your custom response.
        //
        // If you want to terminate the request and trigger an error,
        // you can return a `DioError` object using `handler.reject(error)`.
        // This will abort the request and trigger an exception,
        // causing the upper-level `catchError` to be called.
      },
      onResponse: (response, handler) {
        // Do something with response data
        return handler.next(response); // continue
        // If you want to terminate the request and trigger an error,
        // you can reject a `DioError` object, such as `handler.reject(error)`.
        // This will abort the request and trigger an exception,
        // causing the upper-level `catchError` to be called.
      },
      onError: (DioException e, handler) {
        // Do something with response error
        Loading.dismiss();
        ErrorEntity eInfo = createErrorEntity(e);
        onError(eInfo);
        return handler.next(e); //continue
        // If you want to complete the request and return some custom data,
        // you can resolve a `Response`, such as `handler.resolve(response)`.
        // This will terminate the request, and the upper-level `then` will be called,
        // where the returned data will be your
      },
    ));
  }

  /*
   * /// Unified error handling

   */

  // Error handling
  void onError(ErrorEntity eInfo) {
    if (kDebugMode) {
      print('error.code -> ${eInfo.code}, error.message -> ${eInfo.message}');
    }
    switch (eInfo.code) {
      case 401:
        UserStore.to.onLogout();
        EasyLoading.showError(eInfo.message);
        break;
      default:
        EasyLoading.showError(eInfo.message);
        break;
    }
  }

  // Error message
  ErrorEntity createErrorEntity(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return ErrorEntity(code: -1, message: "Request canceled");
      case DioExceptionType.connectionTimeout:
        return ErrorEntity(code: -1, message: "Connection timed out");
      case DioExceptionType.sendTimeout:
        return ErrorEntity(code: -1, message: "Request timed out");
      case DioExceptionType.receiveTimeout:
        return ErrorEntity(code: -1, message: "Response timed out");
      case DioExceptionType.badResponse:
        {
          try {
            int errCode =
                error.response != null ? error.response!.statusCode! : -1;
            // String errMsg = error.response.statusMessage;
            // return ErrorEntity(code: errCode, message: errMsg);
            switch (errCode) {
              case 400:
                return ErrorEntity(
                    code: errCode, message: "Request syntax error");
              case 401:
                return ErrorEntity(code: errCode, message: "Permission denied");
              case 403:
                return ErrorEntity(
                    code: errCode, message: "The server refused to execute");
              case 404:
                return ErrorEntity(
                    code: errCode, message: "Unable to connect to the server");
              case 405:
                return ErrorEntity(
                    code: errCode, message: "Request method is forbidden");
              case 500:
                return ErrorEntity(
                    code: errCode, message: "Internal server error");
              case 502:
                return ErrorEntity(code: errCode, message: "Invalid request");
              case 503:
                return ErrorEntity(
                    code: errCode, message: "The server is down");
              case 505:
                return ErrorEntity(
                    code: errCode,
                    message: "HTTP protocol request is not supported");
              default:
                {
                  // return ErrorEntity(code: errCode, message: "Unknown error");
                  return ErrorEntity(
                    code: errCode,
                    message: error.response != null
                        ? error.response!.statusMessage!
                        : "",
                  );
                }
            }
          } on Exception catch (_) {
            return ErrorEntity(code: -1, message: "Unknown error");
          }
        }
      default:
        {
          return ErrorEntity(code: -1, message: error.message!);
        }
    }
  }

  /*
   * Cancel request
   *
   * The same cancel token can be used for multiple requests. When a cancel token is canceled, all requests using that cancel token will be canceled.
   * So the parameter is optional.
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  /// Read local configuration
  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
      headers['Authorization'] = 'Bearer ${UserStore.to.token}';
      if (kDebugMode) {
        print(UserStore.to.token);
      }
    }
    return headers;
  }

  /// RESTful GET operation
  /// refresh - whether to perform a pull-down refresh (default: false)
  /// noCache - whether to disable caching (default: true)
  /// list - whether it is a list request (default: false)
  /// cacheKey - the key for caching
  /// cacheDisk - whether to cache on disk
  Future get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    bool noCache = !CACHE_ENABLE,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.extra ??= Map();
    requestOptions.extra!.addAll({
      "refresh": refresh,
      "noCache": noCache,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// RESTful POST operation
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(path,
        data: data,
        queryParameters: queryParameters,
        options: requestOptions,
        cancelToken: cancelToken);

    return response.data;
  }

  /// RESTful PUT operation
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful patch operation
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful delete operation
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post form operation
  Future postForm(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(
      path,
      data: FormData.fromMap(data),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post Stream operation
  Future postStream(
    String path, {
    dynamic data,
    int dataLength = 0,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    requestOptions.headers!.addAll({
      Headers.contentLengthHeader: dataLength.toString(),
    });
    var response = await dio.post(
      path,
      data: Stream.fromIterable(data.map((e) => [e])),
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }
}

/// Exception handling
class ErrorEntity implements Exception {
  int code = -1;
  String message = "";
  ErrorEntity({required this.code, required this.message});

  @override
  String toString() {
    if (message == "") return "Exception";
    return "Exception: code $code, $message";
  }
}
