import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ShowTitle extends StatelessWidget {
  const ShowTitle(
      {this.title = 'You have pushed the button this many times:', Key? key})
      : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('ShowTitle build');
    }
    return Text(title);
  }
}
