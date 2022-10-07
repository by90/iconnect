import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:example/counter/counter.model.dart';
import 'package:iconnect/iconnect.dart';

class ShowButtonOrigin extends StatelessWidget {
  const ShowButtonOrigin({Key? key, this.increase}) : super(key: key);
  final VoidCallback? increase;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: increase,
      tooltip: 'Increment',
      child: const Icon(Icons.add),
    );
  }
}

class ShowButton extends StatelessWidget {
  const ShowButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //print('press button');
    return ShowButtonOrigin(increase: () {
      first.increment(1);
      dispatch<CounterModel>();
    });
  }
}

class ShowButtonSecond extends StatelessWidget {
  const ShowButtonSecond({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('ShowButtonSecond build');
    }
    return ShowButtonOrigin(increase: () {
      store<CounterModel>('second')!.increment(1); //没有!则提示错误，说动态。因为可能是null
      dispatch<CounterModel>('second');
    });
  }
}

class ShowButtonAsync extends StatelessWidget {
  const ShowButtonAsync({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowButtonOrigin(increase: () async {
      third.snapshot = const AsyncSnapshot.waiting();
      dispatch<CounterModel>('third');
      try {
        await third.incrementAsync(1);

        third.snapshot = AsyncSnapshot.withData(ConnectionState.done, third);
        dispatch<CounterModel>('third');
      } catch (e) {
        third.snapshot = AsyncSnapshot.withError(ConnectionState.done, e);
        dispatch<CounterModel>('third');
      } finally {}
    });
  }
}

class ShowButtonStream extends StatelessWidget {
  const ShowButtonStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShowButtonOrigin(increase: () {
      fourth.streamIncrease().listen((event) {
        dispatch<CounterModel>('fourth');
      });
    });
  }
}
