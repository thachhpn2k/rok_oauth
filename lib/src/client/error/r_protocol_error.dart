import 'dart:io';
import 'package:dio/dio.dart';
import 'package:rok_oauth/src/client/type_def/r_error_message_parser.dart';

class RProtocolError extends DioException {
  final RErrorMessageParser? _errorMessageParser;

  RProtocolError({
    required DioException dioException,
    RErrorMessageParser? errorMessageParser,
  })  : _errorMessageParser = errorMessageParser,
        super(
          requestOptions: dioException.requestOptions,
          response: dioException.response,
          type: dioException.type,
          error: dioException.error,
        );

  @override
  String? get message {
    if (error is SocketException) {
      return 'Cannot connect to server. Please check network and try again!';
    }

    final parsedMessage = _errorMessageParser?.call(protocolError: this);
    if (parsedMessage != null) {
      return parsedMessage;
    }

    return super.message;
  }

  @override
  String toString() {
    return message ?? 'Empty message';
  }
}
