import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';

import '../utils/colors.dart';

class ProposalUI extends StatefulWidget {
  const ProposalUI({super.key});

  @override
  State<ProposalUI> createState() => _ProposalUIState();
}

class _ProposalUIState extends State<ProposalUI> {
  bool readLess = true;
  int selectedBidType = 0;
  int milestoneCount = 1;
  int _selectedResume = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(context, title: 'Submit Application'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Apply to',
              style: TextStyle(
                fontSize: sdp(context, 11),
                fontWeight: FontWeight.w600,
              ),
            ),
            height10,
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
                      onPressed: () {},
                      icon: Icon(Icons.add),
                    ),
                  ),
                ),
              ],
            ),
            height10,
            _resumeTile(0),
            _resumeTile(1),
            _resumeTile(2),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
          onPressed: () {
            NavPush(context, ProposalUI());
          },
          child: Text(
            'Send Proposal',
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
            ),
            width10,
            Text(
              'Resume_Updated',
              style: TextStyle(
                fontSize: sdp(context, 10),
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(
              Icons.star,
              size: sdp(context, 12),
              color: Colors.orange,
            ),
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
            'Nursing Assistant, Prescott Nursing and Rehab- Earn Up to \$27 an Hour',
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
                  'Posted 23 minutes ago',
                  style: TextStyle(
                    fontSize: sdp(context, 9),
                    color: Colors.black,
                  ),
                ),
              ),
              kBulletSeperator(),
              Flexible(
                child: Text(
                  'Payment Verified',
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
            'As a 100% employee-owned company, we are deeply invested in enhancing the quality of every life we touch. Atrium is more than skilled nursing center, it is a center of compassion, where every heart and set of hands are committed to a common goal. We believe in extending compassion and respect to each other, to our residents and their families, and to every guest who walks through our doors.',
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

  Widget projectBidTypeBtn({String? label, required int index}) {
    bool _isSelected = selectedBidType == index;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          selectedBidType = index;
        });
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: _isSelected ? kPrimaryColor : Colors.grey,
              ),
            ),
            child: CircleAvatar(
              radius: 8,
              backgroundColor: _isSelected ? kPrimaryColor : Colors.transparent,
            ),
          ),
          width5,
          Text(
            label!,
            style: TextStyle(
              color: _isSelected ? kPrimaryColor : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
