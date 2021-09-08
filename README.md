# iconnect


## how to use
1. add package iconnect in pubspec.yaml
iconnect:
then import iconnect in our code files:
import 'package:iconnect/iconnect.dart';

1. define a simple class as model
class CounterModel {
  int value = 0;
  CounterModel(value) {
    this.value = value;
  }
  increment(int step) {
    value = value + step;
    return value;
  }
}

1. create one or multi instance
CounterModel _first=CounterModel(0);
get first=>register(_first);
CounterModel _second=CounterModel(0);
get second=>register(_second);


1. provider: use it only one times,all model will saved here
void main() {
  runApp(provider(MyApp()));
}

1. connect and listen:if model changed by dispatch,it will rebuild
Widget showCounter() {
  return connect((context) {
    print('ShowCounter build ');
    listen(context, first);
    return ShowCounterOrigin(value: first.value);
  });
}
    


1. dispatch
class ShowButtonOrigin extends StatelessWidget {
  ShowButtonOrigin({Key? key, this.increase}) : super(key: key);
  final VoidCallback? increase;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: increase,
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }
}

//it won't be rebuild when dispatch(first),because we have not listen first here
class ShowButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShowButtonOrigin(
        increase: () => dispacth(first,() => first.increment(1)));
  }
}

## we also could define model with mixin IConnect
class CounterModel with IConnect {
  int value = 0;
  CounterModel(value) {
    this.value = value;

    //we could register here
    register();
  }
  increment(int step) {
    value = value + step;
    return value;
  }
}
then we could
1. simply create instance
CounterModel first = new CounterModel(0);
CounterModel second = new CounterModel(0);
1. use listen,dispatch,register,unregister in model
first.listen()
first.dispatch()
1. and we don't need to import iconnect any where


## what's iconnect?
The simplest and fast library for state mamagement,it only handle the shared model for widgets,it's null-safe, and support for all the pllatform.
you don't need those huge framework like provider and redux and flutter hook,they think too many things :D
but they solved the simple thing with many many concept and codes.
. can create multi instance for a model
. when model changed,only widget listen to it will rebuild 
. only provider and connect function for whole 
. could define model with mixin IConnect
. could use listen,dispatch,register,unregister function,then model is a simply class
. if you define a dispose method in model,it will run when unregister.
 


## six function and zero concept,that's connect
we only connect models to widget tree all the api of connect is six simple functiuon ,that's all:
provider/connect
register/unregister
dispatch/listen

## provider is a function to init the app,so all model could work with widget tree.
you just use it one times in an app.

## define model for itself,without any rule,we only connect it with widget tree
 it's not based on type,you define a model only for the itself.the model is a class you just create,without any rule,with out base class or interface.
 we use model as instance,not for type,so we could simplely add multi instance for same model type.
 you could simple use register and unregister,to add or remove model.you could use registed model as a class instance in your widget,that's mean widget will not rerender.you should listen to a registed model,when it dispatch changes event,your widget will rerender.

## design ui only for itself,without any rule,you don't need to know connect
  connect function return a widget,you must provide a function with build function,you could use model or listen to model there.

## without any concept about async model,we should only do single things here for models
  it could worked with future and stream in your models,listen and dispatch could update the ui simply.

## get starter
you could find the usage in example folder,it's a simple counter app,it's a demo for:
. how to define a model and register it
. how to dispatch and listen
. how to work with future and AsyncSnapshot,and handle errors
. how to work with stream and update ui.
