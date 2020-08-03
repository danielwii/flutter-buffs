import 'dart:io';

import 'package:commons/commons.dart' hide Response;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'helper.dart';
import 'logger.dart';

final _cacheManager = DefaultCacheManager();

Future<File> cacheFile(String path) async {
  if (path?.trim()?.isNotEmpty == true) {
    final url = AppContext.connection.resolveUrl(path);
    final fileFromCache = await _cacheManager.getFileFromCache(url);
    if (!fileFromCache.file.existsSync()) {
      logger.info('cache url $url');
      return _cacheManager.getSingleFile(url);
    }
    return Future.value(fileFromCache.file);
  }
  return Future.value(null);
}

Future<void> launchIfPossible(String url) async {
  if (await canLaunch(url)) await launch(url);
}

class IgnoreBadCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void dioOnHttpClientCreate(HttpClient client) {
  client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
//  if (isDebugMode())
//    client.findProxy = (uri) {
//      //proxy all request to localhost:8888
//      return "PROXY 10.0.2.2:9091";
//    };
}

Map<String, String> withHostHeader(String url) {
  final isNull = url?.isNotEmpty != true;
  final httpStart = url?.startsWith('http') == true;
//  logger.info('url is $url contains ${ServerConnection.getResolvedIp()}');
  final ipIncluded = isNull || AppContext.connection.getResolvedIp() == null
      ? false
      : url.contains(AppContext.connection.getResolvedIp());
  final needHost = isNull || httpStart || !ipIncluded;
  return (needHost || AppContext.env.hostname == null) ? {} : {HttpHeaders.hostHeader: AppContext.env.hostname};
}

dynamic fromResponse(Response response, callback) {
  logger.fine('response status is ${response.statusCode}');
  if (RegExp(r'^20\d$').hasMatch('${response.statusCode}')) {
    logger.info('data is ${response.data}');

    return callback(response.data);
  } else {
    throw Exception(response.data);
  }
}

class EasyDialog {
  static void toast(String message) => infoToast(message);

  static Future confirm(BuildContext context,
          {@required String title, String content, @required Function onConfirmed}) =>
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                  title: Text(title),
                  content: content?.isNotEmpty == true ? Text(content) : null,
                  actions: <Widget>[
                    FlatButton(
                        child: Text('确定'),
                        onPressed: onConfirmed != null
                            ? () async {
                                await onConfirmed();
                                Navigator.pop(context);
                              }
                            : null),
                    FlatButton(child: Text('取消'), onPressed: () => Navigator.pop(context)),
                  ]));
}

class EnumHelper {
  static String toName(item) {
    if (item == null) return null;

    return item.toString().split('.')[1];
  }

  static T fromString<T>(List<T> enumValues, String value) {
    if (value == null || enumValues?.isNotEmpty == true) return null;

    return enumValues.singleWhere((enumItem) => toName(enumItem) == value, orElse: () => null);
  }
}

String enumName(item) => EnumHelper.toName(item);
