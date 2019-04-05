
import 'package:flutter/material.dart';
import 'package:pay_track/drawer.dart';
// import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
    const MapPage({Key key}) : super(key: key);

    static const String routeName = '/map'; 

    @override
    _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {

    // Position position;

    _MapPageState() {
        // Geolocator().checkGeolocationPermissionStatus()
        //     .then((permission) {
        //         print(permission);
        //     });

        // Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        //     .then((res) {
        //         position = res;
        //     });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                centerTitle: true,
                title: Text('Map'),
                elevation: 1.0,
            ),
            body: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                        child: Center(
                            // child: Text(position?.longitude.toString()),
                        ),
                    ),
                ],
            ),
            drawer: DrawerWidget(),
        );
    }

}