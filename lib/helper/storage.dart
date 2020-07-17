import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import 'logger.dart';

class SecurityStorage {
  final _storage = new FlutterSecureStorage();

  static final instance = SecurityStorage._();

  SecurityStorage._();

  Future<void> set({@required String key, @required String value}) async {
    assert(key != null, "key must not be null");
    logger.finest('set {key: $key, value: $value}');
    return _storage.write(key: key, value: value);
  }

  Future<String> get({@required String key}) async {
    assert(key != null, "key must not be null");
    final value = await _storage.read(key: key);
//    logger.finer('get {key: $key} $value');
    return value;
  }

  Future<void> delete({@required String key}) {
    assert(key != null, "key must not be null");
    logger.finest('delete {key: $key}');
    return _storage.delete(key: key);
  }

  Future<void> clear() {
    logger.finest('deleteAll');
    return _storage.deleteAll();
  }
}
