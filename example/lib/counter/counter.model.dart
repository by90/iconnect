import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart' show AsyncSnapshot;
import 'package:iconnect/iconnect.dart';

class CounterError implements Exception {
  final String message = 'counter have some errors';
}

class CounterModel {
  AsyncSnapshot<CounterModel> snapshot = AsyncSnapshot.nothing();
  int value = 0;

  CounterModel(value) {
    this.value = value;
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

CounterModel _first = new CounterModel(0);
CounterModel _second = new CounterModel(0);
CounterModel _third = new CounterModel(0);
CounterModel _fourth = new CounterModel(0);

CounterModel get first => register(_first) as CounterModel;
CounterModel get second => register(_second) as CounterModel;
CounterModel get third => register(_third) as CounterModel;
CounterModel get fourth => register(_fourth) as CounterModel;
