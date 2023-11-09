import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/Job%20detail%20screen/jobDetailUI.dart';
import '../utils/colors.dart';
import '../utils/components.dart';
import '../utils/sdp.dart';

class JobCard extends StatefulWidget {
  const JobCard({super.key});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        NavPush(context, JobDetailUI());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: .5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Card(
                  //   color: kPillColor,
                  //   elevation: 0,
                  //   margin: EdgeInsets.zero,
                  //   shape: StadiumBorder(),
                  //   child: Padding(
                  //     padding:
                  //         EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  //     child:

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/location.svg',
                        height: sdp(context, 17),
                        colorFilter: kSvgColor(kPrimaryColor),
                      ),
                      width5,
                      Text(
                        'Bangalore, India',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: sdp(context, 10),
                        ),
                      ),
                    ],
                  ),
                  //   ),
                  // ),
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      'assets/icons/saved.svg',
                      height: sdp(context, 15),
                    ),
                  ),
                ],
              ),
            ),
            height5,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Nursing Assistant, Prescott Nursing and Rehab- Earn Up to \$27 an Hour',
                style: TextStyle(
                    fontSize: sdp(context, 13),
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            height10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
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
            ),
            height10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  statsCard(context, label: 'CTC', content: 'INR 20,000'),
                  width5,
                  statsCard(context, label: 'Experience', content: '0-2 Years'),
                  width5,
                  statsCard(context, label: 'Openings', content: '10'),
                ],
              ),
            ),
            height10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: sdp(context, 8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'As a 100% employee-owned company, we are deeply invested in enhancing the quality of every life we touch. Atrium is more than skilled nursing center, it is a center of compassion, where every heart and set of hands are committed to a common goal. We believe in extending compassion and respect to each other, to our residents and their families, and to every guest who walks through our doors.',
                style: TextStyle(
                  fontSize: sdp(context, 9),
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            height10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
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
            ),
            height15,
          ],
        ),
      ),
    );
  }

  // Widget _attachmentCard(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15),
  //       color: Colors.grey.shade100,
  //     ),
  //     child: Row(
  //       children: [
  //         Card(
  //           elevation: 0,
  //           color: Colors.black,
  //           child: Padding(
  //             padding: EdgeInsets.all(12),
  //             child: SvgPicture.asset(
  //               'assets/icons/attachment.svg',
  //               height: sdp(context, 15),
  //               colorFilter: kSvgColor(Colors.white),
  //             ),
  //           ),
  //         ),
  //         width10,
  //         Expanded(
  //           child: Text(
  //             'Design Brief.pdf',
  //             style: TextStyle(fontWeight: FontWeight.w600),
  //           ),
  //         ),
  //         width10,
  //         IconButton(
  //           onPressed: () {},
  //           icon: Icon(
  //             Icons.file_download_outlined,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
