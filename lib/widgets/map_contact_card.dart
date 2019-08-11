
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/models/Knock.dart';

class MapContactCard extends StatelessWidget {
  final Knock contact;
  final String api = 'https://maps.googleapis.com/maps/api/streetview';

  MapContactCard(this.contact);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // go to location... 
        bloc.mapController.animateCamera(CameraUpdate.newLatLng(LatLng(contact.lat, contact.long)));
      }, 
      child: Container(
        child: FittedBox(
          child: Material(
            color: Theme.of(context).primaryColor,
            elevation: 7,
            borderRadius: BorderRadius.circular(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: _contactInformationContainer(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _contactInformationContainer() {
    var desc = contact.firstName != null 
      ? '${contact.firstName} ${contact.lastName}'
      : '${contact.description}';

    final addressStyle = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );

    var widgets = List<Widget>()..addAll([
      // Text('$desc',
      //   style: TextStyle(
      //     fontSize: 20,
      //     fontWeight: FontWeight.bold,
      //     letterSpacing: -0.5,
      //   ),
      // ),
      Text('${contact.address}', 
        softWrap: true,
        style: addressStyle,
      ),
    ]);

    if (contact.addressCont != null) {
      widgets.add(Text('${contact.addressCont}', softWrap: true, style: addressStyle));
    }

    widgets.add(Text('${contact.city}, ${contact.state} ${contact.zip}', softWrap: true, style: addressStyle));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }
}