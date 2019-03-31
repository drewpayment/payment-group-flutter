import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/pages/register_page.dart';

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
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.white,
        scaffoldBackgroundColor: Colors.white
      ),
      home: HomePage(title: 'Pay Track'),
      routes: <String, WidgetBuilder>{
          RegisterPage.routeName: (BuildContext context) => RegisterPage(),
      },
    );
  }
}


