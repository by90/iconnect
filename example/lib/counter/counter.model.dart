import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart' show AsyncSnapshot;
import 'package:iconnect/iconnect.dart';

class CounterError implements Exception {
  final String message = 'counter have some errors';
}

class CounterModel with IConnect {
  AsyncSnapshot<CounterModel> snapshot = AsyncSnapshot.nothing();
  int value = 0;

  CounterModel(value) {
    this.value = value;
    register();
  }
  increment(int step) {
    value = value + step;
    return value;
  }

  Future<void> incrementAsync(int step) async {
    await Future.delayed(Duration(seconds: 1));
    if (Random().nextBool()) {
      throw CounterError();
    } else {
      increment(step);
    }
  }

  Stream<int> streamIncrease() {
    return Stream.periodic(Duration(seconds: 1), (i) {
      this.value = i;
      return this.value;
    }).take(10);
  }
}

CounterModel first = new CounterModel(0);
CounterModel second = new CounterModel(0);
CounterModel third = new CounterModel(0);
CounterModel fourth = new CounterModel(0);
