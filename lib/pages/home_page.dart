import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pay_track/models/DrawerItem.dart';
import 'package:pay_track/pages/map_page.dart';
import 'package:pay_track/posts_list.dart';
import 'package:pay_track/services/auth.dart';
import 'package:pay_track/sign_in.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final drawerItems = [
    new DrawerItem('Home', Icons.home),
    new DrawerItem('Map', Icons.map)
  ];

  _onSelectItem(int index) {
    setState(() => _selectedIndex = index);
    Navigator.of(context).pop(); // closer the drawer when user selects new item
  }

  // get widget to fill body
  _getDrawerItemScreen(int pos) {
    switch (pos) {
      case 0:
        return new Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: PostsList(),
        );
      case 1:
        return MapPage();

      default:
        return new Text('Error!');
    }
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
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
        ),
        selected: i == _selectedIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        elevation: 1.0,
      ),
      body: _getDrawerItemScreen(_selectedIndex),
      floatingActionButton: SignInFab(
        auth: Auth(
          firebaseAuth: FirebaseAuth.instance, googleSignIn: GoogleSignIn()
        ),
      ),
      drawer: new Drawer(
        child: new ListView(
          padding: EdgeInsets.all(0.0),
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName:
                  Text('Drew Payment', style: TextStyle(color: Colors.white)),
              accountEmail: Text('drew.payment@gmail.com',
                  style: TextStyle(color: Colors.white)),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.blueGrey,
                child: Text(
                  'DP',
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
      ),
    );
  }
}
