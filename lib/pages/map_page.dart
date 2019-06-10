import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/data/repository.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/pages/custom_bottom_nav.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/services/auth.dart';
import 'package:pay_track/utils/color_list_tile.dart';
import 'package:scoped_model/scoped_model.dart';

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
  List<Knock> _contacts;
  List<Knock> mapContacts;
  LatLngBounds bounds;
  LocationData userLocation;
  Future<LocationData> userLocationContract;
  // GoogleMapController _controller;

  // put the list of "do not knock" locations in this list
  Set<Marker> _markers = Set();
  var widgets = <Widget>[];
  var _selectedNavigationItem = 1;

  _onMapCreated(GoogleMapController controller) async {
    // _controller.complete();
    // do things after the map has shown up... might be a good place to wire up events showing/hiding markers
    bounds = await controller.getVisibleRegion();

    _controller.complete(controller);
  }

  @override
  void initState() {
    super.initState();

    initPlatformState().then((loc) => setState(() { _center = LatLng(loc.latitude, loc.longitude); }));
    bloc.fetchAllKnocks();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bloc.allKnocks,
      builder: (context, AsyncSnapshot<List<Knock>> snapshot) {
        Widget body;
        if (snapshot.hasData) {
          var knocks = snapshot.data;

          knocks.forEach((Knock k) {
            _markers.add(Marker(
              markerId: MarkerId(k.dncContactId.toString()),
              position: LatLng(k.lat, k.long),
              infoWindow: InfoWindow(
                title: '${k.address}',
                snippet: '${k.description}',
              ),
            ));
          });

          body = Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildUI(snapshot.data),
          );
        } else {
          body = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(child: CircularProgressIndicator()),
            ],
          );
        }
        return Scaffold(
          appBar: CustomAppBar(title: Text('TESTING')),
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

  List<Widget> _buildUI(List<Knock> data) {
    widgets = <Widget>[];

    if (_center == null) {
      widgets.add(new Center(
        child: Text('Please enable Location Services.'),
      ));
    } else {
      widgets.add(SizedBox(
        child: GoogleMap(
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.0,
          ),
          markers: _markers.toSet(),
          compassEnabled: true,
        ),
        height: 400,
        width: MediaQuery.of(context).size.width,
      ));
    }

    widgets.add(Flexible(
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        scrollDirection: Axis.vertical,
        separatorBuilder: (context, index) => Divider(color: Colors.black54),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ColorListTile(
            leading: Icon(Icons.assignment_late),
            title: Text(data[index].address),
            onTap: (bool isSelected) {
              var con = data[index];
              _goToAddress(con, isSelected);
            },
            selected: false,
            selectedColor: Colors.lightBlue[50].withOpacity(0.5),
          );
        }
      ),
      fit: FlexFit.tight,
    ));

    return widgets;
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