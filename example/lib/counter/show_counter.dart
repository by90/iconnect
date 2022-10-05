import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:example/counter/counter.model.dart';
import 'package:iconnect/iconnect.dart';

class ShowCounterOrigin extends StatelessWidget {
  const ShowCounterOrigin({Key? key, this.value = 0}) : super(key: key);
  final int value;

  @override
  Widget build(BuildContext context) {
    return Text('$value', style: Theme.of(context).textTheme.headline4);
  }
}

Widget showCounter() {
  return Builder(builder: (context) {
    if (kDebugMode) {
      print('ShowCounter build ');
    }
    //listen(context, first);
    listen<CounterModel>(context);
    return ShowCounterOrigin(value: first.value);
  });
}

Widget showCounterSecond() {
  return Builder(builder: (context) {
    if (kDebugMode) {
      print('ShowCounterSecond build ');
    }
    listen<CounterModel>(context, 'second');
    return ShowCounterOrigin(value: second.value);
  });
}

Widget showCounterAsync() {
  return Builder(builder: (context) {
    if (kDebugMode) {
      print('ShowCounterSecond build ');
    }
    listen(context, 'third');
    switch (third.snapshot.connectionState) {
      case ConnectionState.waiting:
        return const CircularProgressIndicator();
      default:
        if (third.snapshot.hasError) {
          return Text(
            'Error: ${(third.snapshot.error as CounterError).message}',
            style: const TextStyle(color: Colors.red),
          );
        } else if (third.snapshot.hasData) {
          return ShowCounterOrigin(value: third.snapshot.data!.value);
        } else {
          return ShowCounterOrigin(value: third.value);
        }
    }
  });
}

Widget showCounterStream() {
  return Builder(builder: (context) {
    listen(context, 'fourth');
    return ShowCounterOrigin(value: fourth.value);
  });
}
