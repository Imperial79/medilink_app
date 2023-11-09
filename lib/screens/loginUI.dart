import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/dashboardUI.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  // bool isVisible = false;
  // bool _showPassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/pattern-bg.webp'),
            opacity: .2,
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome again,',
                  style: kTitleStyle(
                    context,
                    fontSize: sdp(context, 20),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Login to continue',
                  style: kTitleStyle(
                    context,
                    fontSize: sdp(context, 13),
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
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: kRadius(10),
                    border: Border.all(
                      color: Colors.grey.shade400,
                    ),
                  ),
                  child: OTPTextField(
                    length: 5,
                    margin: EdgeInsets.only(bottom: 10),
                    keyboardType: TextInputType.number,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: sdp(context, 20),
                    style: TextStyle(fontSize: 17),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    onCompleted: (pin) {
                      print("Completed: " + pin);
                    },
                  ),
                ),
                height20,
                ElevatedButton(
                  onPressed: () {
                    NavPush(context, DashboardUI());
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'LOGIN',
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
                    Text('or Continue with'),
                    Flexible(
                        child: Divider(
                      indent: 10,
                    )),
                  ],
                ),
                height20,
                ElevatedButton(
                  onPressed: () {},
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
                        'Sign In with Google',
                        style: TextStyle(color: Colors.black),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: EdgeInsets.all(20.0),
      //   child: SafeArea(
      //     child: ElevatedButton(
      //       onPressed: () {
      //         NavPush(context, DashboardUI());
      //       },
      //       child: Text('Login'),
      //     ),
      //   ),
      // ),
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
