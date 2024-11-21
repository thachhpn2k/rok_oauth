import 'package:rok_oauth/src/client/error/r_protocol_error.dart';

typedef RErrorMessageParser = String? Function({
  required RProtocolError protocolError,
});
