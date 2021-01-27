import 'package:flutter/material.dart';

class ShowTitle extends StatelessWidget {
  ShowTitle(
      {this.title = 'You have pushed the button this many times:', Key? key})
      : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    print('ShowTitle build');
    return Text(title);
  }
}
