import 'package:flutter/material.dart';
import 'package:medilink/Recruiter_Portal/recruiterWebviewUI.dart';
import 'package:medilink/screens/Auth/loginUI.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';

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
              height20,
              MaterialButton(
                onPressed: () {
                  navPush(context, LoginUI());
                },
                color: kPrimaryColor,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: kRadius(10)),
                textColor: Colors.white,
                child: SizedBox(
                  width: double.infinity,
                  child: Text('Job Finder'),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  navPush(context, RecruiterWebViewUI());
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
            ],
          ),
        ),
      ),
    );
  }
}
