import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pay_track/bloc/knock_bloc.dart';

class GoogleMapWidget extends StatefulWidget {
  final KnockBloc bloc;

  GoogleMapWidget(this.bloc);

  @override
  GoogleMapState createState() => GoogleMapState(bloc);
}

class GoogleMapState extends State<GoogleMapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  KnockBloc bloc;
  Location _location;
  LatLng _mapCenter;
  LatLngBounds bounds;

  GoogleMapState(this.bloc);

  @override
  Widget build(BuildContext context) {
    _location = Location();
    return FutureBuilder(
      initialData: null,
      future: _location.getLocation(),
      builder: (context, AsyncSnapshot<LocationData> snapshot) {
        if (snapshot.hasData) {
          var loc = snapshot.data;
          _mapCenter = LatLng(loc.latitude, loc.longitude);
          return StreamBuilder(
            initialData: Set<Marker>(),
            stream: bloc.markerStream,
            builder: (context, AsyncSnapshot<Set<Marker>> snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  child: GoogleMap(
                    zoomGesturesEnabled: true,
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _mapCenter,
                      zoom: 16.0,
                    ),
                    markers: bloc.markers,
                    compassEnabled: true,
                    tiltGesturesEnabled: false,
                    onCameraIdle: () {
                      // _filterContactsByMapBoundary();
                      print('when does this fire?');
                    },
                  ),
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                ); 
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
          return Center(
            child: Text('Please enable Location Services.'),
          );
        } else {
          if (snapshot.hasError) {
            var e = snapshot.error as PlatformException;
            if (e.code == 'PERMISSION_DENIED') {
              print('Permission Denied.');
            } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
              print('Permission denied - please ask the user to enable it from the app settings');
            }
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    // _controller.complete();
    // do things after the map has shown up... might be a good place to wire up events showing/hiding markers
    bounds = await controller.getVisibleRegion();
    bloc.filterKnocksByBoundary(bounds);

    _controller.complete(controller);
  }

  // Future<void> _goToAddress(Knock con, bool isSelected) async {
  //   GoogleMapController controller = await _controller.future;

  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(target: LatLng(con.lat, con.long),
  //       zoom: 18.0,
  //     )
  //   ));

  //   _markers.clear();

  //   if (isSelected) {
  //     var desc = con.firstName != null ? '${con.firstName} ${con.lastName}' : '${con.description}';
  //     var marker = Marker(
  //       markerId: MarkerId('${con.dncContactId}'),
  //       position: LatLng(con.lat, con.long),
  //       infoWindow: InfoWindow(
  //         title: '${con.address}',
  //         snippet: '$desc',
  //       ),
  //     );
  //     setState(() {
  //       _markers.add(marker);
  //     });
  //   } 
    
  // }

}