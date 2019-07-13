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
import 'package:pay_track/widgets/weather.dart';

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
        weatherBloc.fetchWeather();
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder(
            initialData: null,
            stream: weatherBloc.stream,
            builder: (context, AsyncSnapshot<Weather> snap) {
              if (snap.hasData && snap.data != null && snap.data.current?.condition != null) {
                final weather = snap.data;
                return WeatherSummary(weather);
              }

              return Container();
            }
          ),
          Container(
            margin: EdgeInsets.only(top: 16),
            // elevation: 8.0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _getMapButton(),
              ]..add(_getAdminButton()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAdminButton() {
    if ((Auth.user?.userRole?.role ?? 0) > 5) {
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        child: Card(
          margin: EdgeInsets.all(30),
          color: Theme.of(context).accentColor,
          child: Center(
            child: Icon(Icons.person_pin,
              size: 70,
              color: Colors.white,
            )
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, ManageContacts.routeName);
        }
      );
    }
    return Container();
  }

  Widget _getButtonBarButtons() {
    var buttons = <Widget>[];

    if ((Auth.user?.userRole?.role ?? 0) > 5) {
      // buttons.add(RaisedButton(
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      //   padding: EdgeInsets.all(12.0),
      //   child: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: <Widget>[
      //       Text('Manage Restricts'),
      //       Icon(Icons.code)
      //     ],
      //   ),
      //   textColor: Colors.white,
      //   onPressed: () {
      //     Navigator.pushNamed(context, ManageContacts.routeName);
      //   },
      // ));

      buttons.add(IconButton(
        icon: Icon(Icons.person_pin, size: 70),
        onPressed: () {
          Navigator.pushNamed(context, ManageContacts.routeName);
        },
        color: Colors.white,
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
        mainAxisSize: MainAxisSize.min,
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
