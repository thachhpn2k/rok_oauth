import 'package:oauth2/oauth2.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rok_oauth/src/oauth2/credentials_storages/r_oauth2_storage.dart';

class ROauth2CredentialsStorageImpl implements ROauth2CredentialsStorage {
  final FlutterSecureStorage _storage;
  final String _key;

  ROauth2CredentialsStorageImpl(
    this._storage,
    this._key,
  );

  @override
  Future<Credentials?> getCredentials() async {
    final json = await _storage.read(key: _key);
    return json != null ? Credentials.fromJson(json) : null;
  }

  @override
  Future<void> setCredentials(Credentials credentials) async => _storage.write(key: _key, value: credentials.toJson());

  @override
  Future<bool> hasCredentials() async => _storage.containsKey(key: _key);

  @override
  Future<void> removeCredentials() async => _storage.delete(key: _key);
}
