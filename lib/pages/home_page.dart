import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pay_track/models/config.dart';
import 'package:pay_track/pages/custom_app_bar.dart';
import 'package:pay_track/pages/custom_bottom_nav.dart';
import 'package:pay_track/pages/map_page.dart';
import 'package:pay_track/services/auth.dart';
import 'package:scoped_model/scoped_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key }) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // static const String title = 'Locale.Marketing';
  static const String routeName = '/home';

  static const List<BottomNavigationBarItem> bottomNavItems = [BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text('Home'),
    ), BottomNavigationBarItem(
      icon: Icon(Icons.map),
      title: Text('Map'),
    )
  ];

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  String _username;
  String _password;

  BoxDecoration headerStyle;
  List<Widget> drawerOptions;
  int _selectedNavigationItem = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    headerStyle = BoxDecoration(
      color: Colors.cyan[400],
    );

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return ScopedModelDescendant<ConfigModel>(
      builder: (context, child, model) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CustomAppBar(title: Text('${model.appName}')),
          body: Auth.isSignedIn()
            ? _getSignedInBody()
            : _getSignedOutBody(),
          bottomNavigationBar: Auth.isSignedIn() ? CustomBottomNav(
            items: HomePage.bottomNavItems,
            currentIndex: _selectedNavigationItem,
            onTap: _onNavigationBarTap,
          ) : null,
        );
      },
    );
  }

  _onNavigationBarTap(int index) {
    print('Tapped number $index');
    setState(() {
      _selectedNavigationItem = index;
    });

    if (_selectedNavigationItem == 1) {
      Navigator.pushReplacementNamed(context, MapPage.routeName);
    }
  }

  Widget _getSignedOutBody() {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Image.asset(
                          'assets/undraw_walking_around_25f5.png',
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          autocorrect: false,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            labelText: 'Username',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a username';
                            }
                            _username = value;
                          },
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () {
                            
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          key: ValueKey('passwordField'),
                          autocorrect: false,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter a password.';
                            }
                            _password = value;
                          },
                        ),
                      ),
                      RaisedButton(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.exit_to_app, color: Colors.white,),
                            Text('Sign In', style: TextStyle(color: Colors.white)),
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Auth.signIn(_username, _password).then((result) {
                              print('Status is OK: ${result.isOk()}');
                              print('User display name: ${Auth.user?.firstName} ${Auth.user?.lastName}');
                              print('Token: ${result.body?.token}');
                              if (result.isOk()) {
                                _formKey.currentState?.reset();
                                Navigator.pushReplacementNamed(context, MapPage.routeName);
                              }
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        color: Theme.of(context).primaryColor,
                        elevation: 2.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getSignedInBody() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Text('WELCOME',
                style: TextStyle(
                  fontFamily: 'Starjedi',
                  fontSize: 36,
                  letterSpacing: 2.0,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                'assets/undraw_settings_ii2j.png',
                height: 200,
              ),
            ),
            Center(
              child: Card(
                margin: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.person_outline),
                      dense: false,
                      title: Text('${Auth.user.firstName} ${Auth.user.lastName}'),
                      subtitle: Text('${Auth.user.email}'),
                    ),
                    ButtonTheme.bar(
                      child: ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            child: Text('Sign Out',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            onPressed: () {
                              Auth.signOut().then((success) {
                                setState(() {
                                  _selectedNavigationItem = 0;
                                });
                              });
                            }
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

}
