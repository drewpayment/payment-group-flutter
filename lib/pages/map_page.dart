import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_track/drawer.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  static const String routeName = '/map';

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng _center = new LatLng(42.9563369, -85.7302999);
  var location = new Location();
  LocationData userLocation;
  Future<LocationData> userLocationContract;
  bool _hasPermission;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userLocationContract = initPlatformState();
  }

  @override
  Widget build(BuildContext context) {
    var markers = new Set<Marker>();
    markers.add(Marker(markerId: MarkerId('1'), position: _center));

    var widgets = <Widget>[];

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
          zoom: 11.0,
        ),
        markers: markers,
      ));
    }

    widgets.add(ListView.separated(
      scrollDirection: Axis.vertical,
      separatorBuilder: (context, index) => Divider(color: Colors.cyan),
      itemCount: 2,
      itemBuilder: (context, index) => ListTile(
        leading: Icon(Icons.assignment_late),
        title: Text('4038 Zion Ct SE'),
        onTap: () {
          print('This needs to drop a pin on the map.');
        },
      ),
    ));

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
        children: widgets,
      ),
      drawer: new DrawerWidget(),
    );

  }

  Future<LocationData> initPlatformState() async {
    Future<LocationData> userLocationContract;

    try {
      userLocationContract = location.getLocation();
      _hasPermission = await location.hasPermission();
    } on PlatformException catch(e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission Denied.');
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        print('Permission denied - please ask the user to enable it from the app settings');
      }
    }

    return userLocationContract;
  }

  CircularProgressIndicator _loadLocation() {
    _getLocation().then((res) {
      setState(() {
        userLocation = res;
        _center = LatLng(res.latitude, res.longitude);
      });
    });

    return CircularProgressIndicator();
  }

  Future<LocationData> _getLocation() async {
    LocationData currLocation;

    try {
      var isPermissable = await location.hasPermission();
      var isServiceEnabled = await location.requestService();

      if (isPermissable && isServiceEnabled) {
        currLocation = await location.getLocation();
      } else {
        currLocation = null;
      }
      
    } catch (e) {
      currLocation = null;
    }

    return currLocation;
  }

}
