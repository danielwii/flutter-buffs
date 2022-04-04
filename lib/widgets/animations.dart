import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

/*
AnimatedOpacity fadeIn(Widget child) {
  return AnimatedOpacity(
    // If the widget is visible, animate to 0.0 (invisible).
    // If the widget is hidden, animate to 1.0 (fully visible).
    //opacity: _visible ? 1.0 : 0.0,
    opacity: 1.0,
    duration: Duration(milliseconds: 500),
    // The green box must be a child of the AnimatedOpacity widget.
    child: child,
  );
}
*/

Widget fadeIn({required Widget child}) => PlayAnimation<double>(
    key: GlobalKey(),
    tween: (0.0).tweenTo(1.0),
    curve: Curves.easeInOut,
    builder: (context, child, value) => Opacity(opacity: value, child: child),
    duration: 0.3.seconds,
    child: child);
