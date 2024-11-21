import 'package:rok_oauth/src/client/error/r_protocal_error.dart';

typedef RErrorMessageParser = String? Function({
  required RProtocolError protocolError,
});
