import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medilink/screens/welcomeUI.dart';
import 'package:medilink/utils/colors.dart';
import 'utils/components.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
