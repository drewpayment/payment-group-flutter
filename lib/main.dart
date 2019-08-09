import 'package:catcher/catcher_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pay_track/bloc/location_bloc.dart';
import 'package:pay_track/data/geocoding_service.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/pages/login_page.dart';
import 'package:pay_track/services/auth.dart';
import 'package:pay_track/theme.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'router.dart';

class MyApp extends StatelessWidget {

  MyApp() {
    var container = kiwi.Container();
    var config = container.resolve<ConfigModel>();
    HttpClient.init(config.api);

    Auth.restoreStorage();
    locationBloc.init();

    container.registerInstance(GeocodingService());
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Catcher.navigatorKey,
      title: 'Flutter',
      theme: buildTheme(),
      home: FutureBuilder(
        future: Auth.hasTokenAuthentication(),
        builder: (context, AsyncSnapshot<bool> snap) {
          if (snap.hasData && snap.data) return HomePage();
          return LoginPage();
        }
      ),
      routes: Router.routes,
    );
    
  }
}


