import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:medilink/dashboardUI.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final specialization = TextEditingController();
  final address = TextEditingController();
  final dob = TextEditingController();

  String _selectedGender = 'M';

  @override
  void dispose() {
    super.dispose();
    firstName.dispose();
    lastName.dispose();
    phone.dispose();
    email.dispose();
    specialization.dispose();
    address.dispose();
  }

  Future<void> _registerUsingGoogle() async {
    try {
      setState(() => isLoading = true);
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

      var dataResult = await apiCallBack(
        method: "POST",
        path: "/users/check-user-with-google.php",
        body: {
          "gmail": userDetails?.email,
          "uid": userDetails?.uid,
        },
      );

      print(dataResult);

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      print(e);
    }
  }

  Future<void> _loginUsingGoogle() async {
    try {
      setState(() => isLoading = true);
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

      var dataResult = await apiCallBack(
        method: "POST",
        path: "/users/check-user.php",
      );

      setState(() => isLoading = true);
    } catch (e) {
      setState(() => isLoading = true);
      print(e);
    }
  }

  // Future<void> _loginUsingGoogle() async {
  //   try {
  //     setState(() => isLoading = true);
  //     await AuthMethods.signInWithgoogle(context);
  //     setState(() => isLoading = false);
  //   } catch (e) {
  //     log(e.toString());
  //     setState(() => isLoading = false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/images/pattern-bg.webp'),
        //     opacity: .2,
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,',
                    style: kTitleStyle(
                      context,
                      fontSize: sdp(context, 20),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Register as a Job Finder',
                    style: kTitleStyle(
                      context,
                      fontSize: sdp(context, 13),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  height20,
                  Row(
                    children: [
                      Flexible(
                        child: kTextField(
                          context,
                          controller: firstName,
                          bgColor: Colors.white,
                          hintText: 'John',
                          label: 'First Name',
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      width10,
                      Flexible(
                        child: kTextField(
                          context,
                          controller: lastName,
                          bgColor: Colors.white,
                          hintText: 'Smith',
                          label: 'Last Name',
                          maxLength: 10,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  height10,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: kTextField(
                          context,
                          controller: dob,
                          readOnly: true,
                          onFieldTap: () async {
                            DateTime? dobDate = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1970),
                              lastDate: DateTime(DateTime.now().year - 18),
                            );

                            print(DateFormat('yyyy/m/dd').format(dobDate!));
                          },
                          bgColor: Colors.white,
                          hintText: '29/06/1998',
                          label: "DOB",
                          maxLength: 10,
                          keyboardType: TextInputType.datetime,
                        ),
                      ),
                      width10,
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: kRadius(10),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: DropdownButton(
                            value: _selectedGender,
                            underline: SizedBox.shrink(),
                            isDense: true,
                            isExpanded: true,
                            dropdownColor: Colors.white,
                            borderRadius: kRadius(10),
                            alignment: AlignmentDirectional.bottomCenter,
                            elevation: 24,
                            padding: EdgeInsets.all(8),
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                            iconSize: 20,
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                            ),
                            items: [
                              DropdownMenuItem(
                                value: 'M',
                                child: Text('Male'),
                              ),
                              DropdownMenuItem(
                                value: 'F',
                                child: Text('Female'),
                              ),
                              DropdownMenuItem(
                                value: 'O',
                                child: Text('Others'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value!;
                              });
                            },
                          ),
                        ),
                        // kTextField(
                        //   context,
                        //   bgColor: Colors.white,
                        //   hintText: 'M/F/O',
                        //   label: "Gender",
                        //   maxLength: 10,
                        //   keyboardType: TextInputType.phone,
                        // ),
                      ),
                    ],
                  ),
                  height10,
                  kTextField(
                    context,
                    controller: specialization,
                    bgColor: Colors.white,
                    hintText: 'MBBS, MD ...',
                    label: "Specialization",
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                  ),
                  height10,
                  kTextField(
                    context,
                    controller: address,
                    bgColor: Colors.white,
                    hintText: 'Street, City, State',
                    label: "Address",
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                  ),
                  height10,
                  kTextField(
                    context,
                    controller: email,
                    bgColor: Colors.white,
                    hintText: 'someone@example.com',
                    label: "Email",
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                  ),
                  height10,
                  kTextField(
                    context,
                    controller: phone,
                    bgColor: Colors.white,
                    hintText: '9XXXXXXX556',
                    label: "Phone",
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ElevatedButton(
            onPressed: () {
              navPush(context, DashboardUI());
            },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'REGISTER',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row kTextFieldThis(
    BuildContext context, {
    TextEditingController? controller,
    Widget? prefix,
    required String hintText,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Row(
      children: [
        prefix != null
            ? Padding(
                padding: EdgeInsets.only(right: 20),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: kPrimaryColorAccent,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: FittedBox(child: prefix),
                  ),
                ),
              )
            : SizedBox(),
        Flexible(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(
                color: Colors.white,
                fontSize: sdp(context, 20),
                fontWeight: FontWeight.w600),
            cursorColor: Colors.white,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              suffix: suffix,
              hintText: hintText,
              hintStyle: TextStyle(
                color: kPrimaryColorAccent,
                fontSize: sdp(context, 20),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
