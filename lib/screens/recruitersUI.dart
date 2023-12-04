import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';
import 'package:url_launcher/url_launcher.dart';

class RecruitersUI extends StatefulWidget {
  const RecruitersUI({super.key});

  @override
  State<RecruitersUI> createState() => _RecruitersUIState();
}

class _RecruitersUIState extends State<RecruitersUI> {
  bool isLoading = false;
  int pageNo = 0;
  final searchKey = TextEditingController();
  final city = TextEditingController(text: userData['city']);
  String selectedState = userData['state'];
  final scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    fetchRecruiters();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      pageNo += 1;
      fetchRecruiters();
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchKey.dispose();
  }

  Future<void> pullRefresher() async {
    pageNo = 0;
    recruitersList = [];
    await fetchRecruiters();
  }

  Future<void> fetchRecruiters() async {
    try {
      setState(() => isLoading = true);
      var dataResult = await apiCallBack(
        method: "POST",
        path: "/recruiters/fetch-recruiters.php",
        body: {
          "pageNo": pageNo,
          "searchKey": searchKey.text,
          "city": city.text,
          "state": selectedState,
        },
      );
      if (!dataResult['error']) {
        recruitersList.addAll(dataResult['response']);
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> followRecruiter(recruiterId) async {
    try {
      await apiCallBack(
        method: "POST",
        path: "/recruiters/follow-recruiter.php",
        body: {
          "recruiterId": recruiterId,
        },
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _hero(context),
                kHeight(10),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: pullRefresher,
                    child: recruitersList.length == 0
                        ? Center(
                            child: Image.asset("assets/images/no-data.jpg"))
                        : ListView.builder(
                            controller: scrollController,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: recruitersList.length,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            itemBuilder: (context, index) {
                              return recruiterCard(recruitersList[index]);
                            },
                          ),
                  ),
                ),
              ],
            ),
            isLoading ? fullScreenLoading(context) : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          color: Color(0xFFDEE1FB),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kPageHeader(
                  context,
                  title: 'Recruiters',
                  subtitle: 'Start following recruiters',
                ),
                height10,
                _searchBar(),
                height15,
              ],
            ),
          ),
        ),
        height10,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.start,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    'Filters: ',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      fontSize: sdp(context, 10),
                    ),
                  ),
                  homePill(
                      label: (city.text.isEmpty ? 'Anywhere' : city.text) +
                          ', ' +
                          selectedState),
                ],
              ),
              height10,
              Text(
                'Filtered Recruiters',
                style: kSubtitleStyle(context, color: Colors.black),
              ),
            ],
          ),
        )
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
              controller: searchKey,
              cursorColor: Colors.purple.shade100,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search recruiters...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: sdp(context, 10),
                ),
              ),
              onSubmitted: (value) {
                fetchRecruiters();
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: kScaffoldColor,
                isScrollControlled: true,
                builder: (context) {
                  return filterModalSheet();
                },
              );
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
                          Navigator.pop(context);
                          pageNo = 0;
                          vacancyList = [];
                          fetchRecruiters();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: kPrimaryColor,
                        ),
                        child: Text(
                          'Apply',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                subHeading('Preferred Location'),
                height10,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: kTextField(
                          context,
                          controller: city,
                          bgColor: Colors.white,
                          hintText: 'Bengaluru, Mumbai',
                          label: "City",
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'This is empty!';
                            }
                            return null;
                          },
                        ),
                      ),
                      width10,
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'State',
                              style: TextStyle(fontSize: sdp(context, 9)),
                            ),
                            kHeight(7),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: kRadius(10),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: DropdownButton(
                                value: selectedState,
                                underline: SizedBox.shrink(),
                                isDense: true,
                                menuMaxHeight:
                                    MediaQuery.of(context).size.height * .5,
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                borderRadius: kRadius(10),
                                alignment: AlignmentDirectional.bottomCenter,
                                elevation: 24,
                                padding: EdgeInsets.all(8),
                                icon: Icon(Icons.keyboard_arrow_down_rounded),
                                iconSize: 20,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                ),
                                items:
                                    List.generate(statesList.length, (index) {
                                  return DropdownMenuItem(
                                    value: statesList[index]['stateName']
                                        .toString(),
                                    child: Text(statesList[index]['stateName']),
                                  );
                                }),
                                onChanged: (value) {
                                  setState(
                                    () {
                                      selectedState = value!;
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                height20,
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget homePill({
    Widget? icon,
    required String label,
    Color? pillColor,
    Color? labelColor,
    bool hasShadow = true,
  }) {
    return InkWell(
      onTap: () {},
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.transparent,
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
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget recruiterCard(data) {
    return GestureDetector(
      onTap: () async {
        try {
          if (!await launchUrl(
            Uri.parse(data['website']),
            mode: LaunchMode.externalApplication,
          )) {}
        } catch (e) {
          kSnackBar(context, content: "Cannot open website!", isDanger: true);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.grey, width: .5),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height5,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(data['image']),
                    ),
                  ],
                ),
                width10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['companyName'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: sdp(context, 12),
                        ),
                      ),
                      height5,
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
                            data['city'] + ', ' + data['state'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: sdp(context, 10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    followRecruiter(data['id']);
                    setState(() {
                      data['isFollowing'] =
                          data['isFollowing'] == 'true' ? 'false' : 'true';
                    });
                    kSnackBar(context,
                        content: data['isFollowing'] == 'true'
                            ? 'Subscribed recruiter'
                            : 'Unsubscribed recruiter');
                  },
                  icon: Icon(
                    data['isFollowing'] == 'true'
                        ? Icons.notifications_active
                        : Icons.notification_add_outlined,
                    size: 20,
                    color: data['isFollowing'] == 'true'
                        ? Colors.orange.shade600
                        : Colors.black,
                  ),
                ),
              ],
            ),
            height5,
            Text.rich(TextSpan(
                text: 'Point of contact: ',
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
                children: [
                  TextSpan(
                      text: data['pocName'],
                      style: TextStyle(fontWeight: FontWeight.w500))
                ])),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    'Since ' + formatDate(data['date']),
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
            Visibility(
              visible: data['bio'] != "",
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  data['bio'],
                  style: TextStyle(
                    fontSize: sdp(context, 8),
                    fontWeight: FontWeight.w600,
                  ),
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
