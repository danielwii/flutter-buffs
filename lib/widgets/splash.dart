import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

class SplashScreen extends StatefulWidget {
  final int seconds;
  final Text title;
  final Color backgroundColor;
  final TextStyle styleTextUnderTheLoader;
  final dynamic navigateAfterSeconds;
  final double photoSize;
  final dynamic onClick;
  final Color loaderColor;
  final bool loading;
  final Image image;
  final Text loadingText;
  final ImageProvider imageBackground;
  final Gradient gradientBackground;
  SplashScreen(
      {this.loaderColor,
      @required this.seconds,
      this.photoSize,
      this.onClick,
      this.navigateAfterSeconds,
      this.title = const Text(''),
      this.backgroundColor = Colors.white,
      this.styleTextUnderTheLoader = const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
      this.image,
      this.loading,
      this.loadingText = const Text(''),
      this.imageBackground,
      this.gradientBackground});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  CountdownTimer timer;
  StreamSubscription<CountdownTimer> subscriber;
  int current;

  void to() {
    if (widget.navigateAfterSeconds != null && widget.navigateAfterSeconds is String) {
      // It's fairly safe to assume this is using the in-built material
      // named route component
//      Routes.router.navigateTo(context, widget.navigateAfterSeconds, replace: true);
      Navigator.of(context).pushReplacementNamed(widget.navigateAfterSeconds);
    } else if (widget.navigateAfterSeconds is Widget) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (BuildContext context) => widget.navigateAfterSeconds));
    } else {
      throw ArgumentError('widget.navigateAfterSeconds must either be a String or Widget');
    }
  }

  @override
  void initState() {
    super.initState();
    current = widget.seconds;
    timer = CountdownTimer(Duration(seconds: widget.seconds), const Duration(seconds: 1));
    subscriber = timer.listen(null);
    subscriber.onData((duration) {
      if (mounted) setState(() => current = widget.seconds - duration.elapsed.inSeconds);
    });
    subscriber.onDone(() {
      subscriber.cancel();
      to();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InkWell(
            onTap: widget.onClick,
            child: Stack(fit: StackFit.expand, children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      image: widget.imageBackground == null
                          ? null
                          : DecorationImage(fit: BoxFit.fill, image: widget.imageBackground),
                      gradient: widget.gradientBackground,
                      color: widget.backgroundColor)),
              Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                Expanded(
                    flex: 2,
                    child: Container(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                      CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Container(child: widget.image),
                          radius: widget.photoSize),
                      Padding(padding: const EdgeInsets.only(top: 10.0)),
                      widget.title
                    ]))),
                widget.loading == true
                    ? Expanded(
                        flex: 1,
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(widget.loaderColor)),
                          Padding(padding: const EdgeInsets.only(top: 20.0)),
                          widget.loadingText
                        ]))
                    : const SizedBox(),
              ]),
              Positioned(
                  right: 12,
                  top: 20,
                  child: MaterialButton(
                      child: Text('关闭 $current'),
                      color: Colors.white30,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      onPressed: to)),
            ])));
  }
}
