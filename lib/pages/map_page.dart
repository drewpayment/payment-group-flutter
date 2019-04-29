import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
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
  LocationData userLocation;
  Future<LocationData> userLocationContract;

  // put the list of "do not knock" locations in this list
  var markers = new Set<Marker>();
  var contacts = new List<Knock>();
  var widgets = <Widget>[];

  _onMapCreated(GoogleMapController controller) {
    // _controller.complete();
    // do things after the map has shown up... might be a good place to wire up events showing/hiding markers
    
  }

  @override
  void initState() {
    super.initState();
    userLocationContract = initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    constructKnockWidgets();

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
      ));
    }

    widgets.add(
      ListView.separated(
        padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => Divider(color: Colors.black54),
        itemCount: contacts.length,
        itemBuilder: (context, index) => ListTile(
          leading: Icon(Icons.assignment_late),
          title: Text(contacts[index].address),
          onTap: () {
            print('This needs to drop a pin on the map.');
          },
        ),
      ),
    );

    return new Scaffold(
      body: GridView.count(
        primary: false,
        padding: EdgeInsets.all(20.0),
        crossAxisSpacing: 10.0,
        crossAxisCount: 1,
        children: widgets,
      ),
    );
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

  void constructKnockWidgets() {
    var repo = Repository.get();

    repo.getKnocks().then((res) {
      if (res.isOk()) {
        contacts.addAll(res.body);

        res.body.forEach((k) {
          markers.add(
            new Marker(
              markerId: new MarkerId('@{k.dncContactId}'),
              position: LatLng(k.lat, k.long)
            )
          );
        });
      }
    });
  }

}