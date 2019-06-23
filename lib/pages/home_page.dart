import 'package:flutter/material.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/bloc/route_bloc.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/add_contact.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/pages/login_page.dart';
import 'package:pay_track/pages/map_page.dart';
import 'package:pay_track/services/auth.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // static const String title = 'Locale.Marketing';
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
  int _selectedNavigationItem = 0;

  @override
  BuildContext get context;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

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

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return ScopedModelDescendant<ConfigModel>(
      builder: (context, child, model) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(
            title: Text('${model.appName}'),
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
          // bottomNavigationBar: Auth.isSignedIn() 
          //   ? StreamBuilder(
          //     initialData: null,
          //     stream: routeBloc.selectedRoute,
          //     builder: (context, AsyncSnapshot<int> snap) {
          //       if (snap.hasData) {
          //         return CustomBottomNav(
          //           items: HomePage.bottomNavItems,
          //           currentIndex: snap.data,
          //           onTap: _onNavigationBarTap,
          //         );
          //       } else {
          //         return Container();
          //       }
          //     }
          //   )  
          //   : null,
        );
      },
    );
  }

  // _onNavigationBarTap(int index) {
  //   print('Tapped number $index');
  //   setState(() {
  //     _selectedNavigationItem = index;
  //   });

  //   if (_selectedNavigationItem == 1) {
  //     Navigator.pushNamed(context, MapPage.routeName);
  //   }
  // }

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
                print('We are going to navigate to the create a contact page');
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
                print('Navigate to page to manage existing contacts');
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
