
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pay_track/auth/auth.dart';
import 'package:pay_track/data/http.dart';
import 'package:pay_track/data/user_repository.dart';
import 'package:pay_track/pages/home_page.dart';
import 'package:pay_track/pages/register_page.dart';

class PostsList extends StatefulWidget {
  PostsList();

  @override
  PostsListState createState() => PostsListState();
}

class PostsListState extends State<PostsList> {

  FirebaseUser fbUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: Container(
          width: 200.0,
          child: RaisedButton(
            padding: EdgeInsets.all(16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset('assets/g-logo.png', height: 24.0),
                Text('Sign in with Google', 
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            onPressed: () {
              Auth.signIn(
                signInOption: SignInOption.standard,
                listen: (GoogleSignInAccount account) {
                  Auth.fireBaseUser().then((FirebaseUser fb) {
                    fbUser = fb;
                    _loadUser();
                  });
                },
              );
            },
          ),
        ),
      ),
    );
  }

  _loadUser() async {
    if (fbUser == null) return;
    var bearerToken = await fbUser.getIdToken();

    HttpClient.addInterceptor(InterceptorsWrapper(
      onRequest: (RequestOptions options) {
        options.headers.addAll({
          'authorization': 'Bearer $bearerToken'
        });

        options.queryParameters.addAll({
          'fbid': Auth.uid,
        });

        return options;
      },
    ));

    print('User email is verified: ${fbUser?.isEmailVerified}');
    print('User is logged in: ${Auth.isSignedIn()}');
    if (fbUser?.isEmailVerified ?? false) {
      Navigator.of(context).popAndPushNamed(HomePage.routeName);
    } else {
      Navigator.pushReplacementNamed(context, RegisterPage.routeName);
    }
  }

}