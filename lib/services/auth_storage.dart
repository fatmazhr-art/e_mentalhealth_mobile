import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Menyimpan token login di penyimpanan aman (Keystore di Android).
class AuthStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'token';

  static Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  static Future<String?> getToken() => _storage.read(key: _tokenKey);

  static Future<void> clear() => _storage.delete(key: _tokenKey);

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}