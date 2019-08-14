import 'package:flutter/material.dart';
import 'pages/add_contact.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/manage_contacts.dart';
import 'pages/map_page.dart';

class Router {


  static Map<String, Widget Function(BuildContext)> get routes => <String, WidgetBuilder>{
    HomePage.routeName: (_) => HomePage(),
    MapPage.routeName: (_) => MapPage(),
    LoginPage.routeName: (_) => LoginPage(),
    AddContactPage.routeName: (_) => AddContactPage(),
    ManageContacts.routeName: (_) => ManageContacts(),
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