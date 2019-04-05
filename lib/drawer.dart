import 'package:flutter/material.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/pages/map_page.dart';

class DrawerWidget extends StatefulWidget {
    const DrawerWidget({Key key}) : super(key: key);

    @override
    _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State {
    @override
    Widget build(BuildContext context) {
        return new Drawer(
            child: new ListView(
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
                    // new DrawerHeader(
                    //     child: new Column(
                    //         children: <Widget>[
                                
                    //         ],
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //     ),
                    //     decoration: BoxDecoration(
                    //         color: Colors.indigoAccent
                    //     ),
                    // ),
                    new UserAccountsDrawerHeader(
                        accountName: Text('Drew Payment', style: TextStyle(color: Colors.white)),
                        accountEmail: Text('drew.payment@gmail.com', style: TextStyle(color: Colors.white)),
                        currentAccountPicture: new CircleAvatar(
                            backgroundColor: Colors.blueGrey,
                            child: Text('DP', 
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                ),
                            ),
                            maxRadius: 8,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.cyan,
                        ),
                    ),
                    new ListTile(
                        leading: Icon(Icons.home),
                        title: Text('Home', 
                            style: TextStyle(
                                fontSize: 18.0,
                            ),
                        ),
                        onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, HomePage.routeName);
                        },
                    ),
                    new ListTile(
                        leading: Icon(Icons.account_box),
                        title: Text('Map', 
                            style: TextStyle(
                                fontSize: 18.0,
                            ),
                        ),
                        onTap: () {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(context, MapPage.routeName);
                        },
                    ),
                ],
            ),
            elevation: 16.0,
        );
    }
}