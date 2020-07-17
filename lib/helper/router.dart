import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

class Routes {
  static Router router;

  static void configureRoutes(Router router) {
    Routes.router = router;
    router.notFoundHandler = Handler(handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print("ROUTE WAS NOT FOUND !!! $params");
      return const SizedBox();
    });
//    router.define(RoutePath.home, handler: rootHandler);
//    router.define(demoSimple, handler: demoRouteHandler);
//    router.define(demoSimpleFixedTrans, handler: demoRouteHandler, transitionType: TransitionType.inFromLeft);
//    router.define(demoFunc, handler: demoFunctionHandler);
//    router.define(deepLink, handler: deepLinkHandler);
  }

  static void regRouteHandler(String routePath, Handler handler) {
    router.define(routePath, handler: handler);
  }
}
