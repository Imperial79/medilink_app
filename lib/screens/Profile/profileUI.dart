import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/dashboardUI.dart';
import 'package:medilink/screens/Profile/myApplicationsUI.dart';
import 'package:medilink/screens/Profile/uploadResumeUI.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/sdp.dart';

class ProfileUI extends StatefulWidget {
  const ProfileUI({super.key});

  @override
  State<ProfileUI> createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kPageHeader(context, title: 'Profile'),
              height20,
              Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1583864697784-a0efc8379f70?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
                        ),
                      ),
                      height5,
                      InkWell(
                        onTap: () {
                          // NavPush(context, EditProfileUI());
                        },
                        borderRadius: kRadius(100),
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Text(
                            'Edit',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: kPrimaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  width20,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vivek Verma',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sdp(context, 11),
                          ),
                        ),
                        Text(
                          'Physicist | MBBS | Dentist | 3 years Exp.',
                          style: TextStyle(
                            fontSize: sdp(context, 10),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              kHeight(40),
              Row(
                children: [
                  Text(
                    'Utilities',
                    style: TextStyle(fontSize: sdp(context, 10)),
                  ),
                  Flexible(
                    child: Divider(
                      indent: 20,
                    ),
                  ),
                ],
              ),
              kHeight(40),
              subHeader('Personal'),
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
                subtitle: 'View your pending projects',
              ),
              height10,
              subHeader('System'),
              height10,
              Container(
                alignment: Alignment.topRight,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
            ],
          ),
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
