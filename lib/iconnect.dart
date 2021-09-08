import 'src/store.dart';
export 'src/iconnect.dart'; //only connect function
export 'src/mixin.dart';

//two global function:provider and connect
//one mixin for model:IConnect
get provider => Store.instance.provider;

//if don't define model with mixin IConnect,could use these four function,for register,listen,dispatch
get listen => Store.instance.listen;
get dispatch => Store.instance.dispatch;
get register => Store.instance.register;
get unregister => Store.instance.unRegister;
