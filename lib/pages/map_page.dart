import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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

  _onMapCreated(GoogleMapController controller) {
    // _controller.complete();
    // do things after the map has shown up... might be a good place to wire up events showing/hiding markers
  }

  @override
  void initState() {
    super.initState();
    userLocationContract = initPlatformState();
    var mockHttp = new FakeMarkersGetter();

    mockHttp._getMockDoNotKnocks().then((res) {
      res.forEach((r) {
        markers.add(
          new Marker(
            markerId: new MarkerId('@{r.id}'),
            position: LatLng(r.latitude, r.longitude)
          )
        );
      });
      print(markers);
    });
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    if (_center == null || markers == null) {
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
        itemCount: 2,
        itemBuilder: (context, index) => ListTile(
          leading: Icon(Icons.assignment_late),
          title: Text('4038 Zion Ct SE'),
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

}

class FakeMarkersGetter {

  Future<List<DoNotKnock>> _getMockDoNotKnocks() {
    return new Future(() {
      return [
        new DoNotKnock(
          id: 1,
          address: '4038 Zion Ct SE',
          latitude: 42.8900285,
          longitude: -85.584401
        ),
        new DoNotKnock(
          id: 2,
          address: '3269 Mesa Verde Ct SE',
          latitude: 42.890140,
          longitude: -85.585441
        )
      ];
    });
  }

}

class DoNotKnock {
  DoNotKnock({
    @required this.id,
    @required this.address,
    @required this.latitude,
    @required this.longitude
  });

  final int id;
  final String address;
  final double latitude;
  final double longitude;
}