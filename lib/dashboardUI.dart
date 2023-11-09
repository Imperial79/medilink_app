import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/screens/Profile/profileUI.dart';
import 'package:medilink/screens/chatUI.dart';
import 'package:medilink/screens/homeUI.dart';
import 'package:medilink/screens/savedUI.dart';
import 'package:medilink/utils/animated_indexed_stack.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/sdp.dart';

ValueNotifier activeTabGlobal = new ValueNotifier(0);

class DashboardUI extends StatefulWidget {
  const DashboardUI({super.key});

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  List<Widget> screens = [
    HomeUI(),
    ChatUI(),
    SavedUI(),
    ProfileUI(),
  ];
  // int activeTab = 0;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: activeTabGlobal,
        builder: (context, val, child) {
          return Scaffold(
            body: AnimatedIndexedStack(
              index: activeTabGlobal.value,
              children: screens,
            ),
            bottomNavigationBar: kNavigationBar(),
          );
        });
  }

  Widget kNavigationBar() {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(height: 0),
          Container(
            color: Colors.white,
            height: sdp(context, 56),
            padding: EdgeInsets.all(15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                kNavigationButton(
                  index: 0,
                  icon: 'home',
                  label: 'Home',
                ),
                kNavigationButton(
                  index: 1,
                  icon: 'chat',
                  label: 'Chat',
                ),
                kNavigationButton(
                  index: 2,
                  icon: 'saved',
                  label: 'Saved',
                ),
                kNavigationButton(
                  index: 3,
                  icon: 'profile',
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget kNavigationButton({
    required int index,
    required String icon,
    required String label,
  }) {
    bool _isSelected = activeTabGlobal.value == index;
    icon = _isSelected ? icon + "-filled" : icon;
    return Expanded(
      child: InkWell(
        radius: 20,
        onTap: () {
          setState(() {
            activeTabGlobal.value = index;
          });
        },
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/icons/$icon.svg',
              height: sdp(context, 15),
              colorFilter: kSvgColor(
                _isSelected ? kPrimaryColor : kPrimaryColorAccent,
              ),
            ),
            height5,
            Text(
              label,
              style: TextStyle(
                fontSize: sdp(context, 9),
                color: _isSelected ? kPrimaryColor : kPrimaryColorAccent,
                fontWeight: _isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
