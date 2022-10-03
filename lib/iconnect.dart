import 'src/store.dart';
export 'src/mixin.dart';

//two global function:provider and connect
//one mixin for model:IConnect
get provider => Store.instance.provider;

//if don't define model with mixin IConnect,could use these four function,for register,listen,dispatch
dynamic Function<T>(dynamic, String?) get listen => Store.instance.listen;
void Function<T>(String?, [Function?]) get dispatch => Store.instance.dispatch;
T Function<T>(T, {void Function<T>(T)? dispose, String? key}) get register =>
    Store.instance.register;
void Function<T>(String?) get unregister => Store.instance.unRegister;
