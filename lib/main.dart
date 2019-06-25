import 'package:catcher/catcher_plugin.dart';
import 'package:flutter/material.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/add_contact.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/pages/login_page.dart';
import 'package:pay_track/pages/manage_contacts.dart';
import 'package:pay_track/pages/map_page.dart';
import 'package:pay_track/services/auth.dart';
import 'package:pay_track/theme.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class MyApp extends StatelessWidget {

  MyApp() {
    var container = kiwi.Container();
    var config = container.resolve<ConfigModel>();
    HttpClient.init(config.api);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Catcher.navigatorKey,
      title: 'Flutter Demo',
      theme: buildTheme(),
      home: Auth.isSignedIn() ? HomePage() : LoginPage(),
      routes: <String, WidgetBuilder>{
        HomePage.routeName: (BuildContext context) => HomePage(),
        MapPage.routeName: (BuildContext context) => MapPage(),
        LoginPage.routeName: (BuildContext context) => LoginPage(),
        AddContactPage.routeName: (BuildContext context) => AddContactPage(),
        ManageContacts.routeName: (BuildContext context) => ManageContacts(),
      },
    );
  }
}


