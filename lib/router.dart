import 'package:flutter/material.dart';

import 'pages/add_contact.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/manage_contacts.dart';
import 'pages/map_page.dart';

class Router {


  static Map<String, Widget Function(BuildContext)> get routes => <String, WidgetBuilder>{
    HomePage.routeName: (BuildContext context) => HomePage(),
    MapPage.routeName: (BuildContext context) => MapPage(),
    LoginPage.routeName: (BuildContext context) => LoginPage(),
    AddContactPage.routeName: (BuildContext context) => AddContactPage(),
    ManageContacts.routeName: (BuildContext context) => ManageContacts(),
  };

}

/// Router arguments

class MapPageRouterParams {
  int dncContactId;
  double lat;
  double lng;

  MapPageRouterParams(
    this.dncContactId,
    this.lat,
    this.lng
  );
}