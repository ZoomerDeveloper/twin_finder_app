// lib/core/auth/token_store.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStore {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';
  final _storage = const FlutterSecureStorage();

  Future<void> save({required String? access, required String? refresh}) async {
    await _storage.write(key: _kAccess, value: access);
    await _storage.write(key: _kRefresh, value: refresh);
  }

  Future<String?> get access async => _storage.read(key: _kAccess);
  Future<String?> get refresh async => _storage.read(key: _kRefresh);

  Future<void> clear() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }
}
