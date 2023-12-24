import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';

class MedilinkResumeUI extends StatefulWidget {
  const MedilinkResumeUI({super.key});

  @override
  State<MedilinkResumeUI> createState() => _MedilinkResumeUIState();
}

class _MedilinkResumeUIState extends State<MedilinkResumeUI> {
  bool isLoading = false;
  Map<dynamic, dynamic> medilinkResume = userData;
  @override
  void initState() {
    super.initState();
    fetchMedilinkResume();
  }

  Future<void> fetchMedilinkResume() async {
    try {
      setState(() => isLoading = true);
      var dataResult = await apiCallBack(
        method: "GET",
        path: "/resume/fetch-medilink-resume.php",
        body: {},
      );

      if (!dataResult['error']) {
        medilinkResume = dataResult['response'];
      }

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(15),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: kRadius(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(
                              userData['image'],
                            ),
                          ),
                          height20,
                          Text(
                            medilinkResume['firstName'] +
                                " " +
                                medilinkResume['lastName'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: sdp(context, 14),
                            ),
                          ),
                          Text(
                            medilinkResume['subRole'].toUpperCase(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: sdp(context, 13),
                              letterSpacing: 1.5,
                            ),
                          ),
                          height20,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: SvgPicture.asset(
                                    'assets/icons/location.svg',
                                    height: sdp(context, 15),
                                    colorFilter: kSvgColorWhite,
                                  ),
                                ),
                              ),
                              width20,
                              Expanded(
                                child: Text(
                                  medilinkResume['address'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: sdp(context, 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height10,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Icon(
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              width20,
                              Expanded(
                                child: Text(
                                  medilinkResume['email'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: sdp(context, 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height10,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              width20,
                              Expanded(
                                child: Text(
                                  "+91 " +
                                      medilinkResume['phone']
                                          .toString()
                                          .replaceAll("+91", ""),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: sdp(context, 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          height10,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 20,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Icon(
                                    Icons.link,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              width20,
                              Expanded(
                                child: Text(
                                  medilinkResume['profileLink'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: sdp(context, 10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _dataBlock(
                            label: "PROFILE",
                            content: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                medilinkResume['bio'],
                                style: TextStyle(
                                  fontSize: sdp(context, 10),
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                          ),
                          height15,
                          _dataBlock(
                            label: "EXPERTISE",
                            content: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: List.generate(
                                  jsonDecode(medilinkResume[
                                          'expertiseDescription'])
                                      .length,
                                  (index) => kUnorderedList(
                                    jsonDecode(medilinkResume[
                                        'expertiseDescription'])[index],
                                    TextStyle(
                                      fontSize: sdp(context, 10),
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          height15,
                          _dataBlock(
                            label: "EDUCATION",
                            content: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  jsonDecode(medilinkResume[
                                          'educationDescription'])
                                      .length,
                                  (index) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        jsonDecode(medilinkResume[
                                                    'educationDescription'])[
                                                index]['courseName']
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        jsonDecode(medilinkResume[
                                                    'educationDescription'])[
                                                index]['year']
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        jsonDecode(medilinkResume[
                                                'educationDescription'])[index]
                                            ['courseDescription'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      height10,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          height15,
                          _dataBlock(
                            label: "EXPERIENCE",
                            content: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: List.generate(
                                  jsonDecode(medilinkResume['workDescription'])
                                      .length,
                                  (index) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        jsonDecode(medilinkResume[
                                                    'workDescription'])[index]
                                                ['companyName']
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        jsonDecode(medilinkResume[
                                                    'workDescription'])[index]
                                                ['year']
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        jsonDecode(medilinkResume[
                                                'workDescription'])[index]
                                            ['designation'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey),
                                      ),
                                      Text(
                                        jsonDecode(medilinkResume[
                                                'workDescription'])[index]
                                            ['workDescription'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      height10,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Created by Medilink©',
                        style: TextStyle(fontSize: sdp(context, 10)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          isLoading ? fullScreenLoading(context) : SizedBox()
        ],
      ),
    );
  }

  Widget _dataBlock({required String label, required Widget content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "> " + label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: kPrimaryColor,
            fontSize: sdp(context, 15),
          ),
        ),
        height10,
        content,
      ],
    );
  }
}
