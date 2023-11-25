import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medilink/dashboardUI.dart';
import 'package:medilink/screens/welcomeUI.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/sdp.dart';
import '../../utils/constants.dart';

class SplashUI extends StatefulWidget {
  const SplashUI({super.key});

  @override
  State<SplashUI> createState() => _SplashUIState();
}

class _SplashUIState extends State<SplashUI> {
  @override
  void initState() {
    super.initState();
    _functionCaller();
  }

  Future<void> _functionCaller() async {
    _auth();
  }

  Future<void> _auth() async {
    var dataResult = await apiCallBack(
      method: "POST",
      path: "/users/auth.php",
      body: {},
    );
    if (!dataResult['error']) {
      userData = dataResult['response'];
      navPushReplacement(context, const DashboardUI());
    } else {
      navPushReplacement(context, const WelcomeUI());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/icons/loading-animation.json',
          height: sdp(context, 200),
        ),
      ),
    );
  }
}
