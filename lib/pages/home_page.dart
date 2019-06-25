import 'package:flutter/material.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/bloc/route_bloc.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/add_contact.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/pages/login_page.dart';
import 'package:pay_track/pages/manage_contacts.dart';
import 'package:pay_track/pages/map_page.dart';
import 'package:pay_track/services/auth.dart';
import 'package:scoped_model/scoped_model.dart';
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: Text('${config.appName}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Auth.signOut().then((isSignedOut) {
                if (isSignedOut) {
                  Navigator.pushNamedAndRemoveUntil(context, LoginPage.routeName, ModalRoute.withName('/'));
                }
              });
            },
          ),
        ],
      ),
      body: _getSignedInBody(),
    );
  }

  Widget _getSignedInBody() {
    return SingleChildScrollView(
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
                  width: MediaQuery.of(context).size.width,
                  child: Image.asset(
                    'assets/undraw_settings_ii2j.png',
                    height: 200,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person_outline),
                  dense: false,
                  title: Text('${Auth.user.firstName} ${Auth.user.lastName}'),
                  subtitle: Text('${Auth.user.email}'),
                ),
              ]..addAll(_getButtonBarButtons()),
            ),
          ),
        ],
      )
    );
  }

  List<Widget> _getButtonBarButtons() {
    var buttons = <Widget>[];

    if (Auth.user.userRole.role > 5) {
      buttons.add(ButtonTheme.bar(
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Add Restricts'),
                  Icon(Icons.add_circle)
                ],
              ),
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushNamed(context, AddContactPage.routeName);
              },
            ),
            RaisedButton(
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
            ),
          ],
        ),
      ));
    }

    buttons.add(ButtonTheme.bar(
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          RaisedButton(
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
          )
        ],
      ),
    ));

    return buttons;
  }

  @override
  void dispose() {
    routeBloc.dispose();
    super.dispose();
  }

}
