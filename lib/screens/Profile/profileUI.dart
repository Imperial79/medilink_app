import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/dashboardUI.dart';
import 'package:medilink/screens/Profile/editProfileUI.dart';
import 'package:medilink/screens/Profile/myApplicationsUI.dart';
import 'package:medilink/screens/Profile/uploadResumeUI.dart';
import 'package:medilink/screens/Auth/welcomeUI.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({super.key});

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  bool isLoading = false;

  Future<void> logout() async {
    try {
      setState(() => isLoading = true);
      var dataResult =
          await apiCallBack(method: "GET", path: "/users/logout.php");

      if (!dataResult['error']) {
        final FirebaseAuth auth = FirebaseAuth.instance;
        await auth.signOut();
        navPopUntilPush(context, WelcomeUI());
      }

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  kPageHeader(context, title: 'Profile'),
                  height20,
                  Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              navPush(context, EditProfileUI());
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundImage:
                                    NetworkImage(userData['image']),
                              ),
                            ),
                          ),
                          width20,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userData['firstName'] +
                                      " " +
                                      userData['lastName'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: sdp(context, 11),
                                  ),
                                ),
                                Text(
                                  userData['roleTitle'].toString() +
                                      ' | ' +
                                      userData['specialization'].toString(),
                                  style: TextStyle(
                                    fontSize: sdp(context, 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      height10,
                      GestureDetector(
                        onTap: () {
                          navPush(context, EditProfileUI());
                        },
                        child: Container(
                          alignment: Alignment.topCenter,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: kPrimaryColorAccentLighter,
                            borderRadius: kRadius(15),
                          ),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  height10,
                  Row(
                    children: [
                      Text(
                        'Personal',
                        style: TextStyle(fontSize: sdp(context, 10)),
                      ),
                      Flexible(
                        child: Divider(
                          indent: 20,
                        ),
                      ),
                    ],
                  ),
                  // kHeight(40),
                  // subHeader('Personal'),
                  height10,
                  settingsButton(
                    onTap: () {
                      navPush(context, UploadResumeUI());
                    },
                    iconPath: 'assets/icons/resume.svg',
                    label: 'Saved Resumes',
                    subtitle: 'View your saved resumes',
                  ),
                  settingsButton(
                    onTap: () {
                      navPush(context, MyApplicationsUI());
                    },
                    iconPath: 'assets/icons/my-application.svg',
                    label: 'Applied Jobs',
                    subtitle: 'View your recent submitted applications',
                  ),
                  settingsButton(
                    onTap: () {
                      setState(() {
                        activeTabGlobal.value = 2;
                      });
                    },
                    iconPath: 'assets/icons/pending.svg',
                    label: 'Saved Jobs',
                    subtitle: 'View your bookmarked job profiles',
                  ),
                  height10,
                  Row(
                    children: [
                      Text(
                        'System',
                        style: TextStyle(fontSize: sdp(context, 10)),
                      ),
                      Flexible(
                        child: Divider(
                          indent: 20,
                        ),
                      ),
                    ],
                  ),
                  // subHeader('System'),
                  height20,
                  GestureDetector(
                    onTap: () {
                      logout();
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: kRadius(15),
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isLoading ? fullScreenLoading(context) : SizedBox()
          ],
        ),
      ),
    );
  }

  Container subHeader(String title) {
    return Container(
      width: double.infinity,
      color: kScaffoldColor,
      child: Text(
        title,
        style: TextStyle(fontSize: sdp(context, 10)),
      ),
    );
  }

  Widget settingsButton({
    void Function()? onTap,
    required String label,
    required String subtitle,
    required String iconPath,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: kRadius(10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                iconPath,
                height: sdp(context, 20),
              ),
              width20,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: sdp(context, 11),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: sdp(context, 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
