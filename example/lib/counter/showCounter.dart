import 'package:flutter/material.dart';
import 'package:iconnect/iconnect.dart';
import 'package:example/counter/counter.model.dart';

class ShowCounterOrigin extends StatelessWidget {
  ShowCounterOrigin({Key? key, this.value = 0}) : super(key: key);
  final int value;

  @override
  Widget build(BuildContext context) {
    return Text('$value', style: Theme.of(context).textTheme.headline4);
  }
}

Widget showCounter() {
  return connect((context) {
    print('ShowCounter build ');
    listen(context, first);
    return ShowCounterOrigin(value: first.value);
  });
}

Widget showCounterSecond() {
  return connect((context) {
    print('ShowCounterSecond build ');
    listen(context, second);
    return ShowCounterOrigin(value: second.value);
  });
}

Widget showCounterAsync() {
  return connect((context) {
    print('ShowCounterSecond build ');
    listen(context, third);
    switch (third.snapshot.connectionState) {
      case ConnectionState.waiting:
        return CircularProgressIndicator();
      default:
        if (third.snapshot.hasError)
          return Text(
            'Error: ${(third.snapshot.error as CounterError).message}',
            style: TextStyle(color: Colors.red),
          );
        else if (third.snapshot.hasData)
          return ShowCounterOrigin(value: third.snapshot.data!.value);
        else
          return ShowCounterOrigin(value: third.value);
    }
  });
}

Widget showCounterStream() {
  return connect((context) {
    listen(context, fourth);
    return ShowCounterOrigin(value: fourth.value);
  });
}
