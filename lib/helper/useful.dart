import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_buffs/flutter_buffs.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiver/strings.dart';

final _cacheManager = DefaultCacheManager();

Future<File?> cacheFile(String path) async {
  if (path.trim().isNotEmpty == true) {
    final url = AppContext.connection.resolveUrl(path);
    final fileFromCache = await _cacheManager.getFileFromCache(url);
    if (fileFromCache == null) logger.info('cache url $url');
    return _cacheManager.getSingleFile(url);
  }
  return Future.value();
}

class IgnoreBadCertificateHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

HttpClient? dioOnHttpClientCreate(HttpClient client) {
  client.badCertificateCallback =
      (X509Certificate cert, String host, int port) => true;
  return client;
  /*
  if (kDebugMode)
    client.findProxy = (uri) {
      //proxy all request to localhost:8888
      return "PROXY 10.0.2.2:9091";
    };*/
}

Map<String, String> withHostHeader(String? url) {
  final isNull = isBlank(url);
  final httpStart = url?.startsWith('http') == true;
//  logger.info('url is $url contains ${ServerConnection.getResolvedIp()}');
  final ipIncluded = isNull || AppContext.connection.getResolvedIp() == null
      ? false
      : url?.contains(AppContext.connection.getResolvedIp() ?? '') ?? false;
  final needHost = isNull || httpStart || !ipIncluded;
  return needHost ? {HttpHeaders.hostHeader: AppContext.env.hostname} : {};
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
  final Widget? content;

  final Function? onConfirmed;
  final bool? disableActions;

  LoadingAlertDialog(this.title, this.content,
      {required this.onConfirmed, this.disableActions});

  @override
  State<StatefulWidget> createState() => _LoadingAlertDialogState();
}

class _LoadingAlertDialogState extends State<LoadingAlertDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) => isLoading
      ? Container(
          child: Center(
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LoadingIndicator()))))
      : AlertDialog(
          title: widget.title,
          content: widget.content,
          actions: widget.disableActions == true
              ? null
              : <Widget>[
                  TextButton(
                      child: Text('取消'),
                      onPressed: () => Navigator.pop(context, false)),
                  ElevatedButton(
                      child: Text('确定'),
                      onPressed: () => Future.sync(() async {
                            setState(() => isLoading = true);
                            if (widget.onConfirmed != null) {
                              widget.onConfirmed!();
                            }
                            Navigator.pop(context, true);
                          }).whenComplete(() {
                            if (mounted) setState(() => isLoading = false);
                          })),
                ]);
}

class AsunaDialog {
  static Future<bool?> confirm(BuildContext context,
          {required Widget title, Widget? content, Function? onConfirmed}) =>
      showDialog(
          context: context,
          builder: (BuildContext context) =>
              LoadingAlertDialog(title, content, onConfirmed: onConfirmed));

  static void message(String message,
      {GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
      BuildContext? context,
      Duration? duration,
      SnackBarBehavior snackBarBehavior = SnackBarBehavior.fixed}) {
    duration ??= const Duration(seconds: 3);

    final snackBar = SnackBar(
      duration: duration,
      content: Text(
        message,
        style: TextStyle(color: Colors.pink),
      ),
      // backgroundColor: theme.colorScheme.primary,
      behavior: snackBarBehavior,
    );

    if (scaffoldMessengerKey != null) {
      scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
    } else if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Fluttertoast.showToast(msg: message);
      try {
        // ignore: empty_catches
      } on StateError {}
    }
  }

  static void error(String message,
      {GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey,
      BuildContext? context,
      Duration? duration,
      SnackBarBehavior snackBarBehavior = SnackBarBehavior.fixed}) {
    duration ??= const Duration(seconds: 3);

    final snackBar = SnackBar(
      duration: duration,
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.white10,
      behavior: snackBarBehavior,
    );

    if (scaffoldMessengerKey != null) {
      scaffoldMessengerKey.currentState!.showSnackBar(snackBar);
    } else if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      Fluttertoast.showToast(
          msg: message, timeInSecForIosWeb: duration.inSeconds);
      try {
        // ignore: empty_catches
      } on StateError {}
    }
  }
}

class EnumHelper {
  static String? toName(item) {
    if (item == null) return null;

    return item.toString().split('.')[1];
  }

  static T? fromString<T>(List<T> enumValues, String value) {
    if (enumValues.isNotEmpty == true) return null;

    return enumValues.singleWhere(
      (enumItem) => toName(enumItem) == value,
      // orElse: () => null,
    );
  }
}

String? enumName(item) => EnumHelper.toName(item);

R withP<R, E>(E element, R Function(E element) builder, {Function()? orElse}) =>
    element == null ? (orElse != null ? orElse() : null) : builder(element);

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
