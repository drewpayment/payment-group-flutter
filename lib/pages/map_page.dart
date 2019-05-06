import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pay_track/auth/auth.dart';
import 'package:pay_track/data/repository.dart';
import 'package:pay_track/models/Knock.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  static const String routeName = '/map';

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // Completer<GoogleMapController> _controller = Completer();

  LatLng _center = new LatLng(42.8900285, -85.584401);
  var location = new Location();
  List<Knock> contacts;
  LocationData userLocation;
  Future<LocationData> userLocationContract;
  GoogleMapController _controller;

  // put the list of "do not knock" locations in this list
  var markers = new Set<Marker>();
  var widgets = <Widget>[];

  _onMapCreated(GoogleMapController controller) {
    // _controller.complete();
    // do things after the map has shown up... might be a good place to wire up events showing/hiding markers
    _controller = controller;
  }

  @override
  void initState() {
    super.initState();
    userLocationContract = initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Repository.get().getKnocks(),
      builder: (BuildContext context, AsyncSnapshot<ParsedResponse<List<Knock>>> snapshot) {
        Widget body;

        if (snapshot.hasData && snapshot.data.isOk()) {
          contacts = snapshot.data.body;

          _handleApiResponseAndBuildWidgets();

          body = GridView.count(
            primary: false,
            padding: EdgeInsets.all(20.0),
            crossAxisSpacing: 10.0,
            crossAxisCount: 1,
            children: widgets,
          );
        } else {
          body = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: new CircularProgressIndicator()
              ),
            ],
          );

          // the API returned an error code, most likely related to the user being unauthenticated
          if (snapshot.hasData && !snapshot.data.isOk()) {
            Auth.signOut();
          }
        }

        return new Scaffold(
          body: body,
        );
      }
    );
  }

  void _handleApiResponseAndBuildWidgets() {
    if (contacts.length > 0) {
      markers.addAll(contacts.map((c) {
        var desc = c.firstName != null ? '${c.firstName} ${c.lastName}' : '${c.description}';

        return Marker(
          markerId: MarkerId(c.dncContactId.toString()),
          draggable: false,
          visible: true,
          position: LatLng(c.lat, c.long),
          infoWindow: InfoWindow(
            title: '${c.address}',
            snippet: '$desc',
          ),
        );
      }));
    }

    if (_center == null) {
      widgets.add(new Center(
        child: Text('Please enable Location Services.'),
      ));
    } else {
      widgets.add(GoogleMap(
        zoomGesturesEnabled: true,
        myLocationEnabled: true,
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 16.0,
        ),
        markers: markers,
        compassEnabled: true,
      ));
    }

    if (contacts.length > 0) {
      widgets.add(ListView.separated(
        padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => Divider(color: Colors.black54),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          var color = Colors.transparent;

          return Container(
            color: color,
            child: ListTile(
              leading: Icon(Icons.assignment_late),
              title: Text(contacts[index].address),
              onTap: () {
                var con = contacts[index];
                _controller.moveCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: LatLng(con.lat, con.long),
                    zoom: 18.0,
                  )
                ));

                setState(() {
                  color = Colors.red;
                });
              },
              selected: false,
            ),
          );
        }
      ));
    } else {
      widgets.add(AlertDialog(
        title: Text('Sorry...'),
        content: Text('Looks like you have been logged out. Please log back in to continue.'),
        actions: <Widget>[
          MaterialButton(
            child: Text('Login'),
            onPressed: () {
              Auth.signOut();
            },
          )
        ],
      ));
    }
  }

  Future<LocationData> initPlatformState() async {
    Future<LocationData> userLocationContract;

    try {
      userLocationContract = location.getLocation();
    } on PlatformException catch(e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission Denied.');
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        print('Permission denied - please ask the user to enable it from the app settings');
      }
    }

    return userLocationContract;
  }

}