import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pay_track/auth/auth.dart';
import 'package:pay_track/data/repository.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/parsed_response.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/pages/custom_bottom_nav.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/utils/color_list_tile.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  static const String routeName = '/map';

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> _controller = Completer();

  LatLng _center;
  var location = new Location();
  List<Knock> contacts;
  LocationData userLocation;
  Future<LocationData> userLocationContract;
  // GoogleMapController _controller;
  Future<bool> _initData;

  // put the list of "do not knock" locations in this list
  final Set<Marker> _markers = Set();
  List<MarkerId> _markerIds = <MarkerId>[];
  var widgets = <Widget>[];
  var _selectedNavigationItem = 1;

  _onMapCreated(GoogleMapController controller) {
    // _controller.complete();
    // do things after the map has shown up... might be a good place to wire up events showing/hiding markers
    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();

    initPlatformState().then((loc) => setState(() { _center = LatLng(loc.latitude, loc.longitude); }));

    _initData = _getKnocks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initData,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        Widget body;

        if (snapshot.hasError) {
          Auth.signOut();
        }

        switch(snapshot.connectionState) {
          case ConnectionState.done:
            _handleApiResponseAndBuildWidgets();
            body = GridView.count(
              primary: true,
              padding: EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 1,
              children: widgets,
            );
            break;
          case ConnectionState.waiting: 
          default:
            body = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(
                  child: new CircularProgressIndicator()
                ),
              ],
            );
        }

        return new Scaffold(
          appBar: CustomAppBar(title: Text(HomePage.title)),
          body: body,
          bottomNavigationBar: CustomBottomNav(
            items: HomePage.bottomNavItems,
            currentIndex: _selectedNavigationItem,
            onTap: _onNavigationBarTap,
          ),
        );
      }
    );
  }

  _onNavigationBarTap(int index) {
    print('Tapped number $index');
    setState(() {
      _selectedNavigationItem = index;
    });
  }

  void _handleApiResponseAndBuildWidgets() {
    widgets = <Widget>[];

    if (_center == null) {
      widgets.add(new Center(
        child: Text('Please enable Location Services.'),
      ));
    } else {
      widgets.add(Container(
        constraints: BoxConstraints.expand(),
        height: 400.0,
        child: GoogleMap(
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.0,
          ),
          markers: _markers,
          compassEnabled: true,
        ),
      ));
    }

    if (contacts != null && contacts.length > 0) {
      widgets.add(GridView.count(
        crossAxisCount: 1,
        primary: false,
        children: <Widget>[
          ListView.separated(
            padding: EdgeInsets.fromLTRB(0, 16.0, 0, 16.0),
            scrollDirection: Axis.vertical,
            separatorBuilder: (context, index) => Divider(color: Colors.black54),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return ColorListTile(
                leading: Icon(Icons.assignment_late),
                title: Text(contacts[index].address),
                onTap: (bool isSelected) {
                  var con = contacts[index];
                  _goToAddress(con, isSelected);
                },
                selected: false,
                selectedColor: Colors.lightBlue[50].withOpacity(0.5),
              );
            }
          )
        ],
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

  Future<bool> _getKnocks() async {
    var result = await Repository.get().getKnocks();
    var comp = Completer();

    if (result.isOk()) {
      contacts = result.body;
      comp.complete(true);
    } else {
      comp.complete(false);
    }

    return comp.future;
  }

  Future<void> _goToAddress(Knock con, bool isSelected) async {
    GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(con.lat, con.long),
        zoom: 18.0,
      )
    ));

    _markers.clear();

    if (isSelected) {
      var desc = con.firstName != null ? '${con.firstName} ${con.lastName}' : '${con.description}';
      var marker = Marker(
        markerId: MarkerId('${con.dncContactId}'),
        position: LatLng(con.lat, con.long),
        infoWindow: InfoWindow(
          title: '${con.address}',
          snippet: '$desc',
        ),
      );
      setState(() {
        _markers.add(marker);
      });
    } 
    
  }

  Future<LocationData> initPlatformState() async {
    LocationData userLocation;
    try {
      userLocation = await location.getLocation();
    } on PlatformException catch(e) {
      if (e.code == 'PERMISSION_DENIED') {
        print('Permission Denied.');
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        print('Permission denied - please ask the user to enable it from the app settings');
      }
    }
    return userLocation;
  }

}