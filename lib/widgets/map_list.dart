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
        if (snapshot.connectionState != ConnectionState.waiting && snapshot.hasData) {
          var knocks = snapshot.data;
          return SizedBox(
            child: ListView(
              children: ListTile.divideTiles(
                tiles: knocks.map((k) {
                  return ListTile(
                    leading: Icon(Icons.assignment_late),
                    title: Text(k.address),
                    onTap: () {
                      // _goToAddress(k, isSelected);
                    },
                    selected: false,
                  );
                }).toList(),
                color: Theme.of(context).appBarTheme.color,
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
    
    // return Flexible(
    //   child: ListView.separated(
    //     padding: EdgeInsets.symmetric(horizontal: 16.0),
    //     scrollDirection: Axis.vertical,
    //     separatorBuilder: (context, index) => Divider(color: Colors.black54),
    //     itemCount: knocks.length,
    //     itemBuilder: (context, index) {
    //       return ColorListTile(
    //         leading: Icon(Icons.assignment_late),
    //         title: Text(knocks[index].address),
    //         onTap: (bool isSelected) {
    //           var con = knocks[index];
    //           // _goToAddress(con, isSelected);
    //         },
    //         selected: false,
    //         selectedColor: Colors.lightBlue[50].withOpacity(0.5),
    //       );
    //     }
    //   ),
    //   fit: FlexFit.tight,
    // );
  }

}