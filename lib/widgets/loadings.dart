import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AnimatedRotationBox(
      child: GradientCircularProgressIndicator(
          radius: 15.0,
          colors: [Colors.red[300]!, Colors.orange, Colors.grey[50]!],
          value: .8,
          backgroundColor: Colors.transparent));
}

class LoadingIndicator2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AnimatedRotationBox(
      child: GradientCircularProgressIndicator(
          radius: 15.0,
          colors: [Colors.red, Colors.red],
          value: .7,
          backgroundColor: Colors.transparent));
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key? key}) => showDialog<void>(
        context: context,
        useRootNavigator: false,
        barrierDismissible: false,
        builder: (_) => LoadingDialog(key: key),
      ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () async => false,
      child: Center(
          child: Card(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LoadingIndicator()))));
}
