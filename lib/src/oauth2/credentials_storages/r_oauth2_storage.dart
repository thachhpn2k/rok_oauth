import 'package:oauth2/oauth2.dart';

abstract class ROauth2CredentialsStorage {
  Future<Credentials?> getCredentials();

  Future<void> setCredentials(Credentials credentials);

  Future<bool> hasCredentials();

  Future<void> removeCredentials();
}
