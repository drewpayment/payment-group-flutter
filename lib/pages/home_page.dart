import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/bloc/route_bloc.dart';
import 'package:pay_track/bloc/weather_bloc.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/models/current_weather.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/pages/login_page.dart';
import 'package:pay_track/pages/manage_contacts.dart';
import 'package:pay_track/pages/map_page.dart';
import 'package:pay_track/services/auth.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:pay_track/widgets/static_map_provider.dart';

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
  Stream<CurrentWeather> weatherStream;

  @override
  BuildContext get context => super.context;

  @override
  void initState() {
    super.initState();
    config = container.resolve<ConfigModel>();

    /// listen for changed to authenticated state in auth service
    Auth.isAuthenticated.listen((signedIn) {
      if (signedIn) {
        bloc.fetchAllKnocks();
        weatherStream = weatherBloc.stream;
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
    var welcomeMsg = Auth.user != null ? 'Hello ${Auth.user?.firstName}!' : 'Hello!';
    return Center(
      heightFactor: 1.3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder(
            initialData: null,
            stream: weatherStream,
            builder: (context, AsyncSnapshot<CurrentWeather> snap) {
              if (snap.hasData) {
                final weather = snap.data;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.network(weather.conditionIcon,
                      width: 50,
                      height: 50,
                    ),
                  ],
                );
              }

              return Container();
            }
          ),
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
                  child: Text('$welcomeMsg',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                _getMapButton(),
              ]..add(_getButtonBarButtons()),
            ),
          ),
        ],
      )
    );
  }

  Widget _getButtonBarButtons() {
    var buttons = <Widget>[];

    if ((Auth.user?.userRole?.role ?? 0) > 5) {
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

    // buttons.add(RaisedButton(
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    //   padding: EdgeInsets.all(12.0),
    //   child: Row(
    //     mainAxisSize: MainAxisSize.min,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: <Widget>[
    //       Text('Go to Map'),
    //       Icon(Icons.map),
    //     ],
    //   ),
    //   textColor: Colors.white,
    //   onPressed: () {
    //     Navigator.pushNamed(context, MapPage.routeName);
    //   },
    // ));

    return ButtonTheme.bar(
      child: ButtonBar(
        alignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: buttons,
      ),
    );
  }

  Widget _getMapButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, MapPage.routeName);
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              borderOnForeground: true,
              child: Opacity(
                opacity: 0.5,
                child: StaticMapProvider(height: 100, width: 125),
              ),
              clipBehavior: Clip.hardEdge,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 5, right: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // Text('GO TO MAP',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.bold,
                  //     fontSize: 18,
                  //     color: Colors.black54,
                  //   )
                  // ),
                  Icon(Icons.arrow_forward,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeBloc.dispose();
    super.dispose();
  }

}
