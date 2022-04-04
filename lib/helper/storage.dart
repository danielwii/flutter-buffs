import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'logger.dart';

class SecurityStorage {
  final _storage = FlutterSecureStorage();

  static final instance = SecurityStorage._();

  SecurityStorage._();

  Future<void> set({required String key, required String value}) async {
    logger.finest('set {key: $key, value: $value}');
    return _storage.write(key: key, value: value);
  }

  Future<String?> get({required String key}) async {
    final value = await _storage.read(key: key);
//    logger.finer('get {key: $key} $value');
    return value;
  }

  Future<void> delete({required String key}) {
    logger.finest('delete {key: $key}');
    return _storage.delete(key: key);
  }

  Future<void> clear() {
    logger.finest('deleteAll');
    return _storage.deleteAll();
  }
}
