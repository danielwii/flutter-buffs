import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'helper.dart';

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
  })  : APP_KEY = bool.hasEnvironment('APP_KEY')
            ? String.fromEnvironment('APP_KEY')
            : APP_KEY,
        HOSTNAME = bool.hasEnvironment('HOSTNAME')
            ? String.fromEnvironment('HOSTNAME')
            : HOSTNAME,
        PROTECTED_PROTOCOL = bool.hasEnvironment('PROTECTED_PROTOCOL')
            ? String.fromEnvironment('PROTECTED_PROTOCOL')
            : PROTECTED_PROTOCOL,
        PROTECTED_IP = bool.hasEnvironment('PROTECTED_IP')
            ? String.fromEnvironment('PROTECTED_IP')
            : PROTECTED_IP,
        PROTECTED_PORT = bool.hasEnvironment('PROTECTED_PORT')
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
      {String ip, String protectedIp, String protocol, int port});
  String? getResolvedIp();
  String resolveAssets(String url);
}

class AppContext {
  static late AppEnv env;
  static late AbstractServerConnection connection;
  static List<VoidCallback> registers = [];

  static void addRegister(VoidCallback register) {
    registers.add(register);
  }

  static Future<void> init(
      {required AppEnv env,
      required AbstractServerConnection connection}) async {
    AppContext.env = env;
    AppContext.connection = connection;
//    final graphqlUrl = connection.resolveUrl('/graphql');
    logger.info('init with registers: $registers ...');

//    await GraphQL.instance.init(graphqlUrl);
    registers.forEach((register) => register());
  }
}
