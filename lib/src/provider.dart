import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart'; //需要加入

class Provider extends StatefulWidget {
  final Widget child;
  final Key? stateKey;
  Provider(this.child, {Key? key, this.stateKey}) : super(key: key);
  @override
  ProviderState createState() => new ProviderState(key: stateKey);

  static of<T>(BuildContext context, [String? key]) {
    return InheritedModel.inheritFrom<_InheritedStore>(context, aspect: key);
  }
}

class ProviderState extends State<Provider> {
  String? aspectId; //这是类型

  ProviderState({Key? key});

  Future<void> _rebuild() async {
    if (!mounted) {
      print('not mounted,ignore rebuild');
      return; //如果组件没有mount，此次rebuild将被忽略
    }

    // if there's a current frame,
    if (SchedulerBinding.instance.schedulerPhase != SchedulerPhase.idle) {
      // wait for the end of that frame.
      await SchedulerBinding.instance.endOfFrame;
      if (!mounted) return;
    }

    setState(() {});
  }

  // 这里可以执行action，考虑到尽量的不要有多种选择，这是精简设计的要务之一
  //  因此去掉action的概念，model变化后直接dispatch
  //  void dispatch<T>({String? key, Function? action}) {
  //   aspectId = key;
  //   //print('dispatch,${T.toString()}   $key');
  //   if (action != null) {
  //     var _result = action();
  //     if (_result is Future) {
  //       _result.then((_) {
  //         _rebuild();
  //       });
  //     } else {
  //       _rebuild();
  //     }
  //     return;
  //   }

  //   _rebuild(); //注意这里是异步函数
  //   return;
  // }
  //action最终返回同类型的值，用来更改map中的值？然而map中明显的是使用实例做指针？？
  //这里我们假设action不返回新的model，涉及到返回的情况我们之后再处理

  void dispatch<T>([String? key]) {
    //注意，这里aspectId不能为空
    aspectId = key == null ? T.toString() : key;
    _rebuild(); //注意这里是异步函数
    return;
  }

  @override
  Widget build(BuildContext context) {
    //注意aspectId首次构建时可能为null，只有dispatch后才会有值，这里是否会触发异常？
    return new _InheritedStore(child: widget.child, aspectId: aspectId);
  }
}

class _InheritedStore extends InheritedModel<Object> {
  _InheritedStore({Key? key, required Widget child, this.aspectId})
      : super(key: key, child: child);
  final String? aspectId;

  @override
  bool updateShouldNotify(_InheritedStore oldWidget) {
    return true;
  }

  @override
  bool updateShouldNotifyDependent(
      InheritedModel<dynamic> oldWidget, Set<dynamic> dependencies) {
    //print('dependencies=${dependencies.first.toString()}');
    if (aspectId == null) {
      //首次构建时会是null，今后任何时候都由dispatch赋予
      print('aspectid=null');
      return false;
    }

    //问题出在这里，container始终返回false...
    bool result = dependencies.contains(aspectId); //注意这个覆盖的函数是两个动态的参数
    return result;
    //return true;
  }
}
