
## 0.5.4_2002.10.10
1. fix bug: retry return future.error,not rethrow,so it will be caughted by future builder

## 0.5.3 _2022.10.10
1. fix bug:runAsync worked with null checked error
1. rename runAsync to retry
1. add test for retry

## 0.5.2 _2022.10.9
1. fix bug: late error in withAsync,_build should be inited
## 0.5.1 _2022.10.8
1. add builder argument for WithAsync
## 0.5.0 _2022.10.7
1. fix bug: check _store[T]!.others![key] in register,should throw when key is registed
1. add a get store
1. remove export Store
1. if there is a initState function in model,it will be worked in register,this usually used for auto load,so it could be a future
1. add WithFuture widget
1. add async initState for Provider
1. add retry_async for timeout,wait and retry
1. add for async initState, and use futureBuilder for it
1. add example for initState,seconds now register here
1. futureBuilder run only once so we can run initState only once 


## 0.4.1 _2022.10.7
1. export Store

## 0.4.0 _2022.10.3
1. dispatch now used without action
1. remove dipose function,try dipose if exist in model
1. use _rebuild instead of setState
1. remove mixin 
1. return future.error in model to future builder
1. use Type as key in map,instead instance
1. support multi instance,by string key

## 0.3.3 - 2021.11.10
1. remove iconnect,use Builder widget instead
1. fix bug in example,register should have an argument
## 0.3.2 -2021.9.7
1. some changes in readme.md
## 0.3.0 -2021.9.7
. use mixin instead with function,now we only have connect,provider and IConnect mixin
. now could simple use register in model itself 

## [0.2.0] - 2021.6.24
. upgrade flutter
. change dynamic? to dynamic

## [0.1.0-dev.1] - 2021.1.25
. register model 
. unregester model with dispose argument
. use a model will not rerender widget,only when you listen to is,for example,in counter example,ShowAddButton widget will never rerender,it just use the increment function in Counter model.
. share model in multi widgets
. support multi models with same type
. dispatch to widget that listen to model
. listen to a model,widget will rerender after dispatch from that model
. could work with futuer and handle exception
. could work with stream


