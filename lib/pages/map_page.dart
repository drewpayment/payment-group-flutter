
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pay_track/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
    const MapPage({Key key}) : super(key: key);

    static const String routeName = '/map'; 

    @override
    _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
    Completer<GoogleMapController> _controller = Completer();

    static const LatLng _center = const LatLng(45.521563, -122.677433);

    _onMapCreated(GoogleMapController controller) {
      _controller.complete();
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text('Map'),
                elevation: 1.0,
            ),
            body: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
            ),
            drawer: new DrawerWidget(),
        );
    }

}