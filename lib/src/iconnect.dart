import 'package:flutter/material.dart';

typedef WidgetBuilder<T> = Widget Function(BuildContext context);

class _Connect extends StatelessWidget {
  final WidgetBuilder builder;
  _Connect(this.builder, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return builder(context);
  }
}

Widget connect(WidgetBuilder builder) => _Connect(builder);
