import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medilink/dashboardUI.dart';
import 'package:medilink/screens/registerUI.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final phone = TextEditingController();
  final otpController = OtpFieldController();
  String otp = '';

  bool isLoading = false;
  bool isOtpSent = false;
  bool isRegister = false;
  int counter = 0;
  late Timer timer;

  String gmail = '';
  String guid = '';

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startCountdown() {
    counter = 60;
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (counter > 0) {
        if (mounted) {
          setState(() {
            counter--;
          });
        }
      } else {
        timer.cancel();
        if (mounted) {
          setState(() {
            counter = 0;
          });
        }
      }
    });
  }

  Future<void> sendOTP() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);
    var dataResult = await apiCallBack(
      method: "POST",
      path: "/sms-service/send-otp.php",
      body: {
        "phone": phone.text,
      },
    );

    print(dataResult);

    if (!dataResult['error']) {
      setState(() {
        if (dataResult['action'] == 'Register') {
          isRegister = true;
        }
        isLoading = false;
        isOtpSent = true;
        startCountdown();
      });
    } else {
      setState(() => isLoading = false);
    }
    kSnackBar(context,
        content: dataResult['message'], isDanger: dataResult['error']);
  }

  Future<void> verifyOTP() async {
    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);
    var dataResult = await apiCallBack(
      method: "POST",
      path: "/sms-service/verify-otp.php",
      body: {
        "phone": phone.text,
        "otp": otp,
      },
    );

    if (!dataResult['error']) {
      setState(() {
        isLoading = false;
      });
      navPush(
        context,
        RegisterUI(
            type: "Phone",
            phone: phone.text,
            otp: otp,
            email: gmail,
            guid: guid),
      );
    } else {
      setState(() => isLoading = false);
      kSnackBar(context,
          content: dataResult['message'], isDanger: dataResult['error']);
    }
  }

  Future<void> loginWithPhone() async {
    setState(() => isLoading = true);
    Map<String, dynamic> body = {};
    try {
      await OneSignal.shared.getDeviceState().then((value) async {
        var fcmToken = value!.userId!;
        // print("FCM" + fcmToken.toString());
        body = {
          "phone": phone.text,
          "otp": otp,
          "fcmToken": fcmToken.toString(),
        };
      });
    } catch (e) {
      body = {
        "phone": phone.text,
        "otp": otp,
        "fcmToken": "",
      };
    }
    var dataResult = await apiCallBack(
      method: "POST",
      path: "/users/login-with-phone.php",
      body: body,
    );
    if (!dataResult['error']) {
      setState(() => isLoading = false);
      userData = dataResult['response'];
      navPushReplacement(context, const DashboardUI());
    } else {
      setState(() => isLoading = false);
      kSnackBar(context, content: dataResult['message']);
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
      body: Stack(
        children: [
          Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome,',
                      style: kTitleStyle(
                        context,
                        fontSize: sdp(context, 20),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Login/Sign Up to continue',
                      style: kTitleStyle(
                        context,
                        fontSize: sdp(context, 11),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    height10,
                    Expanded(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: MediaQuery.of(context).viewInsets.bottom == 0
                              ? Colors.white.withOpacity(0)
                              : Colors.white,
                        ),
                        child: SvgPicture.asset(
                          'assets/images/undraw_doctors_p6aq.svg',
                        ),
                      ),
                    ),
                    height10,
                    kTextField(
                      context,
                      controller: phone,
                      bgColor: Colors.white,
                      hintText: 'Eg, 99229XXX09',
                      label: 'Enter Phone',
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                    ),
                    height10,
                    Text(
                      'Enter OTP',
                      style: TextStyle(fontSize: sdp(context, 9)),
                    ),
                    kHeight(7),
                    Container(
                      padding: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: kRadius(10),
                        border: Border.all(
                          color: Colors.grey.shade400,
                        ),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: OTPTextField(
                              controller: otpController,
                              length: 5,
                              margin: EdgeInsets.only(bottom: 10),
                              keyboardType: TextInputType.number,
                              width: MediaQuery.of(context).size.width,
                              fieldWidth: sdp(context, 20),
                              style: TextStyle(fontSize: 17),
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldStyle: FieldStyle.underline,
                              onCompleted: (pin) {
                                setState(() {
                                  otp = pin.toString();
                                });
                              },
                            ),
                          ),
                          width10,
                          // kTextButton(onTap: () {}, child: Text("Send OTP")),
                          MaterialButton(
                            onPressed: () {
                              sendOTP();
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: kRadius(100),
                            ),
                            color: kPrimaryColor,
                            elevation: 0,
                            textColor: Colors.white,
                            child: Text('SEND OTP'),
                          )
                        ],
                      ),
                    ),
                    height20,
                    ElevatedButton(
                      onPressed: () {
                        if (isRegister) {
                          verifyOTP();
                        } else {
                          loginWithPhone();
                        }
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Text(
                          'PROCEED',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    height20,
                    Row(
                      children: [
                        Flexible(
                            child: Divider(
                          endIndent: 10,
                        )),
                        Text('or continue with'),
                        Flexible(
                          child: Divider(
                            indent: 10,
                          ),
                        ),
                      ],
                    ),
                    height20,
                    ElevatedButton(
                      onPressed: () async {
                        await _loginUsingGoogle();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: kRadius(100),
                          side: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google-logo.png',
                            height: sdp(context, 10),
                          ),
                          width10,
                          Text(
                            'Google',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          isLoading ? fullScreenLoading(context) : SizedBox()
        ],
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
