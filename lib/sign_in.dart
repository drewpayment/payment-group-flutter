import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pay_track/pages/register_page.dart';
// import 'package:pay_track/services/auth.dart';
import 'package:pay_track/auth/auth.dart';

class SignInFab extends StatelessWidget {
  const SignInFab();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _handleSignIn(context),
      icon: Image.asset('assets/g-logo.png', height: 24.0),
      label: const Text(
        'Sign in with Google',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  void _handleSignIn(BuildContext context) {
    _signInWithGoogle().then((user) {
      if (_existingUser()) {
        _showSnackBar(context, 'Welcome ${user.displayName}');
      } else {
        _navigateToRegistration(context);
      }
    });
  }

  void _showSnackBar(BuildContext context, String msg) {
    final SnackBar snackBar = SnackBar(content: Text(msg));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  bool _existingUser() {
    return true;
  }

  void _navigateToRegistration(BuildContext context) {
    Navigator.pushNamed(context, RegisterPage.routeName);
  }

  Future<FirebaseUser> _signInWithGoogle() async {
    final GoogleSignInAccount googleAccount = await Auth.googleSignIn.signIn();
    // TODO: handle null google account
    final GoogleSignInAuthentication googleAuth = await googleAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    FirebaseUser _user;
    await Auth.signInWithCredential(
      credential: credential,
      listener: (user) {
        _user = user;
      }
    );
    
    return _user;
  }
}
