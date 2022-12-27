import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../helper/context.dart';
import '../helper/logger.dart';
import 'hive.dart';

typedef SetTraceUser = Function({String? uid});

class DefaultServerConnection extends AbstractServerConnection {
  @override
  String? getResolvedIp() {
    // TODO: implement getResolvedIp
    throw UnimplementedError();
  }

  @override
  String resolveAssets(String url) {
    // TODO: implement resolveAssets
    throw UnimplementedError();
  }

  @override
  String resolveUrl(String path,
      {String? ip, String? protectedIp, String? protocol, int? port}) {
    if (!path.startsWith('http')) logger.finer('resolve $path');
    return path;
  }
}

Future<void> appInitializer({
  AppEnv? appEnv,
  AbstractServerConnection? serverConnection,
  required SetTraceUser setTraceUser,
}) async {
  logger.info('init app...');

  await Hive.initFlutter();
  await Hive.openBox(HiveBoxes.auth);
  await Hive.openBox(HiveBoxes.context);

  await AppContext.init(
    env: appEnv ?? AppEnv(HOSTNAME: ''),
    connection: serverConnection ?? DefaultServerConnection(),
    preConfigure: () async {
      logger.info('pre configure...');
      // import 'package:graphql_flutter/graphql_flutter.dart';
      // await initHiveForFlutter();
      /*AuthHandler.reg(
        userParser: (json) {
          throw UnimplementedError();
        },
        onLogout: (redirect, userId) async {
          // await CurrentUserImpl.cleanSaved();
          // GraphQL.ins.client.cache.store.reset();
          // FirebaseAnalytics.instance.logEvent(name: 'logout', parameters: {'userId': userId});
          logger.fine('should redirect: $redirect');
          if (redirect) {
            // Modular.to.navigate('/login'); TODO
          }
        },
        onSignUp: (username) {
          // AuthStore.ins.saveUsername(username);
          // FirebaseAnalytics.instance.logSignUp(signUpMethod: 'password');
        },
        onLogin: (user) async {
          // AuthStore.ins.saveUsername(user.profile!.username!);
          setTraceUser(uid: user.id);
          // GraphQL.ins.client.cache.store.reset();
          // FirebaseAnalytics.instance.logLogin(loginMethod: 'password');
        },
      );*/
      // Token.loadFromStorage();
      // CurrentUserImpl.loadFromStorage();
      // GraphQL.ins.init(AppContext.connection.resolveUrl('graphql'));
      setTraceUser();
    },
    afterSplash: () async {
      final package = await PackageInfo.fromPlatform();
      if (defaultTargetPlatform != TargetPlatform.macOS) {
        /*
        AwesomeNotifications().initialize(
            // set the icon to null if you want to use the default app icon
            null, // 'resource://drawable/res_app_icon',
            [
              NotificationChannel(
                  // channelGroupKey: 'xxx_basic_channel_group',
                  channelKey: package.appName,
                  channelName: 'basic',
                  channelDescription: 'notification channel for basic',
                  defaultColor: const Color(0xFF9D50DD),
                  ledColor: Colors.white),
            ],
            // Channel groups are only visual and are not required
            */ /*
            channelGroups: [
              NotificationChannelGroup(
                  channelGroupkey: 'robin_basic_channel_group',
                  channelGroupName: 'Robin basic group')
            ],*/ /*
            debug: kDebugMode);*/
      }
    },
  );
}
