import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/pages/register_page.dart';
import 'package:pay_track/theme.dart';

void main() {
    runApp(MyApp());

    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarDividerColor: Colors.black,
            systemNavigationBarIconBrightness: Brightness.dark,
        ),
    );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: buildTheme(),
      home: HomePage(title: 'Pay Track'),
      routes: <String, WidgetBuilder>{
          RegisterPage.routeName: (BuildContext context) => RegisterPage(),
      },
    );
  }
}


