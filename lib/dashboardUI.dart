import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/screens/Profile/profileUI.dart';
import 'package:medilink/screens/recruitersUI.dart';
import 'package:medilink/screens/homeUI.dart';
import 'package:medilink/screens/savedUI.dart';
import 'package:medilink/utils/animated_indexed_stack.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';

ValueNotifier activeTabGlobal = new ValueNotifier(0);

class DashboardUI extends StatefulWidget {
  const DashboardUI({super.key});

  @override
  State<DashboardUI> createState() => _DashboardUIState();
}

class _DashboardUIState extends State<DashboardUI> {
  DateTime? currentBackPressTime;
  List<Widget> screens = [
    HomeUI(),
    RecruitersUI(),
    SavedUI(),
    ProfileUI(),
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSurvey();
    });
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      kSnackBar(context, content: 'Press back again to exit!', isDanger: false);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Future<void> fetchSurvey() async {
    try {
      var dataResult = await apiCallBack(
        method: "GET",
        path: "/survey/fetch-survey.php",
      );
      if (!dataResult['error']) {
        surveyPopup(context, dataResult['response']);
      }
    } catch (e) {}
  }

  Future<void> surveyResponse(surveyId, choice) async {
    try {
      Navigator.pop(context);
      var dataResult = await apiCallBack(
        method: "POST",
        path: "/survey/survey-response.php",
        body: {
          "surveyId": surveyId,
          "choice": choice,
        },
      );

      kSnackBar(context,
          content: dataResult['message'], isDanger: dataResult['error']);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: ValueListenableBuilder(
          valueListenable: activeTabGlobal,
          builder: (context, val, child) {
            return Scaffold(
              body: AnimatedIndexedStack(
                index: activeTabGlobal.value,
                children: screens,
              ),
              bottomNavigationBar: kNavigationBar(),
            );
          }),
    );
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
                  icon: 'hospital',
                  label: 'Recruiters',
                ),
                kNavigationButton(
                  index: 2,
                  icon: 'saved',
                  label: 'Saved',
                ),
                kNavigationButton(
                  index: 3,
                  icon: 'profile',
                  label: userData['firstName'] + 'djdjdjdjdjdjdj',
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
            SizedBox(
              width: 80,
              child: Center(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: sdp(context, 9),
                    color: _isSelected ? kPrimaryColor : kPrimaryColorAccent,
                    fontWeight: _isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void surveyPopup(context, var data) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: kRadius(10),
            side: BorderSide(color: Colors.grey.shade400),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(15),
            // decoration: BoxDecoration(
            //   borderRadius: kRadius(10),
            //   border: Border.all(color: Colors.grey.shade400),
            // ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Survey',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: sdp(context, 12)),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Skip'),
                    ),
                  ],
                ),
                height10,
                Text(
                  data['question'],
                ),
                height15,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        surveyResponse(data['id'], "Yes");
                      },
                      elevation: 0,
                      color: kPrimaryColorAccentLighter,
                      shape: RoundedRectangleBorder(
                        borderRadius: kRadius(10),
                        side: BorderSide(color: kPrimaryColor),
                      ),
                      child: Text("Yes"),
                    ),
                    MaterialButton(
                      onPressed: () {
                        surveyResponse(data['id'], "No");
                      },
                      elevation: 0,
                      color: Colors.red.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: kRadius(10),
                        side: BorderSide(color: Colors.red),
                      ),
                      child: Text("No"),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
