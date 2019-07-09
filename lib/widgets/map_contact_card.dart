
import 'package:flutter/material.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/secret.dart';

class MapContactCard extends StatelessWidget {
  final Knock contact;
  final String api = 'https://maps.googleapis.com/maps/api/streetview';

  MapContactCard(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: null,
      future: _getStreetViewImage(),
      builder: (context, AsyncSnapshot<String> snap) {
        if (snap.hasData) {
          return _cardBody(snap.data);
        }
        return Container();
      },
    );
  }

  Future<String> _getStreetViewImage() async {
    var secret = await SecretLoader.load('secrets.json');
    return '$api?location=${contact.lat},${contact.long}&key=${secret.googleMapsAPI}&signature=${secret.streetViewSecret}';
  }

  Widget _cardBody(String imageUrl) {
    return GestureDetector(
      onTap: () {
        // go to location... 
        print('clicked');
      }, 
      child: Container(
        child: FittedBox(
          child: Material(
            color: Colors.white,
            elevation: 14,
            borderRadius: BorderRadius.circular(15),
            shadowColor: const Color(0xB02196F3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 180,
                  height: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage('$imageUrl'),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
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
    var widgets = List<Widget>()..addAll([
      Text('${contact.firstName} ${contact.lastName}',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
          color: Colors.redAccent,
        ),
      ),
      Text('Address:'),
      Text('${contact.address}', softWrap: true),
    ]);

    if (contact.addressCont != null) {
      widgets.add(Text('${contact.addressCont}', softWrap: true));
    }

    widgets.add(Text('${contact.city}, ${contact.state} ${contact.zip}', softWrap: true));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }
}