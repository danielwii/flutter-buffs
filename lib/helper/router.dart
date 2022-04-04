import 'package:flutter/material.dart';

typedef RouterHandler = Function(
    BuildContext context, Map<String, dynamic> arguments);

class Routes {
  static Map<String, RouterHandler> routers = {};

  static void configureRoutes() {}

  static void regRouteHandler(String routePath, RouterHandler handler) {
    routers.putIfAbsent(routePath, () => handler);
  }

  static Widget buildPage(
      BuildContext context, String name, Map<String, dynamic> arguments) {
    if (!routers.containsKey(name)) {
      throw ('no $name found in routers');
    }
    return routers[name]!(context, arguments);
  }
}
