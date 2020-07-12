import 'helper.dart';

abstract class AppConfigure {
  String get hostname;
  String get protectedProtocol;
  String get protectedIp;
  int get protectedPort;
}

abstract class AbstractServerConnection {
  String resolveUrl(String path, {String ip, String protectedIp, String protocol, int port});
  String getResolvedIp();
}

class AppContext {
  static AppConfigure configure;
  static AbstractServerConnection connection;

  static init({AppConfigure configure, AbstractServerConnection connection}) async {
    AppContext.configure = configure;
    final graphqlUrl = connection.resolveUrl('/graphql');
//    logger.info('graphqlUrl is $graphqlUrl');

    await GraphQL.instance.init(graphqlUrl);
  }
}
