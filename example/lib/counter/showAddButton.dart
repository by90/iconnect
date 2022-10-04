import 'package:flutter/material.dart';
import 'package:example/counter/counter.model.dart';
import 'package:iconnect/iconnect.dart';

class ShowButtonOrigin extends StatelessWidget {
  ShowButtonOrigin({Key? key, this.increase}) : super(key: key);
  final VoidCallback? increase;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: increase,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }
}

class ShowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('press button');
    return ShowButtonOrigin(increase: () {
      first.increment(1);
      dispatch<CounterModel>();
    });
  }
}

class ShowButtonSecond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('ShowButtonSecond build');
    return ShowButtonOrigin(increase: () {
      second.increment(1);
      dispatch<CounterModel>('second');
    });
  }
}

class ShowButtonAsync extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShowButtonOrigin(increase: () async {
      third.snapshot = AsyncSnapshot.waiting();
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
  @override
  Widget build(BuildContext context) {
    return ShowButtonOrigin(increase: () {
      fourth.streamIncrease().listen((event) {
        dispatch<CounterModel>('fourth');
      });
    });
  }
}
