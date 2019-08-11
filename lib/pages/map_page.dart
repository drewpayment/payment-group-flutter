import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/models/secret.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/router.dart';
import 'package:pay_track/widgets/google_map.dart';
import 'package:kiwi/kiwi.dart' as kiwi;
import 'package:pay_track/widgets/map_contact_card.dart';

import 'map_search.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  static const String routeName = '/map';

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  kiwi.Container container = kiwi.Container();
  ConfigModel config;
  MapPageRouterParams routeParams;

  _MapPageState() {
    config = container.resolve<ConfigModel>();
  }

  @override
  BuildContext get context => super.context;

  @override
  void didChangeDependencies() {
    routeParams = ModalRoute.of(context).settings.arguments;

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: null,
      stream: bloc.knocksStream,
      builder: (context, AsyncSnapshot<List<Knock>> snapshot) {
        if (snapshot.connectionState != ConnectionState.waiting && snapshot.hasData) {
          var contacts = snapshot.data;
          Knock navigateToContact;

          if (routeParams != null) {
            navigateToContact = contacts.firstWhere((c) => c.dncContactId == routeParams?.dncContactId,
              orElse: () => null,
            );
          }
          
          return Scaffold(
            appBar: CustomAppBar(
              title: Text('${config.appName}'),
              /// keep from releasing for now... future feature
              // actions: <Widget>[
              //   IconButton(
              //     icon: Icon(Icons.search),
              //     onPressed: () async {
              //       Navigator.pushNamed(context, MapSearch.routeName);
              //     },
              //   ),
              // ],
            ),
            body: SafeArea(
              child: Stack(
                children: <Widget>[
                  GoogleMapWidget(navigateToContact),
                  locationCardContainer(snapshot.data),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget locationCardContainer(List<Knock> contacts) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        color: Colors.black26,
        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: MediaQuery.of(context).size.height * 0.10,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            var contact = contacts[index];
            return Padding(
              padding: const EdgeInsets.all(8),
              child: MapContactCard(contact),
            );
          },
        ),
      ),
    );
  }

  Future<LatLng> getUserLocation() async {
    var location = Location();
    LocationData currentLocation;
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      // blackbox this error for now, dang it. 
    }

    if (currentLocation == null) {
      return null;
    }

    return LatLng(currentLocation.latitude, currentLocation.longitude);
  }

}