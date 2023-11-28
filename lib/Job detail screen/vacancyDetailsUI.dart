import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/screens/submitApplicationUI.dart';
import 'package:medilink/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/colors.dart';
import '../utils/components.dart';
import '../utils/sdp.dart';

class VacancyDetailUI extends StatefulWidget {
  final vacancyId;
  const VacancyDetailUI({super.key, required this.vacancyId});

  @override
  State<VacancyDetailUI> createState() => _VacancyDetailUIState();
}

class _VacancyDetailUIState extends State<VacancyDetailUI> {
  bool isLoading = false;
  Map<dynamic, dynamic> vacancyDetail = {};
  List tagsList = [];

  @override
  void initState() {
    super.initState();
    fetchVacancyDetails();
  }

  Future<void> fetchVacancyDetails() async {
    try {
      setState(() => isLoading = true);
      var dataResult = await apiCallBack(
        method: "POST",
        path: "/vacancy/fetch-vacancy-details.php",
        body: {
          "vacancyId": widget.vacancyId,
        },
      );

      if (!dataResult['error']) {
        setState(() {
          vacancyDetail = dataResult['response'];
          tagsList = vacancyDetail['tags'].split("#");
        });
      } else {
        vacancyDetail = {};
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(
        context,
        title: vacancyDetail.isEmpty
            ? ''
            : 'Job #' +
                vacancyDetail['id'] +
                ' | ' +
                vacancyDetail['roleTitle'] +
                ' | ' +
                vacancyDetail['companyName'],
      ),
      body: Stack(
        children: [
          vacancyDetail.isEmpty
              ? SizedBox()
              : SingleChildScrollView(
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
                            vacancyDetail['companyCity'] +
                                ', ' +
                                vacancyDetail['companyState'],
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
                          vacancyDetail['companyImage'],
                          fit: BoxFit.contain,
                        ),
                      ),
                      height10,
                      Text(
                        vacancyDetail['roleTitle'] +
                            ' | ' +
                            vacancyDetail['companyName'],
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
                              'Posted on ' +
                                  formatDate(vacancyDetail['postDate']),
                              style: TextStyle(
                                fontSize: sdp(context, 10),
                              ),
                            ),
                          ),
                          kBulletSeperator(color: Colors.black),
                          Flexible(
                            child: Text(
                              'Hospital Verified',
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
                          statsCard(context,
                              label: 'CTC', content: vacancyDetail['salary']),
                          width5,
                          statsCard(context,
                              label: 'Experience',
                              content: vacancyDetail['experience']),
                          width5,
                          statsCard(context,
                              label: 'Openings',
                              content: vacancyDetail['opening']),
                        ],
                      ),
                      height20,
                      Text(
                        'Requirements',
                        style: kSubtitleStyle(context),
                      ),
                      height10,
                      Text(
                        vacancyDetail['requirements'],
                        style: TextStyle(
                          fontSize: sdp(context, 9),
                        ),
                      ),
                      height20,
                      Text(
                        'Preferred Point of Contact',
                        style: kSubtitleStyle(context),
                      ),
                      height10,
                      Text(
                        vacancyDetail['ppoc'],
                        style: TextStyle(
                          fontSize: sdp(context, 9),
                        ),
                      ),
                      height20,
                      Text(
                        'Special Note',
                        style: kSubtitleStyle(context),
                      ),
                      height10,
                      Text(
                        vacancyDetail['specialRemark'],
                        style: TextStyle(
                          fontSize: sdp(context, 9),
                        ),
                      ),
                      height10,
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 10,
                        spacing: 10,
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
                      height20,
                      Text(
                        'Attachment',
                        style: kSubtitleStyle(context),
                      ),
                      height10,
                      _attachmentCard(context),
                      kHeight(sdp(context, 100))
                    ],
                  ),
                ),
          isLoading ? fullScreenLoading(context) : SizedBox()
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (vacancyDetail.isEmpty) {
              kSnackBar(context,
                  content: "This vacancy is expired. Try different");
            } else {
              navPush(
                  context, SubmitApplicationUI(vacancyDetail: vacancyDetail));
            }
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
              vacancyDetail['attachmentName'],
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          width10,
          IconButton(
            onPressed: () async {
              if (!await launchUrl(Uri.parse(vacancyDetail['attachment']))) {
                throw Exception('Could not launch');
              }
            },
            icon: Icon(
              Icons.file_download_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
