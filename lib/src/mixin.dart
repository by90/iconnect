import 'package:flutter/material.dart';

import 'store.dart';
import 'provider.dart';

mixin IConnect<T> {
  dynamic model;

  T register<T>(T instance, {String? key, Dispose? dispose}) {
    return Store().register<T>(instance, key: key, dispose: dispose);
  }

  void unRegister<T>([String? key]) {
    return Store().unRegister<T>(key);
  }

  listen<T>(BuildContext context, [String? key]) {
    return Provider.of<T>(context, key);
  }

  dispatch<T>([String? key]) {
    return Store.instance.dispatch<T>(key);
  }
}
