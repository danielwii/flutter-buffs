import 'package:dio/dio.dart';

import 'helper.dart';

abstract class AppConfigure {
  String get appKey;
  String get hostname;
  String get protectedProtocol;
  String get protectedIp;
  int get protectedPort;
}

abstract class AbstractServerConnection {
  String resolveUrl(String path, {String ip, String protectedIp, String protocol, int port});
  String getResolvedIp();
  String resolveAssets(String url);
}

class AppContext {
  static AppConfigure configure;
  static AbstractServerConnection connection;
  static List<VoidCallback> registers = [];

  static void addRegister(VoidCallback register) {
    registers.add(register);
  }

  static void init({AppConfigure configure, AbstractServerConnection connection}) async {
    AppContext.configure = configure;
    AppContext.connection = connection;
//    final graphqlUrl = connection.resolveUrl('/graphql');
    logger.info('init with $registers ...');

//    await GraphQL.instance.init(graphqlUrl);
    registers.forEach((register) => register());
  }
}
