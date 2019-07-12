import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/models/Knock.dart';

class GoogleMapWidget extends StatefulWidget {
  final Knock navigateToContact;

  GoogleMapWidget([this.navigateToContact]);

  @override
  GoogleMapState createState() => GoogleMapState(navigateToContact);
}

class GoogleMapState extends State<GoogleMapWidget> {
  final Knock navigateToContact;
  Completer<GoogleMapController> _controller = Completer();

  Location _location;
  LatLng _mapCenter;
  LatLngBounds bounds;

  GoogleMapState(this.navigateToContact);

  @override
  Widget build(BuildContext context) {
    _location = Location();
    return FutureBuilder(
      initialData: null,
      future: _location.getLocation(),
      builder: (context, AsyncSnapshot<LocationData> locSnap) {
        if (locSnap.hasData) {
          var loc = locSnap.data;
          _mapCenter = LatLng(loc.latitude, loc.longitude);
          return StreamBuilder(
            initialData: null,
            stream: bloc.knocksStream,
            builder: (context, AsyncSnapshot<List<Knock>> knockSnap) {
              if (knockSnap.hasData) {
                var knocks = knockSnap.data;
                var sizedBoxChildren = <Widget>[];

                sizedBoxChildren.add(GoogleMap(
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: _getInitialCameraPosition(),
                  markers: bloc.markers,
                  compassEnabled: true,
                  tiltGesturesEnabled: false,
                  onCameraIdle: () {
                    bloc.filterKnocksByBoundary();
                  },
                ));

                // if the view is showing markers, display the trigger to show the bottom sheet model also 
                if (bloc.markers.length > 0) {
                  sizedBoxChildren.add(_getBottomSheetTrigger(knocks));
                }

                return Container(
                  child: Stack(
                    children: sizedBoxChildren,
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                );
              } 

              return Center(child: CircularProgressIndicator());
            },
          );
        } else if (locSnap.connectionState == ConnectionState.done && !locSnap.hasData) {
          return Center(
            child: Text('Please enable Location Services.'),
          );
        } else {
          if (locSnap.hasError) {
            var e = locSnap.error as PlatformException;
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

  CameraPosition _getInitialCameraPosition() {
    LatLng target;
    if (navigateToContact != null) {
      target = LatLng(navigateToContact.lat, navigateToContact.long);
    } else {
      target = _mapCenter;
    }
    return CameraPosition(
      target: target,
      zoom: 19.0,
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    // _controller.complete();
    // do things after the map has shown up... might be a good place to wire up events showing/hiding markers
    bounds = await controller.getVisibleRegion();
    bloc.mapController = controller;

    _controller.complete(controller);
  }

  Widget _getBottomSheetTrigger(List<Knock> knocks) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Align(
        alignment: Platform.isIOS ? Alignment.topRight : Alignment.bottomLeft,
      ),
    );
  }

  @override
  void dispose() {
    if (!_controller.isCompleted) {
      _controller.complete();
    }
    super.dispose();
  }

}