import 'package:flutter/material.dart';
import 'showTitle.dart';
import 'showCounter.dart';
import 'showAddButton.dart';

class Counter extends StatelessWidget {
  Counter({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(children: [
            ShowTitle(title: 'use model with single counter'),
            ShowButton()
          ], mainAxisAlignment: MainAxisAlignment.center),
          showCounter(),
          Row(children: [
            ShowTitle(title: 'share model with two counter'),
            ShowButtonSecond()
          ], mainAxisAlignment: MainAxisAlignment.center),
          showCounterSecond(),
          Row(
              children: [ShowTitle(title: 'show twice'), ShowButtonSecond()],
              mainAxisAlignment: MainAxisAlignment.center),
          showCounterSecond(),
          Row(children: [
            ShowTitle(title: 'use future with model,and catch errors'),
            ShowButtonAsync()
          ], mainAxisAlignment: MainAxisAlignment.center),
          showCounterAsync(),
          Row(children: [
            ShowTitle(title: 'use stream with model'),
            ShowButtonStream()
          ], mainAxisAlignment: MainAxisAlignment.center),
          showCounterStream(),
        ],
      ),
    );
  }
}
