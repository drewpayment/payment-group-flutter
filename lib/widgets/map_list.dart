

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pay_track/bloc/knock_bloc.dart';
import 'package:pay_track/models/Knock.dart';
import 'package:pay_track/utils/color_list_tile.dart';

class MapListWidget extends StatelessWidget {
  final KnockBloc bloc;

  MapListWidget(this.bloc);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: null,
      stream: bloc.knocksStream,
      builder: (context, AsyncSnapshot<List<Knock>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          var knocks = snapshot.data;
          return Flexible(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.vertical,
              separatorBuilder: (context, index) => Divider(color: Colors.black54),
              itemCount: knocks.length,
              itemBuilder: (context, index) {
                return ColorListTile(
                  leading: Icon(Icons.assignment_late),
                  title: Text(knocks[index].address),
                  onTap: (bool isSelected) {
                    var con = knocks[index];
                    // _goToAddress(con, isSelected);
                  },
                  selected: false,
                  selectedColor: Colors.lightBlue[50].withOpacity(0.5),
                );
              }
            ),
            fit: FlexFit.tight,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

}