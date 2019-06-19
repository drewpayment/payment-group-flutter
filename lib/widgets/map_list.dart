import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/models/Knock.dart';

class MapListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: null,
      stream: bloc.knocksStream,
      builder: (context, AsyncSnapshot<List<Knock>> snapshot) {
        if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
          var knocks = snapshot.data;
          return SizedBox(
            child: ListView(
              children: ListTile.divideTiles(
                tiles: knocks.map((k) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.assignment_late),
                    ),
                    title: k.firstName != null ? Text('${k.firstName} ${k.lastName}') : Text(k.description),
                    subtitle: Text(k.address),
                    onTap: () {
                      // _goToAddress(k, isSelected);
                    },
                    selected: false,
                  );
                }).toList(),
                color: Colors.black87,
                context: context,
              ).toList(),
            ),
            width: MediaQuery.of(context).size.width,
            height: (MediaQuery.of(context).size.height / 2) - 135 // hardcoded
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}