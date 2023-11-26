import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medilink/screens/Auth/splashUI.dart';
import 'package:medilink/utils/colors.dart';
import 'utils/components.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    configOneSignel();
  }

  void configOneSignel() {
    OneSignal.shared.setAppId("6e30bde6-eb38-4154-bb9c-98d8799ae37c");
  }

  @override
  Widget build(BuildContext context) {
    kSystemColors();
    return MaterialApp(
      title: 'Medilink',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: kThemeData(),
      home: SplashUI(),
    );
  }
}
