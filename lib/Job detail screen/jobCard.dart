import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/Job%20detail%20screen/vacancyDetailsUI.dart';
import 'package:medilink/utils/constants.dart';
import '../utils/colors.dart';
import '../utils/components.dart';
import '../utils/sdp.dart';

class JobCard extends StatefulWidget {
  final data;
  const JobCard({super.key, this.data});

  @override
  State<JobCard> createState() => _JobCardState(data: data);
}

class _JobCardState extends State<JobCard> {
  final data;
  _JobCardState({this.data});

  List tagsList = [];
  @override
  void initState() {
    super.initState();
    tagsList = data['tags'].split("#");
  }

  Future<void> bookmarkVacancy(vacancyId) async {
    try {
      await apiCallBack(
        method: "POST",
        path: "/vacancy/bookmark-vacancy.php",
        body: {
          "vacancyId": vacancyId,
        },
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navPush(
          context,
          VacancyDetailUI(
            vacancyId: data['id'],
          ),
        );
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
            height5,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                        data['companyCity'] + ', ' + data['companyState'],
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
                    onPressed: () {
                      bookmarkVacancy(data['id']);
                      setState(() {
                        data['isBookmarked'] =
                            data['isBookmarked'] == 'true' ? 'false' : 'true';
                      });
                      kSnackBar(context,
                          content: data['isBookmarked'] == 'true'
                              ? "Bookmarked Vacancy"
                              : "Removed from bookmark");
                    },
                    icon: SvgPicture.asset(
                      data['isBookmarked'] == 'true'
                          ? 'assets/icons/saved-filled.svg'
                          : 'assets/icons/saved.svg',
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
                data['roleTitle'] + ' | ' + data['companyName'],
                style: TextStyle(
                    fontSize: sdp(context, 13),
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            height5,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'Posted on ' + formatDate(data['postDate']),
                      style: TextStyle(
                        fontSize: sdp(context, 9),
                        color: Colors.black,
                      ),
                    ),
                  ),
                  kBulletSeperator(),
                  Flexible(
                    child: Text(
                      'Recruiter Verified',
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
                  statsCard(context, label: 'CTC', content: data['salary']),
                  width5,
                  statsCard(context,
                      label: 'Experience', content: data['experience']),
                  width5,
                  statsCard(context,
                      label: 'Openings', content: data['opening']),
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
                data['requirements'],
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
                children: List.generate(
                  tagsList.length,
                  (index) {
                    return Pill.label(
                      label: tagsList[index],
                      labelColor: Colors.black,
                    );
                  },
                ),
              ),
            ),
            height10,
          ],
        ),
      ),
    );
  }
}
