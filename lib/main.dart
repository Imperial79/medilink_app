import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medilink/screens/welcomeUI.dart';
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
    OneSignal.shared.setAppId("b44e21a1-3a59-4eaf-ac99-316c3d91fdf7");
  }

  @override
  Widget build(BuildContext context) {
    kSystemColors();
    return MaterialApp(
      title: 'Medilink',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: kThemeData(),
      home: WelcomeUI(),
    );
  }
}
