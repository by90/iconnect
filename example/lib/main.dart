import 'package:flutter/material.dart';
import 'package:iconnect/iconnect.dart';
import 'package:example/app/app.dart';

import 'app/init_store.dart';

Future<void> main() async {
  // var result = await getHttp('http://100.120.5.1/wifi_info');
  // print(result.toString());
  runApp(provider(const MyApp(), initState));
}
