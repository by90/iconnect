import 'package:flutter/material.dart';

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

  void dispatch(dynamic model, [Function? action]) {
    aspectId = model;
    if (action != null) {
      var _result = action();
      setState(() => false);
      return _result;
    }
    setState(() => false);
    return null;
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
