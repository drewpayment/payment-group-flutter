import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
    Auth({
        @required this.googleSignIn,
        @required this.firebaseAuth
    });

    final GoogleSignIn googleSignIn;
    final FirebaseAuth firebaseAuth;

    Future<FirebaseUser> signInWithGoogle() async {
        final GoogleSignInAccount googleAccount = await googleSignIn.signIn();
        // TODO: handle null google account
        final GoogleSignInAuthentication googleAuth = await googleAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken
        );

        final FirebaseUser user = await firebaseAuth.signInWithCredential(credential);
        print("Signed in " + user.displayName);
        return user;
    }
}