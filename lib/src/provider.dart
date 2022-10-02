import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; //需要加入

typedef Action<T> = T Function();

class Provider extends StatefulWidget {
  final Widget child;
  final Key? stateKey;
  Provider(this.child, {Key? key, this.stateKey}) : super(key: key);
  @override
  ProviderState createState() => new ProviderState(key: stateKey);
  static of(BuildContext context, dynamic model) {
    return InheritedModel.inheritFrom<_InheritedStore>(context, aspect: model);
  }
}

class ProviderState extends State<Provider> {
  dynamic aspectId;
  ProviderState({Key? key});

  Future<void> _rebuild() async {
    if (!mounted) return; //如果组件没有mount，此次rebuild将被忽略

    // if there's a current frame,
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      // wait for the end of that frame.
      await SchedulerBinding.instance.endOfFrame;
      if (!mounted) return;
    }

    setState(() {});
  }

  //  R? ret = fn?.call();

  //   if (ret is Future) {
  //     ret.then((_) {
  //       _update();
  //     });
  //   } else {
  //     _update();
  //   }

  //   return ret;
  // }

  //action最终返回同类型的值，用来更改map中的值？然而map中明显的是使用实例做指针？？
  //这里我们假设action不返回新的model，涉及到返回的情况我们之后再处理
  void dispatch(dynamic model, [Function? action]) {
    aspectId = model;
    if (action != null) {
      var _result = action();
      if (_result is Future) {
        _result.then((_) {
          _rebuild();
        });
      } else {
        _rebuild();
      }
      //return _result;
      return;
    }

    _rebuild(); //注意这里是异步函数
    return;
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedStore(
        child: widget.child, aspectId: aspectId as dynamic);
  }
}

class _InheritedStore extends InheritedModel<Object> {
  _InheritedStore({Key? key, required Widget child, required this.aspectId})
      : super(key: key, child: child);
  final dynamic aspectId;

  @override
  bool updateShouldNotify(_InheritedStore oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(
      InheritedModel<dynamic> oldWidget, Set<dynamic> dependencies) {
    bool result = dependencies.contains(aspectId);
    return result;
  }
}
