import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/pages/custom_bottom_nav.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/utils/color_list_tile.dart';
import 'package:pay_track/widgets/google_map.dart';
import 'package:pay_track/widgets/map_list.dart';
import 'package:scoped_model/scoped_model.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  static const String routeName = '/map';

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  var _selectedNavigationItem = 1;

  @override
  void initState() {
    super.initState();
    bloc.fetchAllKnocks();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.knocksStream,
      builder: (context, AsyncSnapshot<List<Knock>> snapshot) {
        Widget body;
        if ((snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active) 
          && snapshot.hasData) {
          print('GOT SOMETHING ON MAP_PAGE.DART');
          body = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              GoogleMapWidget(bloc),
              MapListWidget(bloc),
            ],
          );
        } else {
          print('Never got anything back on the map_page.dart');
          body = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
            ],
          );
        }
        
        return _compileWidgets(body);
      }
    );
  }

  Widget _compileWidgets(Widget body) {
    return ScopedModelDescendant<ConfigModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: CustomAppBar(title: Text('${model.appName}')),
          body: body,
          bottomNavigationBar: CustomBottomNav(
            items: HomePage.bottomNavItems,
            currentIndex: _selectedNavigationItem,
            onTap: _onNavigationBarTap,
          ),
        );
      },
    );
  }

  _onNavigationBarTap(int index) {
    print('Tapped number $index');
    setState(() {
      _selectedNavigationItem = index;
    });

    if (_selectedNavigationItem == 0) {
      Navigator.pushReplacementNamed(context, HomePage.routeName);
    }
  }

}