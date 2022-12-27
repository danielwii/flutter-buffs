import 'dart:async';

import 'package:json_annotation/json_annotation.dart';

import 'logger.dart';

part 'context.g.dart';

@JsonSerializable()
class AppEnv {
  final String? APP_KEY;
  final String HOSTNAME;
  final String? PROTECTED_PROTOCOL;
  final String? PROTECTED_IP;
  final int? PROTECTED_PORT;

  String? get appKey => APP_KEY;
  String get hostname => HOSTNAME;
  String? get protectedProtocol => PROTECTED_PROTOCOL;
  String? get protectedIp => PROTECTED_IP;
  int? get protectedPort => PROTECTED_PORT;

  AppEnv({
    String? APP_KEY,
    required String HOSTNAME,
    String? PROTECTED_PROTOCOL,
    String? PROTECTED_IP,
    int? PROTECTED_PORT,
  })  : APP_KEY = const bool.hasEnvironment('APP_KEY')
            ? String.fromEnvironment('APP_KEY')
            : APP_KEY,
        HOSTNAME = const bool.hasEnvironment('HOSTNAME')
            ? String.fromEnvironment('HOSTNAME')
            : HOSTNAME,
        PROTECTED_PROTOCOL = const bool.hasEnvironment('PROTECTED_PROTOCOL')
            ? String.fromEnvironment('PROTECTED_PROTOCOL')
            : PROTECTED_PROTOCOL,
        PROTECTED_IP = const bool.hasEnvironment('PROTECTED_IP')
            ? String.fromEnvironment('PROTECTED_IP')
            : PROTECTED_IP,
        PROTECTED_PORT = const bool.hasEnvironment('PROTECTED_PORT')
            ? int.fromEnvironment('PROTECTED_PORT')
            : PROTECTED_PORT;

  AppEnv.loadFromEnv()
      : APP_KEY = String.fromEnvironment('APP_KEY'),
        HOSTNAME = String.fromEnvironment('HOSTNAME'),
        PROTECTED_PROTOCOL = String.fromEnvironment('PROTECTED_PROTOCOL'),
        PROTECTED_IP = String.fromEnvironment('PROTECTED_IP'),
        PROTECTED_PORT = int.fromEnvironment('PROTECTED_PORT');

  factory AppEnv.fromJson(Map<String, dynamic> json) => _$AppEnvFromJson(json);

  Map<String, dynamic> toJson() => _$AppEnvToJson(this);
}

abstract class AbstractServerConnection {
  String resolveUrl(String path,
      {String? ip, String? protectedIp, String? protocol, int? port});
  String? getResolvedIp();
  String resolveAssets(String url);
}

typedef InitAfterSplash = Future Function();

class AppContext {
  static bool isPad = false;
  static late AppEnv env;
  static late AbstractServerConnection connection;
  static late InitAfterSplash initAfterSplash;

  static Future<void> init({
    required AppEnv env,
    required AbstractServerConnection connection,
    required Function preConfigure,
    required InitAfterSplash afterSplash,
  }) async {
    AppContext.env = env;
    AppContext.connection = connection;
    initAfterSplash = () {
      logger.info('init after splash...');
      return afterSplash();
    };
    await preConfigure();
  }
}
