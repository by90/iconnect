
## bloc简单的例子：
https://github.com/Ayusch/Flutter-Bloc-Pattern 
provider只是一个inheritedWidget，它甚至不更新
bloc包括一个streamConttroller，里面基本使用sink.add发送信号，并更改内部变量
ui中使用的bloc内部成员，必须通过stream来监听。
事件通过sink.add发出，只有监听该stream的部件才会响应。
整个过程中并无手工的监听过程。

## 首先，基于store存放bloc，不需要inheritedmodel
  因为它本来将不更新
  其次，获取某个bloc，可从map取得
  使用时均基于streamcontroller，只有sink.add触发变更。
  从简化而言，useStream这类语法或更为清晰。(

## 因此应如此使用：
1. 单一的bloc provider，可考虑自动载入部分实例
2. bloc.add()增加bloc，remove则删除blob，这样有利于一个页面dispose
3. 任何时候，均useStream这种方式来处理，这样其实也是将逻辑带入了ui....我们其实只要获得对应的stream？或者所有对象使用单一的stream？

