import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/pages/map_page.dart';
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

  static const String defaultTitle = 'GeoKnock';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    HttpClient.init();
    return MaterialApp(
      title: 'Flutter Demo',
      theme: buildTheme(),
      home: HomePage(),
      routes: <String, WidgetBuilder>{
          HomePage.routeName: (BuildContext context) => HomePage(),
          RegisterPage.routeName: (BuildContext context) => RegisterPage(),
          MapPage.routeName: (BuildContext context) => MapPage(),
      },
    );
  }
}


