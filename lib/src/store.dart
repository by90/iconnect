import 'package:flutter/material.dart';
import 'provider.dart';

class Store {
  factory Store() => _instance;
  static Store get instance => _instance;
  static Store _instance = Store._internal();

  Store._internal();

  final _store = new Map<dynamic, VoidCallback?>();
  get store => _store;

  final GlobalKey<ProviderState> _providerStateKey = GlobalKey<ProviderState>();

  get dispatch => _providerStateKey.currentState!.dispatch;

  listen(context, dynamic model) {
    return Provider.of(context, model);
  }

  Widget provider(Widget app) {
    return Provider(app, key: _providerStateKey);
  }

  dynamic register(dynamic model, [VoidCallback? dispose]) {
    if (!_store.containsKey(model)) {
      _store[model] = dispose;
    }
    return model;
  }

  dynamic unRegister(dynamic model, [VoidCallback? dispose]) {
    if (!_store.containsKey(model)) {
      if (_store[model] != null) _store[model]!();
      _store.remove(model);
    }
  }
}
