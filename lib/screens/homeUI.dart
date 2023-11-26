import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/Job%20detail%20screen/jobCard.dart';
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
  bool isLoading = false;
  int pageNo = 0;
  final searchKey = TextEditingController();
  final city = TextEditingController(text: userData['city']);
  String state = '';
  String selectedDistanceRange = '0 - 10';
  String _selectedState = statesList[0]['stateName'];

  @override
  void initState() {
    super.initState();
    pullRefresher();
  }

  @override
  void dispose() {
    super.dispose();
    searchKey.dispose();
  }

  Future<void> pullRefresher() async {
    await fetchJobVacancies();
  }

  Future<void> fetchJobVacancies() async {
    try {
      setState(() => isLoading = true);

      var dataResult = await apiCallBack(
        method: "POST",
        path: "/vacancy/fetch-vacancies.php",
        body: {
          "pageNo": pageNo,
          "searchKey": searchKey.text,
          "city": city.text,
          "state": state,
          "distanceRange": selectedDistanceRange
        },
      );
      if (!dataResult['error']) {
        vacancyList.addAll(dataResult['response']);
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _hero(context),
            height10,
            Expanded(
              child: RefreshIndicator(
                onRefresh: pullRefresher,
                child: ListView.builder(
                  itemCount: vacancyList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  physics: AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return JobCard(data: vacancyList[index]);
                  },
                ),
              ),
            )
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
                height10,
                header(context),
                height5,
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
                  homePill(label: userData['roleTitle']),
                  homePill(label: userData['city'] + ', ' + userData['state']),
                  homePill(label: selectedDistanceRange + ' km'),
                ],
              ),
              height10,
              Text(
                'Personalised job profiles',
                style: kSubtitleStyle(context, color: Colors.black),
              ),
            ],
          ),
        )
      ],
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
          child: CircleAvatar(
            backgroundImage: NetworkImage(userData['image']),
          ),
        ),
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
                          // setState(
                          //   () {
                          //     _selectedField = '';
                          //     _selectedLocation = '';
                          //     selectedDistanceRange = '';
                          //   },
                          // );
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
                height10,
                subHeading('Distance (in kms)'),
                height10,
                SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      filterBtn(setState, label: '0 - 10', type: 'distance'),
                      filterBtn(setState, label: '11 - 20', type: 'distance'),
                      filterBtn(setState, label: '21 - 30', type: 'distance'),
                      filterBtn(setState, label: '31 - 40', type: 'distance'),
                    ],
                  ),
                ),
                height20,
                subHeading('Preferred Location'),
                height10,
                // SingleChildScrollView(
                //   padding: EdgeInsets.symmetric(horizontal: 20),
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       filterBtn(setState, label: 'Canada', type: 'location'),
                //       filterBtn(setState,
                //           label: 'United States', type: 'location'),
                //       filterBtn(setState, label: 'Hong Kong', type: 'location'),
                //       filterBtn(setState, label: 'India', type: 'location'),
                //       filterBtn(setState, label: 'Ukraine', type: 'location'),
                //     ],
                //   ),
                // ),
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
                                value: _selectedState,
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
                                      print(value);
                                      _selectedState = value!;
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

  Widget filterBtn(
    StateSetter setState, {
    required String label,
    String? type,
  }) {
    bool _isSelected;
    _isSelected = selectedDistanceRange == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDistanceRange = label;
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
}
