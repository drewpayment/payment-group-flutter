import 'package:flutter/material.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/pages/map_page.dart';
import 'package:pay_track/pages/register_page.dart';
import 'package:pay_track/theme.dart';

/// removed to use flavor-based main_<env>.dart launch points
// void main() {
//     // runApp(MyApp());

    
// }

class MyApp extends StatelessWidget {

  static const String defaultTitle = 'GeoKnock';

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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


