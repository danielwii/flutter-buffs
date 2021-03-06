import 'dart:io';

import 'package:commons/commons.dart' hide Response;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'helper.dart';
import 'logger.dart';

final _cacheManager = DefaultCacheManager();

Future<File> cacheFile(String path) async {
  if (path?.trim()?.isNotEmpty == true) {
    final url = AppContext.connection.resolveUrl(path);
    final fileFromCache = await _cacheManager.getFileFromCache(url);
    if (fileFromCache == null) logger.info('cache url $url');
    return _cacheManager.getSingleFile(url);
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

class LoadingAlertDialog extends StatefulWidget {
  final Widget title;
  final Widget content;

  final VoidCallback onConfirmed;
  final bool disableActions;

  LoadingAlertDialog(this.title, this.content, {this.onConfirmed, this.disableActions});

  @override
  State<StatefulWidget> createState() => _LoadingAlertDialogState();
}

class _LoadingAlertDialogState extends State<LoadingAlertDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) => isLoading
      ? Container(
          child: Center(child: Card(child: Padding(padding: const EdgeInsets.all(8.0), child: LoadingIndicator()))))
      : AlertDialog(
          title: widget.title,
          content: widget.content,
          actions: widget.disableActions == true
              ? null
              : <Widget>[
                  FlatButton(
                      child: Text('确定'),
                      onPressed: () => Future.sync(() async {
                            setState(() => isLoading = true);
                            await widget.onConfirmed();
                            Navigator.pop(context);
                          }).whenComplete(() {
                            if (mounted) setState(() => isLoading = false);
                          })),
                  FlatButton(child: Text('取消'), onPressed: () => Navigator.pop(context)),
                ]);
}

class EasyDialog {
  static void toast(String message) {
    try {
      infoToast(message);
      // ignore: empty_catches
    } on StateError {}
  }

  static Future dialog(BuildContext context, {@required Widget title, @required Widget content}) => showDialog(
      context: context, builder: (BuildContext context) => LoadingAlertDialog(title, content, disableActions: true));

  static Future confirm(BuildContext context,
          {@required Widget title, Widget content, @required Function onConfirmed}) =>
      showDialog(
          context: context,
          builder: (BuildContext context) => LoadingAlertDialog(title, content, onConfirmed: onConfirmed));
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

dynamic withP<E>(E element, Function(E element) builder, {Function() orElse}) =>
    element == null ? (orElse != null ? orElse() : null) : builder(element);
