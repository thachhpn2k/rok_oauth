import 'package:rok_oauth/src/client/error/r_protocol_error.dart';

typedef RUnauthorizedResponseHandler = void Function({
  required RProtocolError protocolError,
});
