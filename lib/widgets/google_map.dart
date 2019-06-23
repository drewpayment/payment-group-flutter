import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/models/Knock.dart';

class GoogleMapWidget extends StatefulWidget {

  @override
  GoogleMapState createState() => GoogleMapState();
}

class GoogleMapState extends State<GoogleMapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  Location _location;
  LatLng _mapCenter;
  LatLngBounds bounds;

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
                  initialCameraPosition: CameraPosition(
                    target: _mapCenter,
                    zoom: 18.0,
                  ),
                  markers: bloc.markers,
                  compassEnabled: true,
                  tiltGesturesEnabled: false,
                  onCameraIdle: () {
                    print('when does this fire?');
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
                  height: MediaQuery.of(context).size.height - (Scaffold.of(context).appBarMaxHeight + 83),
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
    bloc.mapController = controller;

    _controller.complete(controller);
  }

  Widget _getBottomSheetTrigger(List<Knock> knocks) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.bottomLeft,
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
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Restricted Addresses',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
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
                    ]..addAll(knocks.map((k) {
                      return ListTile(
                        leading: Icon(Icons.account_box),
                        title: Text('${k.firstName} ${k.lastName}'),
                        subtitle: Text('${k.address}'),
                        onTap: () {
                          // close bottom sheet & reposition camera on this knock
                          Navigator.pop(context);
                          print('need to move camera position still...');
                        }
                      );
                    })),
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

  @override
  void dispose() {
    _controller.complete();
    super.dispose();
  }

}