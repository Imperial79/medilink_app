import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/screens/proposalUI.dart';
import '../utils/colors.dart';
import '../utils/components.dart';
import '../utils/sdp.dart';

class JobDetailUI extends StatefulWidget {
  const JobDetailUI({super.key});

  @override
  State<JobDetailUI> createState() => _JobDetailUIState();
}

class _JobDetailUIState extends State<JobDetailUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(
        context,
        title: 'JOB#1233',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height10,
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/location.svg',
                  height: sdp(context, 12),
                  colorFilter: kSvgColor(kPrimaryColor),
                ),
                width5,
                Text(
                  'Bangalore, India',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: sdp(context, 10),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            height20,
            SizedBox(
              width: sdp(context, 100),
              height: sdp(context, 100),
              child: Image.network(
                'https://hospitalcareers.com/files/pictures/emp_logo_2858.jpg',
                fit: BoxFit.contain,
              ),
            ),
            height10,
            Text(
              'Front Office Admin Support - On cology, Bangalore, India',
              style: TextStyle(
                fontSize: sdp(context, 12),
                fontWeight: FontWeight.w600,
              ),
            ),
            height10,
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Posted 23 minutes ago',
                    style: TextStyle(
                      fontSize: sdp(context, 10),
                    ),
                  ),
                ),
                kBulletSeperator(color: Colors.black),
                Flexible(
                  child: Text(
                    'Payment Verified',
                    style: TextStyle(
                      fontSize: sdp(context, 10),
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
            height20,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                statsCard(context, label: 'CTC', content: 'INR 20,000'),
                width5,
                statsCard(context, label: 'Experience', content: '0-2 Years'),
                width5,
                statsCard(context, label: 'Openings', content: '10'),
              ],
            ),
            height20,
            Text(
              'Employement Type',
              style: kSubtitleStyle(context),
            ),
            height10,
            Text(
              'Full-Time',
              style: TextStyle(
                fontSize: sdp(context, 9),
              ),
            ),
            height20,
            Text(
              'Job Description',
              style: kSubtitleStyle(context),
            ),
            height10,
            Text(
              'Come to Memphis and join a very busy practice seeking to replace a retiring physician. We seek a well-trained interventional cardiologist for a full-time, employed position. Due to tremendous community need this is an excellent opportunity for candidates looking to hit the ground running and be busy quickly. Along with the great administrative team the group also has a fantastic and experienced support staff. As a member of our large multi-specialty group you will have full support from both of our local hospitals and enjoy: Guaranteed salary with production bonus Comprehensive benefits including health, dental, life, disability, 401k with matching and salary deferment program Billing, Coding, Collections done in-house Top Executive & Administrative support, IT, HR, legal Vacation + CME with a stipend Malpractice insurance Memphis is a vibrant city located along the Mississippi River and is known for its musical history and cuisine. Blues, jazz, and rock and roll spill out from the clubs along Beale Street, and restaurants dish up some of the nation\'s best barbeque and soul food. Nicknamed “The Birthplace of Rock and Roll”, Memphis is also home to the Sun Studio, where musical legends such as Elvis Presley, B.B. King, and Johnny Cash all recorded albums. Elvis Presley\'s Graceland mansion is one of the most-visited houses in the country. Interested candidates should submit a current CV for immediate consideration. Sorry, no visa sponsorship is available for this position.',
              style: TextStyle(
                fontSize: sdp(context, 9),
              ),
            ),
            height20,
            Text(
              'Responsibilities',
              style: kSubtitleStyle(context),
            ),
            height10,
            kUnorderedList(
              'Provide Resident care according to an approved Care Plan',
            ),
            kUnorderedList(
              'Assist with daily activities, resident safety, and personal care',
            ),
            kUnorderedList(
              'Understand and practice infection control procedures',
            ),
            kUnorderedList(
              'Comply with all documentation/record-keeping policies including vitals',
            ),
            height10,
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              runSpacing: 10,
              spacing: 10,
              children: [
                Pill.label(
                  label: 'Full Time',
                  labelColor: Colors.black,
                ),
                Pill.label(
                  label: 'Night Shift',
                  labelColor: Colors.black,
                ),
                Pill.label(
                  label: 'Immediate Join',
                  labelColor: Colors.black,
                ),
                Pill.label(
                  label: 'Freshers',
                  labelColor: Colors.black,
                ),
              ],
            ),
            height20,
            Text(
              'Attachment',
              style: kSubtitleStyle(context),
            ),
            height10,
            _attachmentCard(context),
            kHeight(sdp(context, 80))
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SafeArea(
        child: GestureDetector(
          onTap: () {
            navPush(context, ProposalUI());
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: kRadius(100),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.5),
                  blurRadius: 60,
                  spreadRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Text(
              'Apply Now',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _attachmentCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey.shade100,
      ),
      child: Row(
        children: [
          Card(
            elevation: 0,
            color: Colors.black,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: SvgPicture.asset(
                'assets/icons/attachment.svg',
                height: sdp(context, 15),
                colorFilter: kSvgColor(Colors.white),
              ),
            ),
          ),
          width10,
          Expanded(
            child: Text(
              'Salary Chart.pdf',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          width10,
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.file_download_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
