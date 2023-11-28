import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medilink/dashboardUI.dart';
import 'package:medilink/screens/Profile/myApplicationsUI.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/sdp.dart';

class ConfirmationUI extends StatefulWidget {
  const ConfirmationUI({super.key});

  @override
  State<ConfirmationUI> createState() => _ConfirmationUIState();
}

class _ConfirmationUIState extends State<ConfirmationUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Lottie.asset('assets/icons/successAnimation.json'),
              height20,
              Text(
                'Application submitted !',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: sdp(context, 20),
                ),
              ),
              height10,
              Text(
                'You\'ll be notified when there is an update',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: sdp(context, 12),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              kTextButton(
                onTap: () {
                  navPopUntilPush(context, DashboardUI());
                },
                child: Text(
                  'Go to home',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              kTextButton(
                onTap: () {
                  navPushReplacement(context, MyApplicationsUI());
                },
                child: Text(
                  'Applied jobs',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w500,
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
