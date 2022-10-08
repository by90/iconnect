import 'dart:async';
import 'dart:convert';

import 'dart:io'; //暂时使用dart:io版本的http客户端

//import 'dart:math' as math;

/// 问题！！！：这里是重试前等待！这个实际上是没意义的，应该是执行future，不超时且返回值不为null等待
/// 因为如果出错，重试前等待毫无意义
/// 运行异步函数，考虑timeout、重试、重试前等待。
/// 暂时未处理超时后中断请求
/// 暂时未处理人工中断，一般是对每个任务设计一个全局的bool标记，默认为false，若为true则在下一环节里跳出
/// 暂时未处理重入，可在外部处理
Future<T?> runAsync<T>(
  Future<T?> Function() future, {
  Iterable<int>? timeouts,

  //每次执行future前等待的时间
  Iterable<int>? delays, //毫秒为单位
  //抛弃：每个步骤重试前的等待时间，如果是单个，长度少于重试次数，则每个相同

  int timeout = 8, //超时设置为8秒
  int retries = 3,
  bool Function(T) when = _defaultWhen,
  bool Function(Object, StackTrace) whenError = _defaultWhenError,
  //Duration Function(int retryCount) delay = _defaultDelay,//一般只有5个，用数组足够了
  void Function<T>(T? result, int retryCount)? onRetry,
}) async {
  var _onRetry = onRetry;
  _onRetry ??= _defaultOnRetry; //如果_onRetry没有提供，则使用默认的

  List<int>? _delays;
  if (delays != null &&
      retries > 0 &&
      (delays.length == retries || delays.length == 1)) {
    if (delays.length == 1) {
      _delays = List.filled(retries, delays.first);
    } else {
      _delays = delays.toList();
    }
  } else {
    _delays = null;
  }

  List<int>? _timeouts;
  if (timeouts != null &&
      retries > 0 &&
      (timeouts.length == retries || timeouts.length == 1)) {
    if (timeouts.length == 1) {
      _timeouts = List.filled(retries, timeouts.first);
    } else {
      _timeouts = timeouts.toList();
    }
  } else {
    _timeouts = null;
  }

  var i = 0;
  for (;;) {
    T? response;
    try {
      //执行future前等待，而非重试前等待
      if (_delays != null) {
        await Future.delayed(Duration(milliseconds: _delays[i]));
      }
      if (_timeouts!.isNotEmpty) {
        response = await future().timeout(Duration(milliseconds: _timeouts[i]));
      } else {
        response = await future();
      }
    } catch (error, stackTrace) {
      //触发异常的时候，如果没有到重试的次数，或者_whenError返回假，重新抛出异常
      //这意味着重试时候，多数情况下异常吃掉，最后一次是否吃掉取决于_whenError的结果是否为真
      //所以默认的_whenError返回假
      if (i == retries || !whenError(error, stackTrace)) rethrow;
    }

    //此时已经运行完成，得到了结果或者null，无需等待，返回结果！
    if (response != null) {
      if (i == retries || !when(response)) return response;
    }

    //如果需要等待100毫秒之类，避免冲击服务器，在_onRetry处理即可。
    //那么直接开始重试就行了，为啥等待？
    // if (_delays != null) {
    //   await Future.delayed(Duration(milliseconds: _delays[i]));
    // }

    _onRetry.call(response, i);
    i++;
  }
}

bool _defaultWhen(response) => false;
void _defaultOnRetry<T>(T? result, int retryCount) {}
bool _defaultWhenError(Object error, StackTrace stackTrace) => false;

// Duration _defaultDelay(int retryCount) =>const Duration(milliseconds: 500) * math.pow(1.5, retryCount);
///我们这样的例子，即切换到ssid setWifi('ssid')，然后判断是否成功,getCutrrentSSid()==ssid才是正常
///前面的操作，事前无需等待，事后也无需等待，只需要处理超时....后面检查前，不一定能get到正确的ssid，需要分片等待、重试
//所以...执行future前等待，这是正常的。

// 函数getHttp,然后retry它
//返回的是正常wifi则成功连接
//返回null表示失败

//返回类型为T
//T必须有fromJson这类语法

//以前这里由于url最后一位为?，自动转换成%23这样形式，导致无法识别
//但第一可以path，然后设置起止位置
//第二可以
Future<T?> getHttp<T>(String url) async {
  var httpClient = HttpClient();
  dynamic result;
  HttpClientRequest? request;
  Uri? uri;

  try {
    uri = Uri.parse(url);
  } catch (e) {
    print('$e');
    //吃掉异常?
    //rethrow; //如果rethrow，则uri不可能等于null？
  }
  if (uri == null) return null;
  print('uri is ${uri.toString()}');

  try {
    request = await httpClient.getUrl(uri);
    var value = await request.close(); //close时才得到结果

    if (value.statusCode == HttpStatus.ok) {
      var json = await value.transform(utf8.decoder).join();
      result = jsonDecode(json);
    } else {
      print('statuscode=${value.statusCode}');
      result = null;
    }
  } catch (e) {
    if (e is TimeoutException) {
      //这里是request close之前
      request!.abort();
    }
  }

  return result;
}

Future<T?> getRest<T>(
  Future<T?> Function() future, {
  Iterable<int>? timeouts,

  //每次执行future前等待的时间
  Iterable<int>? delays, //毫秒为单位
  //抛弃：每个步骤重试前的等待时间，如果是单个，长度少于重试次数，则每个相同

  int timeout = 8, //超时设置为8秒
  int retries = 3,
  bool Function(T) when = _defaultWhen,
  bool Function(Object, StackTrace) whenError = _defaultWhenError,
  //Duration Function(int retryCount) delay = _defaultDelay,//一般只有5个，用数组足够了
  void Function<T>(T? result, int retryCount)? onRetry,
}) {
  return Future<T>.value(null);
}

// 不需要？传递toJson和fromJson即可。
// typedef ItemCreator<S> = S Function();
// T? fromJson<T>(Map<String, dynamic> json) {
//   Type t = T.runtimeType;
//   var value = _fromJson<T>(t, json);
//   return value;
// }

// T? _fromJson<T>(json) {
//   ItemCreator<T> creator;

//   T obj=creator() ;
//   T? value;
//   try {
//     value = obj .fromJson(json);
//   } catch (e) {
//     print('_fromJson:e=${e.toString()}');
//     return null;
//   }
//   return value;
// }

// _toJson<T>() {}
