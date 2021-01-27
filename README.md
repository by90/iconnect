# iconnect

## what's iconnect?
The simplest and fast library for state mamagement,it only handle the shared model for widgets,it's null-safe, and support for all the pllatform,so it based on flutter dev channel.
you don't need those huge framework like provider and redux and flutter hook,they think too many things :D
but they solved the simple thing with many many concept and codes.


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
