
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


