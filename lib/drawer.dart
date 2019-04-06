import 'package:flutter/material.dart';
import 'package:pay_track/models/DrawerItem.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/pages/map_page.dart';

class DrawerWidget extends StatefulWidget {
    const DrawerWidget({Key key}) : super(key: key);

    @override
    _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {

    int _selectedIndex = 0;

    final drawerItems = [
        new DrawerItem('Home', Icons.home),
        new DrawerItem('Map', Icons.map)
    ];

    _getDrawerItemScreen(int pos) {
        // navigate
        String routeTo = '';
        var item = drawerItems[pos];

        if (item.title == 'Home') {
            routeTo = HomePage.routeName;
        } else if (item.title == 'Map') {
            routeTo = MapPage.routeName;
        }

        Navigator.of(context).pop();
        Navigator.pushReplacementNamed(context, routeTo);
    }

    _onSelectItem(int index) {
        setState(() {
            _selectedIndex = index;
        });

        _getDrawerItemScreen(index);
    }

    @override
    Widget build(BuildContext context) {
        List<Widget> drawerOptions = [];
        for (var i = 0; i < drawerItems.length; i++) {
            var d = drawerItems[i];
            drawerOptions.add(new ListTile(
                leading: new Icon(d.icon),
                title: new Text(
                    d.title,
                    style: new TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w400
                    ),
                ),
                selected: i == _selectedIndex,
                onTap: () => _onSelectItem(i),
            ));
        }

        return new Drawer(
            child: new ListView(
                padding: EdgeInsets.all(0.0),
                children: <Widget>[
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
                    new Column(
                        children: drawerOptions,
                    ),
                ],
            ),
            elevation: 16.0,
        );
    }
}