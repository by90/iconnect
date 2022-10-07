import 'package:flutter/material.dart';
import 'provider.dart';

typedef Action<T> = T Function();
//如果dipose是异步的呢？
typedef Dispose<T> = void Function<T>(T);

class StoreItem<T> {
  String? key; //默认的键，暂时使用toString构建
  T? model; //实例
  Map<String, T>? others; // 存放同类型的其它实例
}

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

  void Function<T>([String? key]) get dispatch =>
      _providerStateKey.currentState!.dispatch;

  //这样，Store<T>(key) 就可以得到key为key，类型为T的实例。
  T? call<T>([String? key]) {
    return get<T>(key);
  }

  //使用类型和键值获取model，此时没有监听该model，dispatch时不会响应
  T? get<T>([String? key]) {
    if (!Store.instance._store.containsKey(T)) return null;
    if (key == null || key == T.toString()) {
      return Store.instance._store[T]!.model;
    }
    if (Store.instance._store[T]!.others == null) return null;
    if (Store.instance._store[T]!.others!.containsKey(key))
      return Store.instance._store[T]!.others![key];
    return null;
  }

  //监听，并返回监听的实例
  T? listen<T>(BuildContext context, [String? key]) {
    Provider.of<T>(context, key);
    return get<T>(key);
  }
  //aspec应该是类型加键

  Widget provider(Widget app, Future<void> Function()? initState) {
    return Provider(
      app,
      key: _providerStateKey,
      initState: initState,
    );
  }

  //register，每个只注册一次，重复了则抛出异常
  //应定义一个异常在这里，提供类型、key、出错情况
  T register<T>(T model, [String? key]) {
    StoreItem item = StoreItem();

    //不包括此类型，说明既没有注册默认实例，也没有注册二级同类型实例
    if (!_store.containsKey(model.runtimeType)) {
      if (key != null) item.key = key;

      if (key == null || key == T.toString()) {
        item.model = model;
      } else {
        //没有默认实例，放置到others里面
        if (item.others == null) item.others = Map<String, dynamic>();
        //这里不用判断是否存在同样的键，因为之前不存在
        item.others![key] = model;
      }
      _store[T] = item; //加入，如果已经存在就不用加入

      //return instance; //这里只返回instance
    }
    //说明注册了一个同类型实例，可能是默认的，也可能是二级同类实例
    else {
      //此时已_store经包含T
      //此时无需if了，因为已经排除了包含T的情况
      //if (_store.containsKey(T)) { //说明已经存在，有可能是默认的，也有可能默认的没定义

      //试图注册默认实例
      if (key == null || key == T.toString()) {
        //当默认实例已经注册时抛出异常，开发阶段需要处理
        if (_store[T]!.key == T.toString()) {
          throw ('类型${T.toString()}已经注册');
        }
        //如果已经包含了该类型，则应该抛出异常
        //对于默认的情况

        //上面处理key已经赋值的情况，这里处理key为null的情况
        //很明显，此时是注册了有key的实例，在others，但并未注册默认实例
        //以下两步注册
        //这里没必要判断是否key为null，因为肯定为null，上面key不为null的情形已经排除
        //if (key == null)
        _store[T]!.key = T.toString();
        _store[T]!.model = model;
      }
      //试图注册二级同名实例
      else {
        if (_store[T]!.others == null) {
          _store[T]!.others = Map<String, dynamic>();
        }

        //bug:需要检查_store[T]!.others![key]是否等于提供的key
        if (_store[T]!.others!.containsKey(key))
        //&& _store[T]!.others![key] == key)  //bug:这里很明显，左边是model右边是key

        {
          throw ('类型${T.toString()},键值$key已经注册');
        }
        _store[T]!.others![key] = model;
      }

      //return instance;
    }

    //统一return
    return model;
  }

  Future<void> Function()? initState; //默认为null

  void unRegister<T>([String? key]) {
    if (!_store.containsKey(T)) throw '您企图删除类型${T.toString()},键值${key!},但它不存在';

    //删除默认实例
    if (key == null || key == T.toString()) {
      //if (_store[T]!.dispose != null)

      //_store[T]!.dispose!.call(_store[T]!.model);

      _dispose(_store[T]!.model);

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
      // if (_store[T]!.dispose != null)
      //   _store[T]!.dispose!.call(_store[T]!.others![key]);
      _dispose(_store[T]!.others![key]);
      _store[T]!.others!.remove(key);
      //这里dipose怎么弄？

    }
  }

  bool _dispose(dynamic obj) {
    try {
      obj.dispose();
    } catch (e) {
      return false;
    }
    return true;
  }

  //注意model提供的onRegister可能是future
  //它可以抛出开发异常
  //register后并不能立刻得到它的结果
}



//remove mixin.dart
// import 'package:flutter/material.dart';

// import 'store.dart';
// import 'provider.dart';

// mixin IConnect<T> {
//   dynamic model;

//   T register<T>(T instance, [String? key]) {
//     return Store().register<T>(instance, key);
//   }

//   void unRegister<T>([String? key]) {
//     return Store().unRegister<T>(key);
//   }

//   listen<T>(BuildContext context, [String? key]) {
//     return Provider.of<T>(context, key);
//   }

//   dispatch<T>([String? key]) {
//     return Store.instance.dispatch<T>(key);
//   }
// }
