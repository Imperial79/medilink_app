import 'package:flutter/material.dart';
import 'package:medilink/Recruiter/recruiterUI.dart';
import 'package:medilink/screens/loginUI.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';

class WelcomeUI extends StatefulWidget {
  const WelcomeUI({super.key});

  @override
  State<WelcomeUI> createState() => _WelcomeUIState();
}

class _WelcomeUIState extends State<WelcomeUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Image.asset('assets/images/medLink.jpg')),
              // Text(
              //   'Medilink',
              //   style: kTitleStyle(
              //     context,
              //     fontSize: sdp(context, 20),
              //     fontWeight: FontWeight.w700,
              //   ),
              // ),
              // Text(
              //   'Find jobs that fulfills your resume',
              //   style: kSubtitleStyle(
              //     context,
              //     fontWeight: FontWeight.w400,
              //   ),
              // ),
              height20,
              MaterialButton(
                onPressed: () {
                  NavPush(context, LoginUI());
                },
                color: kPrimaryColor,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: kRadius(10)),
                textColor: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  child: Text('Get Started'),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  NavPush(context, RecruiterUI());
                },
                color: kPillColor,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: kRadius(10)),
                textColor: kPrimaryColor,
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Recruiter',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              height20,
              Row(
                children: [
                  Text(
                    'Already a user?',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  width10,
                  kTextButton(
                    onTap: () {
                      NavPush(context, LoginUI());
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: kPrimaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
