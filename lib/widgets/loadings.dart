import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AnimatedRotationBox(
      child: GradientCircularProgressIndicator(
          radius: 15.0,
          colors: [Colors.red[300], Colors.orange, Colors.grey[50]],
          value: .8,
          backgroundColor: Colors.transparent));
}
