import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pay_track/auth/auth.dart';
import 'package:pay_track/models/DrawerItem.dart';
import 'package:pay_track/pages/map_page.dart';
import 'package:pay_track/posts_list.dart';
import 'package:pay_track/sign_in.dart';
import 'package:rxdart/rxdart.dart';

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

  final PageStorageBucket bucket = new PageStorageBucket();

  var _currentUser = new BehaviorSubject<GoogleSignInAccount>();
  GoogleSignInAccount user;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    
  }

  @override
  void initState() {
    super.initState();

    Auth.init();

    Auth.initListen(
      listen: (account) {
        if (Auth.isSignedIn()) {
          setState(() => user = account);
        } 
      },
    );

    Auth.signInSilently();
  }

  _signOut() {
    Auth.signOut().then((done) => setState(() => user = null));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < drawerItems.length; i++) {
      var d = drawerItems[i];

      drawerOptions.add(new Container(
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: i == _selectedIndex ? Colors.cyan[400] : Theme.of(context).canvasColor,
          borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: new ListTile(
          dense: true,
          leading: new Icon(d.icon, 
            color: i == _selectedIndex ? Colors.white : Colors.cyan,
          ),
          title: new Text(
            d.title,
            style: new TextStyle(
              fontSize: 18.0, 
              fontWeight: FontWeight.w400,
              color: i == _selectedIndex ? Colors.white : Colors.cyan,
            ),
          ),
          selected: i == _selectedIndex,
          onTap: () => _onSelectItem(i),
        ),
      ));
    }

    var headerStyle = BoxDecoration(
      color: Colors.cyan[400],
    );

    if (user == null && _selectedIndex > 0) {
      setState(() => _selectedIndex = 0);
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
      body: PageStorage(
        child: _getDrawerItemScreen(_selectedIndex),
        bucket: bucket,
      ),
      floatingActionButton: user == null ? SignInFab() 
        : FloatingActionButton.extended(
          icon: Icon(Icons.exit_to_app),
          label: Text('Sign Out'),
          onPressed: _signOut(),
          backgroundColor: Theme.of(context).canvasColor,
        ),
      drawer: user != null 
        ? new Drawer(
        child: new ListView(
          padding: EdgeInsets.all(0.0),
          children: <Widget>[
            user != null
              ? new UserAccountsDrawerHeader(
                accountName:
                  Text(user?.displayName, style: TextStyle(color: Colors.white)),
                accountEmail: Text(user?.email,
                  style: TextStyle(color: Colors.white)),
                currentAccountPicture: new GoogleUserCircleAvatar(
                  identity: user,
                ),
                decoration: headerStyle,
              )
              : new UserAccountsDrawerHeader(
                accountName: Text(''),
                accountEmail: Text(''),
                currentAccountPicture: Icon(
                  Icons.account_circle, 
                  size: 72.0, 
                  color: Colors.black45,
                ),
                decoration: headerStyle,
              ),
            ListTileTheme(
              child: new Column(
                children: drawerOptions,  
              ),
            )
          ],
        ),
        elevation: 16.0,
      )
      : null,
    );
  }

}
