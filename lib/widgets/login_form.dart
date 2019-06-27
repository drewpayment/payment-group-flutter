
import 'package:flutter/material.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/services/auth.dart';

class LoginForm extends StatefulWidget {

  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _username;
  String _password;

  bool isLoading = false;

  var usernameFocus = FocusNode();
  var passwordFocus = FocusNode();

  @override
  BuildContext get context => super.context;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: CircularProgressIndicator(),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: TextTheme(
          body1: TextStyle(
            color: Colors.white,
          ),
          body2: TextStyle(
            color: Colors.white,
          )
        ),
        cursorColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(30.0),
          ),
          hintStyle: TextStyle(
            color: Colors.white,
            decorationColor: Colors.white,
          ),
          labelStyle: TextStyle(
            color: Colors.white,
            decorationColor: Colors.white,
          ),
        ),
      ),
      child: _getForm(),
    );
  }

  Widget _getForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.transparent,
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
                  colorBlendMode: BlendMode.darken,
                  color: Theme.of(context).primaryColor.withOpacity(0.45),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a username';
                    }
                    _username = value;
                  },
                  textInputAction: TextInputAction.next,
                  focusNode: usernameFocus,
                  onFieldSubmitted: (value) {
                    _fieldFocusChange(context, usernameFocus, passwordFocus);
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
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a password.';
                    }
                    _password = value;
                  },
                  focusNode: passwordFocus,
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
                onPressed: _signIn,
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
    );
  }

  void _signIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      Auth.signIn(_username, _password).then((result) {
        if (result.isOk()) {
          _formKey.currentState?.reset();
          isLoading = false;
          Navigator.pushReplacementNamed(context, HomePage.routeName);
        }
      });
    }
  }

  void _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

}