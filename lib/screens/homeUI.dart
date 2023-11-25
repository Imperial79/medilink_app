import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/Job%20Card/jobCard.dart';
import 'package:medilink/dashboardUI.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';

import '../utils/colors.dart';

class HomeUI extends StatefulWidget {
  const HomeUI({super.key});

  @override
  State<HomeUI> createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {
  String _selectedSearch = '';
  String _selectedPostTime = '';
  String _selectedLocation = '';
  String _selectedField = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              color: Color(0xFFDEE1FB),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header(context),
                    height20,
                    Text(
                      'Find a job',
                      style: kTitleStyle(context, color: Colors.black),
                    ),
                    height10,
                    _searchBar(),
                    height15,
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height10,
                  Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        'Recent Searches: ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                          fontSize: sdp(context, 10),
                        ),
                      ),
                      homePill(label: 'Physician'),
                      homePill(label: '2 years'),
                      homePill(label: 'Therapist'),
                      homePill(label: 'Bangalore, Karnataka'),
                    ],
                  ),
                  height20,
                  Text(
                    'Popular job profiles',
                    style: kSubtitleStyle(context, color: Colors.black),
                  ),
                  height10,
                  JobCard(),
                  JobCard(),
                  JobCard(),
                  JobCard(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //  Home Widgets -------------------->
  Row header(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: sdp(context, 12),
              fontFamily: 'Poppins',
            ),
            children: [
              TextSpan(
                text: 'Hey, ',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: userData['firstName'],
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                activeTabGlobal.value = 3;
              });
            },
            child: CircleAvatar()),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromARGB(255, 255, 252, 252),
        border: Border.all(
          color: Colors.grey.shade400,
        ),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/search.svg',
            colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
          ),
          width10,
          Flexible(
            child: TextField(
              cursorColor: Colors.purple.shade100,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search job profiles...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: sdp(context, 10),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // showModalBottomSheet(
              //   context: context,
              //   backgroundColor: kScaffoldColor,
              //   builder: (context) {
              //     return filterModalSheet();
              //   },
              // );
            },
            child: CircleAvatar(
              child: SvgPicture.asset(
                'assets/icons/filter.svg',
                height: sdp(context, 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterModalSheet() {
    Widget subHeading(text) => Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            text,
            style: TextStyle(
              fontSize: sdp(context, 12),
              fontWeight: FontWeight.w500,
            ),
          ),
        );
    return StatefulBuilder(
      builder: (context, setState) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter',
                        style: kTitleStyle(context),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(
                            () {
                              _selectedField = '';
                              _selectedLocation = '';
                              _selectedPostTime = '';
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red.shade100,
                        ),
                        child: Text(
                          'Clear All',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                height10,
                subHeading('Project Posted'),
                height10,
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      filterBtn(setState, label: '< 1 hours', type: 'time'),
                      filterBtn(setState, label: '< 24 hours', type: 'time'),
                      filterBtn(setState, label: 'Yesterday', type: 'time'),
                      filterBtn(setState, label: 'This Week', type: 'time'),
                    ],
                  ),
                ),
                height20,
                subHeading('Preferred Client Location'),
                height10,
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      filterBtn(setState, label: 'Canada', type: 'location'),
                      filterBtn(setState,
                          label: 'United States', type: 'location'),
                      filterBtn(setState, label: 'Hong Kong', type: 'location'),
                      filterBtn(setState, label: 'India', type: 'location'),
                      filterBtn(setState, label: 'Ukraine', type: 'location'),
                    ],
                  ),
                ),
                height20,
                subHeading('Project Field'),
                height10,
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      filterBtn(setState, label: 'UI Design', type: 'field'),
                      filterBtn(setState, label: 'Logo Design', type: 'field'),
                      filterBtn(setState,
                          label: 'Graphic Design', type: 'field'),
                      filterBtn(setState, label: 'Icon Design', type: 'field'),
                      filterBtn(setState, label: 'Video Edit', type: 'field'),
                    ],
                  ),
                ),
                height20,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget filterBtn(
    StateSetter setState, {
    required String label,
    String? type,
  }) {
    bool _isSelected;
    if (type == 'time') {
      _isSelected = _selectedPostTime == label;
    } else if (type == 'location') {
      _isSelected = _selectedLocation == label;
    } else {
      _isSelected = _selectedField == label;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          if (type == 'time') {
            _selectedPostTime = label;
          } else if (type == 'location') {
            _selectedLocation = label;
          } else {
            //  selected field
            _selectedField = label;
          }
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: _isSelected ? kPrimaryColorAccent : null,
          border: Border.all(
            color: kPrimaryColorAccent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: _isSelected ? Colors.black : kPrimaryColorAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget homePill({
    Widget? icon,
    required String label,
    Color? pillColor,
    Color? labelColor,
    bool hasShadow = true,
  }) {
    bool _isSelected = _selectedSearch == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedSearch = label;
        });
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: _isSelected ? kPrimaryColor : null,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: !_isSelected ? Colors.grey.shade300 : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
                color: _isSelected
                    ? kPrimaryColorAccent.withOpacity(0.7)
                    : Colors.transparent,
                blurRadius: 20,
                spreadRadius: 1,
                offset: Offset(0, 5)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon != null
                ? Padding(padding: EdgeInsets.only(right: 6), child: icon)
                : SizedBox.shrink(),
            Text(
              label,
              style: TextStyle(
                color: _isSelected ? Colors.white : Colors.black,
                fontSize: 10,
                fontWeight: _isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
