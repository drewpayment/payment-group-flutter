import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_track/main.dart';
import 'package:pay_track/models/config.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  // SystemChrome.setSystemUIOverlayStyle(
  //   const SystemUiOverlayStyle(
  //     statusBarColor: Colors.white,
  //     systemNavigationBarColor: Colors.white,
  //     systemNavigationBarDividerColor: Colors.black,
  //     systemNavigationBarIconBrightness: Brightness.dark,
  //   ),
  // );

  runApp(ScopedModel(
    model: ConfigModel(
      appName: 'Locale.Marketing',
      flavor: 'Production',
      api: 'https://verostack.dev/api',
    ),
    child: MyApp(),
  ));
}