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
      builder: (context, AsyncSnapshot<LocationData> snapshot) {
        if (snapshot.hasData) {
          var loc = snapshot.data;
          _mapCenter = LatLng(loc.latitude, loc.longitude);
          return StreamBuilder(
            initialData: null,
            stream: bloc.knocksStream,
            builder: (context, AsyncSnapshot<List<Knock>> snapshot) {
              if (snapshot.hasData) {
                var knocks = snapshot.data;
                var sizedBoxChildren = <Widget>[];

                sizedBoxChildren.add(GoogleMap(
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
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

                return SizedBox(
                  child: Stack(
                    children: sizedBoxChildren,
                  ),
                  // height: MediaQuery.of(context).size.height - (Scaffold.of(context).appBarMaxHeight + 83),
                  height: MediaQuery.of(context).size.height - Scaffold.of(context).appBarMaxHeight,
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
        child: FloatingActionButton(
          materialTapTargetSize: MaterialTapTargetSize.padded,
          onPressed: () {
            showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              builder: (context) {
                return Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 16.0),
                            child: Text('POSITS (Locations)',
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ]..addAll(ListTile.divideTiles(
                      context: context,
                      tiles: knocks.map((k) {
                        return ListTile(
                          leading: Icon(Icons.map),
                          title: Text('${k.firstName} ${k.lastName}'),
                          subtitle: Text('${k.address}'),
                          onTap: () {
                            // close bottom sheet & reposition camera on this knock
                            Navigator.pop(context);
                            _moveMapPosition(LatLng(k.lat, k.long));
                            // print('need to move camera position still...');
                          }
                        );
                      }).toList(),
                      color: Colors.black87,
                    )),
                  ),
                );
              }
            );
          },
          child: Icon(Icons.view_list),
        ),
      ),
    );
  }

  void _moveMapPosition(LatLng g) {
    bloc.mapController.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: g,
          zoom: 19.0,
        ),
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