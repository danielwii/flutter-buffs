import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import 'helper.dart';

part 'context.g.dart';

@JsonSerializable(nullable: true)
class AppEnv {
  final String APP_KEY;
  final String HOSTNAME;
  final String PROTECTED_PROTOCOL;
  final String PROTECTED_IP;
  final int PROTECTED_PORT;

  String get appKey => APP_KEY;
  String get hostname => HOSTNAME;
  String get protectedProtocol => PROTECTED_PROTOCOL;
  String get protectedIp => PROTECTED_IP;
  int get protectedPort => PROTECTED_PORT;

  AppEnv(this.APP_KEY, this.HOSTNAME, this.PROTECTED_PROTOCOL, this.PROTECTED_IP, this.PROTECTED_PORT);

  factory AppEnv.fromJson(Map<String, dynamic> json) => _$AppEnvFromJson(json);

  Map<String, dynamic> toJson() => _$AppEnvToJson(this);
}

abstract class AbstractServerConnection {
  String resolveUrl(String path, {String ip, String protectedIp, String protocol, int port});
  String getResolvedIp();
  String resolveAssets(String url);
}

class AppContext {
  static AppEnv env;
  static AbstractServerConnection connection;
  static List<VoidCallback> registers = [];

  static void addRegister(VoidCallback register) {
    registers.add(register);
  }

  static Future<void> init({AppEnv env, AbstractServerConnection connection}) async {
    AppContext.env = env;
    AppContext.connection = connection;
//    final graphqlUrl = connection.resolveUrl('/graphql');
    logger.info('init with $registers ...');

//    await GraphQL.instance.init(graphqlUrl);
    registers.forEach((register) => register());
  }
}
