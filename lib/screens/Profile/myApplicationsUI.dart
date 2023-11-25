import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/Job%20detail%20screen/jobDetailUI.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/sdp.dart';

class MyApplicationsUI extends StatefulWidget {
  const MyApplicationsUI({super.key});

  @override
  State<MyApplicationsUI> createState() => _MyApplicationsUIState();
}

class _MyApplicationsUIState extends State<MyApplicationsUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(context, title: 'Applied Jobs'),
      body: SafeArea(
        child: ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          padding: EdgeInsets.all(15),
          itemBuilder: (context, index) {
            return _appliedJobsCard();
          },
        ),
      ),
    );
  }

  Widget _appliedJobsCard() {
    return GestureDetector(
      onTap: () {
        navPush(context, JobDetailUI());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: kRadius(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(
                  width: sdp(context, 50),
                  height: sdp(context, 50),
                  child: Image.network(
                    'https://hospitalcareers.com/files/pictures/emp_logo_2858.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
                width10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Front Office Admin Support - On cology, Bangalore, India',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sdp(context, 9)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      height10,
                      Text(
                        'Come to Memphis and join a very busy practice seeking to replace a retiring physician. We seek a well-trained interventional cardiologist for a full-time, employed position. Due to tremendous community need this is an excellent opportunity for candidates looking to hit the ground running an',
                        style: TextStyle(
                          fontSize: sdp(context, 9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            height10,
            Row(
              children: [
                statsCard(
                  context,
                  label: 'Salary',
                  content: 'Rs. 20 LPA',
                ),
                width5,
                statsCard(
                  context,
                  label: 'Pos.',
                  content: 'Physicist',
                ),
                width5,
                statsCard(
                  context,
                  label: 'Experience',
                  content: '3-4 Yrs',
                ),
              ],
            ),
            Divider(
              color: Colors.grey.shade300,
              height: sdp(context, 20),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/attachment.svg',
                  colorFilter: kSvgColor(kPrimaryColor),
                  height: sdp(context, 10),
                ),
                width10,
                Text(
                  'Resume_updated.pdf',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: sdp(context, 9),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
