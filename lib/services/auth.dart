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

      // try {
      //   var dataResult = await apiCallBack(
      //     method: 'POST',
      //     path: "/users/register-with-google.php",
      //     body: {
      //       'firstName': userDetails!.displayName!.split(' ').first,
      //       'lastName': userDetails.displayName!.split(' ').last,
      //       'dob': '',
      //       'gender': '',
      //       'phone': '',
      //       'email': userDetails.email,
      //       'guid': userDetails.uid,
      //       'specialization': '',
      //       'address': '',
      //       'fcmToken': '',
      //     },
      //   );
      // } catch (e) {}
      print(userDetails!.displayName);

      // final SharedPreferences prefs = await _prefs;
      // if (userDetails != null) {
      //   log(userDetails.displayName.toString());
      // } else {
      //   log("No user");
      // }

      // Map<String, dynamic> userMap = {
      //   'uid': userDetails!.uid,
      //   "email": userDetails.email,
      //   "username": userDetails.email!.split('@').first,
      //   "name": userDetails.displayName,
      //   "imgUrl": userDetails.photoURL,
      // };

      // await _UserBox.put('userMap', userMap).whenComplete(() {
      //   print('Data Saved locally!');
      // });

      //  Svaing in local session ------->

      // UserDetails.userEmail = userDetails.email!;
      // UserDetails.userDisplayName = userDetails.displayName!;
      // UserDetails.userName = userDetails.email!.split('@').first;
      // UserDetails.uid = userDetails.uid;
      // UserDetails.userProfilePic = userDetails.photoURL!;

      // FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(userDetails.uid)
      //     .get()
      //     .then(
      //   (value) {
      //     if (value.exists) {
      //       UserDetails.userDisplayName = value.data()!['name'];
      //       userMap.update('name', (value) => UserDetails.userDisplayName);
      //       _UserBox.put('userMap', userMap);
      //       Navigator.pushReplacement(
      //           context, MaterialPageRoute(builder: (context) => HomeUi()));
      //     } else {
      //       Map<String, dynamic> userInfoMap = {
      //         'uid': userDetails.uid,
      //         "email": userDetails.email,
      //         "username": userDetails.email!.split('@').first,
      //         "name": userDetails.displayName,
      //         "imgUrl": userDetails.photoURL,
      //         'income': 0,
      //         'expense': 0,
      //         'currentBalance': 0,
      //       };
      //       databaseMethods.addUserInfoToDB(userDetails.uid, userInfoMap).then(
      //         (value) {
      //           Navigator.pushReplacement(
      //               context, MaterialPageRoute(builder: (context) => HomeUi()));
      //         },
      //       );
      //     }
      //   },
      // );
      return 'success';
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
