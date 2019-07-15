import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/bloc/route_bloc.dart';
import 'package:pay_track/bloc/user_bloc.dart';
import 'package:pay_track/bloc/weather_bloc.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/models/current_weather.dart';
import 'package:pay_track/models/user.dart';
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
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/houses.png'),
              alignment: Alignment.bottomCenter,
            ),
          ),
          child: _getSignedInBody(),
        ),
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
      physics: ScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      child: Column(
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
            margin: EdgeInsets.only(top: 8),
            // elevation: 8.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
    final textStyle = TextStyle(
      fontSize: 58,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return StreamBuilder(
      initialData: null,
      stream: userBloc.stream,
      builder: (context, AsyncSnapshot<User> snap) {
        if (snap.hasData) {
          final user = snap.data;
          final role = user.userRole.role;

          if (role > 5) {
            return Container(
              color: Theme.of(context).accentColor,
              child: InkWell(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('C', style: textStyle.copyWith(fontWeight: FontWeight.w400)),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      color: Theme.of(context).accentColor,
                      child: Center(
                        child: Icon(Icons.person_pin,
                          size: 60,
                          color: Colors.white,
                        )
                      ),
                    ),
                    Text('NTACTS', style: textStyle.copyWith(fontWeight: FontWeight.w400)),
                    Icon(Icons.arrow_forward, size: 58, color: Colors.white),
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, ManageContacts.routeName);
                },
              ),
              margin: EdgeInsets.symmetric(vertical: 8),
            );
          } 
        }

        return Container(
          margin: EdgeInsets.only(top: 8),
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('Those who have confidence in themselves gain the confidence of others.',
                softWrap: true,
                style: textStyle.copyWith(
                  fontSize: 24,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w200,
                  wordSpacing: 1.2,
                  letterSpacing: 1.2,
                  fontFamily: 'JustAnotherHand',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _getMapButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, MapPage.routeName);
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          StaticMapProvider(),
          Padding(
            padding: EdgeInsets.only(bottom: 5, right: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'dasfdja;sdjfa',
                  child: Icon(Icons.arrow_forward,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, MapPage.routeName);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    routeBloc.dispose();
    super.dispose();
  }

}
