import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:rok_oauth/src/client/error/r_protocal_error.dart';
import 'package:rok_oauth/src/client/type_def/r_unauthorized_reponse_handler.dart';
import 'package:rok_oauth/src/oauth2/manager/r_oauth2_manager.dart';

class RClientWrapper {
  final Dio dio = Dio();
  final Logger? _logger;
  final RUnauthorizedResponseHandler? _unauthorizedResponseHandler;
  final ROauth2Manager? _oauth2Manager;

  RClientWrapper({
    required BaseOptions options,
    Logger? logger,
    bool verbose = false,
    RUnauthorizedResponseHandler? unauthorizedResponseHandler,
    ROauth2Manager? oauth2Manager,
    List<Interceptor>? extraInterceptors,
  })  : _logger = logger,
        _unauthorizedResponseHandler = unauthorizedResponseHandler,
        _oauth2Manager = oauth2Manager {
    dio.options = options;
    dio.interceptors.add(InterceptorsWrapper(onRequest: onRequest, onError: onError));

    if (_logger != null) {
      if (verbose) {
        dio.interceptors.add(LogInterceptor(logPrint: _logger.t, requestBody: true, responseBody: true));
      } else {
        dio.interceptors.add(LogInterceptor(logPrint: _logger.d));
      }
    }

    if (extraInterceptors != null) {
      dio.interceptors.addAll(extraInterceptors);
    }
  }

  Future<bool> onRequest(RequestOptions option, RequestInterceptorHandler handler) async {
    option.headers['Accept'] = 'application/json';
    final accessToken = await _oauth2Manager?.getAccessToken();
    if (accessToken != null) {
      option.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(option);

    return true;
  }

  void onError(DioException e, ErrorInterceptorHandler handler) {
    final protocolError = RProtocolError(dioException: e);

    if (protocolError.response?.statusCode == HttpStatus.unauthorized) {
      _logger?.w('Http Unauthorized Response');
      _unauthorizedResponseHandler?.call(protocolError: protocolError);
    }

    handler.next(protocolError);
  }
}
