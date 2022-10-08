import 'package:flutter/material.dart';

class WithAsync<T> extends StatefulWidget {
  final Future<void> Function() future;
  final Widget child;
  final Widget Function(BuildContext, AsyncSnapshot<dynamic>)? builder;

  const WithAsync(this.child, {Key? key, required this.future, this.builder})
      : super(key: key);

  @override
  _WithAsyncState<T> createState() => _WithAsyncState<T>();
}

class _WithAsyncState<T> extends State<WithAsync> {
  late final Future future; //这里是一个future，而非函数，是异步函数运行的结果
  late final Widget Function(BuildContext, AsyncSnapshot<dynamic>)? _builder;

  //  每次给state组件重新赋值，这意味着每次都不同？
  _WithAsyncState();
  @override
  void initState() {
    if (widget.builder != null) {
      _builder = widget.builder!;
    } else {
      _builder = null;
    }
    //bug:Field '_builder@45045263' has not been initialized.
    future = widget.future(); //在这里运行函数，就不会每次都刷新了，如果需要重试，则再次运行即可。
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: _builder != null
            ? _builder!
            : (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(child: CircularProgressIndicator());

                  // textDirection: TextDirection.ltr);
                }
                if (snapshot.hasError) {
                  //这里出现异常本应重新抛出，它是应该在开发阶段解决的...姑且显示在这里
                  return Center(
                      child: Text(snapshot.error.toString(),
                          textDirection: TextDirection.ltr)); //rtl无非是显示在屏幕右边
                }
                return widget.child;
              });
  }

  //如果重试，则执行这个
  // runFuture() {
  //   this.future = widget.future; //这里widget.future怎么变成了Future<dynamic>？
  //   //Future.delayed(Duration(seconds: 2), widget.future);
  //   setState(() {});
  // }
}
