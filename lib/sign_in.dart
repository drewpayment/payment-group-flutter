import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/data/user_repository.dart';
import 'package:pay_track/pages/home_page.dart';
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

  _handleSignIn(BuildContext context) async {
    var user = await _signInWithGoogle();

    if (user != null) _loadUser();

    // Auth.signInSilently(
    //   signInOption: SignInOption.standard,
    //   onError: (err) {
    //     print('ERROR FROM AUTH!');
    //     print(err);
    //   },
    //   listen: (googleUser) {
    //     if (googleUser != null) {
    //       print('Listen event fired!' + googleUser?.displayName ?? '');
    //       _loadUser();
    //     } else {
    //       print(Auth.isSignedIn());
    //     }
    //   }
    // );
  }

  

    // _signInWithGoogle().then((user) {
      // if (user.isEmailVerified) {
      //   _showSnackBar(context, 'Welcome ${user.displayName}');
      //   Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      // } else {
      //   _navigateToRegistration(context);
      // }
    // });
  // }

  _loadUser() async {
    HttpClient.addInterceptor(InterceptorsWrapper(
      onRequest: (RequestOptions options) {
        options.headers.addAll({
          'authorization': 'Bearer ${Auth.idToken}'
        });

        options.queryParameters.addAll({
          'fbid': Auth.uid,
        });

        return options;
      },
    ));

    var userRepo = UserRepository();
    var userResponse = await userRepo.getUser();

    if (userResponse.isOk()) {
      HttpClient.user = userResponse.body;
    }
  }

  void _showSnackBar(BuildContext context, String msg) {
    final SnackBar snackBar = SnackBar(content: Text(msg));
    Scaffold.of(context).showSnackBar(snackBar);
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
