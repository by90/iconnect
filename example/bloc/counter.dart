import 'dart:async';
import 'provider.dart';

class CounterBloc extends BlocBase {
  StreamController<int> streamController = StreamController<int>.broadcast();

  Sink get counterSink => streamController.sink;
  Stream<int> get counterStream => streamController.stream;

  int counter = 0;

  incrementCounter() {
    counterSink.add(++counter); //sink，传递一个数字进来,这也同时修改了counter本身？
  }

  @override
  void dispose() {
    streamController.close();
  }
}
