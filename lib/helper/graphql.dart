import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart' as __dio;
import 'package:flutter/material.dart';
import 'package:flutter_buffs/helper/logger.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';

import 'logger.dart';

class _DioClient implements Client {
  final header;
  __dio.Dio dio;

  _DioClient(this.dio, {this.header});

  @override
  void close() {}

  @override
  Future<Response> delete(url, {Map<String, String> headers}) {
    logger.warning("delete");

    return null;
  }

  @override
  Future<Response> get(url, {Map<String, String> headers}) {
    logger.warning("get");

    return null;
  }

  @override
  Future<Response> head(url, {Map<String, String> headers}) {
    logger.warning("head");

    return null;
  }

  @override
  Future<Response> patch(url, {Map<String, String> headers, body, Encoding encoding}) {
    logger.warning("patch");

    return null;
  }

  @override
  Future<Response> post(url, {Map<String, String> headers, body, Encoding encoding}) {
    logger.info('post $url $body');
    return dio
        .post(url,
            options: __dio.Options(headers: {
//              HttpHeaders.authorizationHeader: 'Bearer ${Token.instance?.token}',
              ...this.header,
            }),
            data: body)
        .then((resp) {
      logger.info('received ${resp.data}');
      return Response(
        jsonEncode(resp.data),
        resp.statusCode,
        headers: {HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'},
      );
    });
  }

  @override
  Future<Response> put(url, {Map<String, String> headers, body, Encoding encoding}) {
    logger.warning("put");

    return null;
  }

  @override
  Future<String> read(url, {Map<String, String> headers}) {
    logger.warning("read");

    return null;
  }

  @override
  Future<Uint8List> readBytes(url, {Map<String, String> headers}) {
    logger.warning("readBytes");

    return null;
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    logger.info("send $request ${(request as Request).body}");
    return dio
        .post(request.url.toString(),
            options: __dio.Options(headers: {
//              HttpHeaders.authorizationHeader: 'Bearer ${Token.instance?.token}',
              ...this.header,
            }),
            data: (request as Request).body)
        .then((resp) {
      logger.info('received ${resp.data}');
      return StreamedResponse(new Stream.fromIterable([Utf8Encoder().convert(jsonEncode(resp.data))]), resp.statusCode);
    });
  }
}

class GraphQL {
  static final instance = GraphQL._();
  ValueNotifier<GraphQLClient> client;
  String latestUri;

  GraphQL._();

  init(String uri) {
    if (latestUri != uri) {
      latestUri = uri;
      final httpLink = HttpLink(
//        httpClient: _DioClient(IpPool.dio, header: {HttpHeaders.hostHeader: AppContext.hostname}),
        uri: uri,
      );
      // not working for custom dio client
//      final authLink = AuthLink(getToken: () async => 'Bearer ${Token.instance?.token}');
//      final link = authLink.concat(httpLink);

      logger.info('init graphql with: $uri ...');
      client = ValueNotifier(GraphQLClient(link: httpLink, cache: InMemoryCache()));
    }
  }

  GraphQLProvider withProvider({@required Widget child}) => GraphQLProvider(client: client, child: child);
}
