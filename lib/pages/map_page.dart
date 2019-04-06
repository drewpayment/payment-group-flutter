
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
            body: GridView.count(
              primary: false,
              padding: EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 1,
              children: <Widget>[
                GoogleMap(
                  zoomGesturesEnabled: true,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                ),
                ListView.separated(
                  scrollDirection: Axis.vertical,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.cyan
                  ),
                  itemCount: 2,
                  itemBuilder: (context, index) => ListTile(
                    leading: Icon(Icons.assignment_late),
                    title: Text('4038 Zion Ct SE'),
                    onTap: () {
                      print('This needs to drop a pin on the map.');
                    },
                  ),
                ),
              ],
            ),
            drawer: new DrawerWidget(),
        );
    }

}