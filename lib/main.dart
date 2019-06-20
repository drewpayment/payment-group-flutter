import 'package:catcher/catcher_plugin.dart';
import 'package:flutter/material.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/pages/login_page.dart';
import 'package:pay_track/pages/map_page.dart';
import 'package:pay_track/pages/register_page.dart';
import 'package:pay_track/services/auth.dart';
import 'package:pay_track/theme.dart';
import 'package:scoped_model/scoped_model.dart';

/// removed to use flavor-based main_<env>.dart launch points
// void main() {
//     // runApp(MyApp());

    
// }

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ConfigModel>(
      builder: (context, child, model) {
        HttpClient.init(model.api);
        return child;
      }, 
      child: MaterialApp(
        navigatorKey: Catcher.navigatorKey,
        title: 'Flutter Demo',
        theme: buildTheme(),
        home: Auth.isSignedIn() ? HomePage() : LoginPage(),
        routes: <String, WidgetBuilder>{
            HomePage.routeName: (BuildContext context) => HomePage(),
            RegisterPage.routeName: (BuildContext context) => RegisterPage(),
            MapPage.routeName: (BuildContext context) => MapPage(),
            LoginPage.routeName: (BuildContext context) => LoginPage(),
        },
      ),
      rebuildOnChange: false,
    );
  }
}


