import 'package:flutter/material.dart';
import 'package:example/counter/counter.model.dart';

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
    return ShowButtonOrigin(
        increase: () => first.dispatch(() => first.increment(1)));
  }
}

class ShowButtonSecond extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('ShowButtonSecond build');
    return ShowButtonOrigin(
        increase: () => second.dispatch(() => second.increment(1)));
  }
}

class ShowButtonAsync extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShowButtonOrigin(increase: () async {
      third.snapshot = AsyncSnapshot.waiting();

      third.dispatch();
      try {
        await third.incrementAsync(1);

        third.snapshot = AsyncSnapshot.withData(ConnectionState.done, third);
        third.dispatch();
      } catch (e) {
        third.snapshot = AsyncSnapshot.withError(ConnectionState.done, e);
        third.dispatch();
      } finally {}
    });
  }
}

class ShowButtonStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShowButtonOrigin(increase: () {
      fourth.streamIncrease().listen((event) {
        fourth.dispatch();
      });
    });
  }
}
