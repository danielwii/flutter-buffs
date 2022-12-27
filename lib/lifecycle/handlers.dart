import 'dart:async';

import 'package:flutter/cupertino.dart';

typedef UserParser<U> = U Function(Map<String, dynamic> json);

class AuthHandler<U> {
  static final ins = AuthHandler._();

  AuthHandler._();

  late UserParser userParser;
  late FutureOr<void> Function(String username, String method) onSignUp;
  late FutureOr<void> Function(bool redirect, String? userId) onLogout;
  late FutureOr<dynamic> Function(U user, String method) onLogin;

  static void reg<U>({
    required UserParser<U> userParser,
    required FutureOr<void> Function(String username, String method) onSignUp,
    required FutureOr<void> Function(bool redirect, String? uid) onLogout,
    required FutureOr<dynamic> Function(dynamic user, String method) onLogin,
  }) async {
    ins.userParser = userParser;
    ins.onSignUp = onSignUp;
    ins.onLogout = onLogout;
    ins.onLogin = onLogin;
  }
}
