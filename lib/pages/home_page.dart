import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/bloc/route_bloc.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/pages/login_page.dart';
import 'package:pay_track/pages/manage_contacts.dart';
import 'package:pay_track/pages/map_page.dart';
import 'package:pay_track/services/auth.dart';
import 'package:kiwi/kiwi.dart' as kiwi;

class HomePage extends StatefulWidget {
  
  HomePage({Key key }) : super(key: key);
  static const String routeName = '/home';

  static const List<BottomNavigationBarItem> bottomNavItems = [BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ), BottomNavigationBarItem(
      icon: Icon(Icons.map),
      title: Text('Map'),
    )
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final _androidAppRetain = MethodChannel('android_app_retain');
  BoxDecoration headerStyle;
  List<Widget> drawerOptions;
  kiwi.Container container = kiwi.Container();
  ConfigModel config;

  _HomePageState() {
    config = container.resolve<ConfigModel>();
  }

  @override
  BuildContext get context => super.context;

  @override
  void initState() {
    super.initState();

    // if (Platform.isAndroid) {
    //   _androidAppRetain.invokeMethod("wasActivityKilled").then((result) {
    //     if (result) {
    //       showDialog(
    //         context: context,
    //         builder: (context) {
    //           return AlertDialog(

    //           );
    //         },
    //       );
    //     }
    //   });
    // }

    /// listen for changed to authenticated state in auth service
    Auth.isAuthenticated.listen((signedIn) {
      if (signedIn) {
        bloc.fetchAllKnocks();
      } 
    });
  }

  @override
  Widget build(BuildContext context) {
    headerStyle = BoxDecoration(
      color: Colors.cyan[400],
    );

    return WillPopScope(
      onWillPop: () {
        if (Platform.isAndroid) {
          if (Navigator.of(context).canPop()) {
            return Future.value(true);
          } else {
            _androidAppRetain.invokeMethod("sendToBackground");
            return Future.value(false);
          }
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.45),
        appBar: CustomAppBar(
          title: Text('${config.appName}'),
        ),
        body: _getSignedInBody(),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.exit_to_app),
          label: Text('Sign Out'),
          onPressed: () {
            Auth.signOut().then((isSignedOut) {
              if (isSignedOut) {
                Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, ModalRoute.withName('/'));
              }
            });
          },
        ),
      ),
    );
  }

  Widget _getSignedInBody() {
    return Center(
      heightFactor: 1.3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(16.0),
            elevation: 8.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Center(
                    child: Text('WELCOME',
                      style: TextStyle(
                        fontFamily: 'Rockwell',
                        fontSize: 36,
                        letterSpacing: 2.0,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  // width: MediaQuery.of(context).size.width,
                  // child: Image.asset(
                  //   'assets/undraw_settings_ii2j.png',
                  //   height: 200,
                  // ),
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('https://api.adorable.io/avatars/140/abott@adorable.png'),
                    radius: 70,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text('Hello ${Auth.user.firstName}!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: Text('Thanks for participating in our open beta. Please don\'t hesitate to share your feedback.\nOh yeah, ' +
                   '"posit" means to put in position; place.',
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]..add(_getButtonBarButtons()),
            ),
          ),
        ],
      )
    );
  }

  Widget _getButtonBarButtons() {
    var buttons = <Widget>[];

    if (Auth.user.userRole.role > 5) {
      buttons.add(RaisedButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        padding: EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Manage Restricts'),
            Icon(Icons.code)
          ],
        ),
        textColor: Colors.white,
        onPressed: () {
          Navigator.pushNamed(context, ManageContacts.routeName);
        },
      ));
    }

    buttons.add(RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      padding: EdgeInsets.all(12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Go to Map'),
          Icon(Icons.map),
        ],
      ),
      textColor: Colors.white,
      onPressed: () {
        Navigator.pushNamed(context, MapPage.routeName);
      },
    ));

    return ButtonTheme.bar(
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: buttons,
      ),
    );
  }

  @override
  void dispose() {
    routeBloc.dispose();
    super.dispose();
  }

}
