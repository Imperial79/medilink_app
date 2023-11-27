import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/screens/Profile/uploadResumeUI.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';

import '../utils/colors.dart';

class SubmitApplicationUI extends StatefulWidget {
  final vacancyDetail;
  const SubmitApplicationUI({super.key, required this.vacancyDetail});

  @override
  State<SubmitApplicationUI> createState() => _SubmitApplicationUIState();
}

class _SubmitApplicationUIState extends State<SubmitApplicationUI> {
  bool isLoading = false;
  bool readLess = true;
  int _selectedResume = -1;
  @override
  void initState() {
    super.initState();
    fetchResumes();
  }

  Future<void> fetchResumes() async {
    try {
      setState(() => isLoading = true);
      var dataResult = await apiCallBack(
        method: "POST",
        path: "/resume/fetch-my-resumes.php",
        body: {},
      );
      if (!dataResult['error']) {
        resumeList = dataResult['response'];
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> applyForVacancy() async {
    try {
      setState(() => isLoading = true);
      var dataResult = await apiCallBack(
        method: "POST",
        path: "/application/apply-for-vacancy.php",
        body: {
          "vacancyId": widget.vacancyDetail['id'],
          "resumeId": resumeList[_selectedResume]['id'],
        },
      );
      if (!dataResult['error']) {
        kSnackBar(context,
            content: dataResult['message'], isDanger: dataResult['error']);
      } else {
        kSnackBar(context,
            content: dataResult['message'], isDanger: dataResult['error']);
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(context, title: 'Submit Application'),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _projectDetailsCard(context),
                height20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select saved resume',
                      style: TextStyle(
                        fontSize: sdp(context, 11),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CircleAvatar(
                      radius: 15,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: IconButton(
                          onPressed: () {
                            navPush(context, UploadResumeUI());
                          },
                          icon: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
                height10,
                Column(
                  children: List.generate(resumeList.length, (index) {
                    return _resumeTile(index);
                  }),
                )
              ],
            ),
          ),
          isLoading ? fullScreenLoading(context) : SizedBox()
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
          onPressed: () {
            if (_selectedResume >= 0) {
              applyForVacancy();
            } else {
              kSnackBar(context,
                  content: "Please select a resume", isDanger: true);
            }
          },
          child: Text(
            'Apply & Submit my Resume',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _resumeTile(int index) {
    bool isActive = _selectedResume == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedResume = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        decoration: BoxDecoration(
          color: isActive ? kPillColor.withOpacity(0.7) : Colors.grey.shade100,
          border: Border.all(color: isActive ? kPrimaryColor : Colors.grey),
          borderRadius: kRadius(10),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/resume.svg',
              height: sdp(context, 20),
              colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
            ),
            width10,
            Text(
              resumeList[index]['resumeName'],
              style: TextStyle(
                fontSize: sdp(context, 10),
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            _selectedResume == index
                ? Icon(
                    Icons.check,
                    size: sdp(context, 12),
                    color: Colors.green,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _projectDetailsCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: kRadius(15),
        border: Border.all(
          color: Colors.grey.shade400,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.vacancyDetail['roleTitle'] +
                " | " +
                widget.vacancyDetail['companyName'],
            style: TextStyle(
              fontSize: sdp(context, 11),
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          height10,
          Row(
            children: [
              Flexible(
                child: Text(
                  'Posted on ' + formatDate(widget.vacancyDetail['postDate']),
                  style: TextStyle(
                    fontSize: sdp(context, 9),
                    color: Colors.black,
                  ),
                ),
              ),
              kBulletSeperator(),
              Flexible(
                child: Text(
                  'Hospital Verified',
                  style: TextStyle(
                    fontSize: sdp(context, 9),
                    color: Colors.black,
                  ),
                ),
              ),
              width5,
              Icon(
                Icons.verified,
                color: kPrimaryColor,
                size: sdp(context, 10),
              ),
            ],
          ),
          height10,
          Text(
            widget.vacancyDetail['companyBio'],
            style: TextStyle(
              fontSize: sdp(context, 9),
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            maxLines: readLess ? 2 : 200,
            overflow: TextOverflow.ellipsis,
          ),
          height10,
          kTextButton(
            onTap: () {
              setState(() {
                readLess = !readLess;
              });
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  !readLess ? 'Hide Details' : 'Show Details',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: sdp(context, 10),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  !readLess
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: kPrimaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
