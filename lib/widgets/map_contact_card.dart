
import 'package:flutter/material.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/models/secret.dart';
import 'package:pay_track/widgets/network_image_loader.dart';

class MapContactCard extends StatelessWidget {
  final Knock contact;
  final String api = 'https://maps.googleapis.com/maps/api/streetview';

  MapContactCard(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      initialData: null,
      future: _getStreetViewImage(),
      builder: (context, AsyncSnapshot<Widget> snap) {
        if (snap.hasData) {
          return _cardBody(snap.data);
        }
        return Container();
      },
    );
  }

  Future<Widget> _getStreetViewImage() async {
    var secret = await SecretLoader.load('secrets.json');
    var uri = '$api?location=${contact.lat},${contact.long}&key=${secret.googleMapsAPI}&signature=${secret.streetViewSecret}';

    try {
      var netImage = new NetworkImageLoader(uri);
      var res = await netImage.load();
      return Image(
        fit: BoxFit.scaleDown,
        image: MemoryImage(res),
      );
    } on Exception {
      return Image(
        fit: BoxFit.none,
        image: AssetImage('assets/icons_map_pin_point.png'),
      );
    }
  }

  Widget _cardBody(Widget image) {
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
                    child: image,
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
    var desc = contact.firstName != null 
      ? '${contact.firstName} ${contact.lastName}'
      : '${contact.description}';

    var widgets = List<Widget>()..addAll([
      Text('$desc',
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