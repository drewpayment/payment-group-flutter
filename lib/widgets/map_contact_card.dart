
import 'package:flutter/material.dart';
import 'package:pay_track/models/Knock.dart';

class MapContactCard extends StatelessWidget {
  final Knock contact;

  MapContactCard(this.contact);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // go to location... 
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
                      image: NetworkImage('https://via.placeholder.com/150'),
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