import 'package:flutter/material.dart';
import 'provider.dart';

typedef Action<T> = T Function();
//如果dipose是异步的呢？
typedef Dispose<T> = void Function<T>(T);

class StoreItem<T> {
  String? key; //默认的键，暂时使用toString构建
  T? model; //实例
  Dispose<T>? dispose; //可以不要  //应该有个实例参数
  Map<String, T>? others; // 存放同类型的其它实例
}

void dispose<T>(T obj) {}
var i = dispose;

class Store {
  factory Store() => _instance;
  static Store get instance => _instance;
  static Store _instance = Store._internal();

  Store._internal();

  //暂时使用_storeMap来处理
  final _store = new Map<Type, StoreItem>();

  //以下为旧的代码
  //final _store = new Map<dynamic, VoidCallback?>();
  get store => _store;

  final GlobalKey<ProviderState> _providerStateKey = GlobalKey<ProviderState>();

  void Function<T>(String?, [Function?]) get dispatch =>
      _providerStateKey.currentState!.dispatch;

  listen<T>(context, [String? key]) {
    return Provider.of<T>(context, key);
  }
  //aspec应该是类型加键

  Widget provider(Widget app) {
    return Provider(app, key: _providerStateKey);
  }

  //register，每个只注册一次，重复了则抛出异常
  //应定义一个异常在这里，提供类型、key、出错情况
  T register<T>(T instance, {String? key, Dispose? dispose}) {
    StoreItem item = StoreItem();
    if (!_store.containsKey(instance.runtimeType)) {
      if (key != null) item.key = key;
      if (dispose != null) item.dispose = dispose;

      if (key == null || key == T.toString()) {
        item.model = instance;
      } else {
        //没有默认实例，放置到others里面
        if (item.others == null) item.others = Map<String, dynamic>();
        //这里不用判断是否存在同样的键，因为之前不存在
        item.others![key] = instance;
      }
      _store[T] = item; //加入，如果已经存在就不用加入
      return instance; //这里只返回instance

    }
    //此时无需if了，因为已经排除了包含T的情况
    //if (store.containsKey(T)) { //说明已经存在，有可能是默认的，也有可能默认的没定义

    if (key == null || key == T.toString()) {
      if (_store[T]!.key == T.toString()) {
        throw ('类型${T.toString()}已经注册');
      }
      //如果已经包含了该类型，则应该抛出异常
      //对于默认的情况

      if (key == null) _store[T]!.key = T.toString();
      if (dispose != null) _store[T]!.dispose = dispose;
      _store[T]!.model = instance;
    } else {
      if (_store[T]!.others == null) {
        _store[T]!.others = Map<String, dynamic>();
      }

      if (_store.containsKey(key)) {
        throw ('类型${T.toString()},键值$key已经注册');
      }
      _store[T]!.others![key] = instance;
    }

    return instance;
  }

  void unRegister<T>(String? key) {
    if (!_store.containsKey(T)) throw '您企图删除类型${T.toString()},键值${key!},但它不存在';

    //删除默认实例
    if (key == null || key == T.toString()) {
      if (_store[T]!.dispose != null)
        _store[T]!.dispose!.call(_store[T]!.model);
      if (_store[T]!.others!.isEmpty)
        _store.remove(T);
      else {
        _store[T]!.key = null;
        _store[T]!.model = null; //dispose要保存。
      }
    } else {
      //删除非默认实例
      //如果该实例不存在，则抛出异常
      if (_store[T]!.others!.isEmpty || !_store[T]!.others!.containsKey(key)) {
        throw '您企图删除类型${T.toString()},键值$key,但它不存在';
      }
      //这里需确保dispose不删除
      if (_store[T]!.dispose != null)
        _store[T]!.dispose!.call(_store[T]!.others![key]);
      _store[T]!.others!.remove(key);
      //这里dipose怎么弄？

    }
  }
}
