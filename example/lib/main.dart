import 'package:flutter/material.dart';
import 'package:iconnect/iconnect.dart';
import 'package:example/app/app.dart';

import 'app/init_store.dart';

void main() {
  runApp(provider(const MyApp(), initState));
}
