import 'package:flutter/material.dart';
import 'show_title.dart';
import 'show_counter.dart';
import 'show_add_button.dart';

class Counter extends StatelessWidget {
  const Counter({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            ShowTitle(title: 'use model with single counter'),
            ShowButton()
          ]),
          showCounter(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            ShowTitle(title: 'share model with two counter'),
            ShowButtonSecond()
          ]),
          showCounterSecond(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            ShowTitle(title: 'show twice'),
            ShowButtonSecond()
          ]),
          showCounterSecond(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            ShowTitle(title: 'use future with model,and catch errors'),
            ShowButtonAsync()
          ]),
          showCounterAsync(),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
            ShowTitle(title: 'use stream with model'),
            ShowButtonStream()
          ]),
          showCounterStream(),
        ],
      ),
    );
  }
}
