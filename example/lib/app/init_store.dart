import 'package:example/counter/counter.model.dart';

Future<void> initState() async {
  CounterModel(0, 'second'); //注册second
  await Future.delayed(const Duration(seconds: 2));
}
