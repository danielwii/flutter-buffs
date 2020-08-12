import 'package:flutter/material.dart';

Stack shadowText(String text, {TextStyle style, Color foregroundColor = Colors.black87}) => Stack(children: <Widget>[
      Text(text,
          style: (style ?? TextStyle()).copyWith(
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = foregroundColor)),
      Text(text, style: style),
    ]);
