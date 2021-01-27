import 'src/store.dart';
export 'src/iconnect.dart'; //only connect function

get listen => Store.instance.listen;
get dispatch => Store.instance.dispatch;
get register => Store.instance.register;
get provider => Store.instance.provider;
get unregister => Store.instance.unRegister;
