import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

//creating an instance of Firebase Authentication
class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentuser() async {
    return auth.currentUser;
  }

  static Future<String> signInWithgoogle(context) async {
    try {
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication!.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      UserCredential result =
          await _firebaseAuth.signInWithCredential(credential);

      User? userDetails = result.user;

      return "userDetails";
    } catch (e) {
      print(e);
      return 'fail';
    }
  }

  signOut(BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear();

    // await Hive.openBox('userData');
    // Hive.box('userData').delete('userMap');
    await auth.signOut();
    // NavPushReplacement(context, LoginUI());
    // Navigator.popUntil(context, (route) => false);
  }
}
