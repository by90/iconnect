import 'package:flutter/material.dart';

import 'src/store.dart';

export 'src/retry_async.dart';
export 'src/with_async.dart';

//export 'src/store.dart';
//export 'src/mixin.dart';

//two global function:provider and connect
//one mixin for model:IConnect
Widget Function(Widget, Future<void> Function()?) get provider =>
    Store.instance.provider;
//if don't define model with mixin IConnect,could use these four function,for register,listen,dispatch
Function<T>(BuildContext, [String?]) get listen => Store.instance.listen;
void Function<T>([String? key]) get dispatch => Store.instance.dispatch;
T Function<T>(T, [String? key]) get register => Store.instance.register;
void Function<T>([String?]) get unregister => Store.instance.unRegister;
// Future<void> Function()? get initState => Store.instance.initState;
// set initState(Future<void> Function()? value) {
//   Store.instance.initState = value;
// }

Store get store => Store.instance;
