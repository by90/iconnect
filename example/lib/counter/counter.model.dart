import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart' show AsyncSnapshot;
import 'package:iconnect/iconnect.dart';

class CounterError implements Exception {
  final String message = 'counter have some errors';
}

class CounterModel {
  AsyncSnapshot<CounterModel> snapshot = const AsyncSnapshot.nothing();
  int value = 0;
  String? key;

  CounterModel(this.value, [String? key]) {
    register<CounterModel>(this, key);
  }
  increment(int step) {
    value = value + step;
    return value;
  }

  Future<void> incrementAsync(int step) async {
    await Future.delayed(const Duration(seconds: 1));
    if (Random().nextBool()) {
      throw CounterError();
    } else {
      increment(step);
    }
  }

  Stream<int> streamIncrease() {
    return Stream.periodic(const Duration(seconds: 1), (i) {
      value = i;
      return value;
    }).take(10);
  }
}

CounterModel first = CounterModel(0);
CounterModel second = CounterModel(0, 'second;');
CounterModel third = CounterModel(0, 'third');
CounterModel fourth = CounterModel(0, 'fourth');
