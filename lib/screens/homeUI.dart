import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  String selectedDistanceRange = '0 - 10';
  String selectedState = userData['state'];
  final scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    fetchJobVacancies();
  }

  _scrollListener() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      isNavOpen.value = true;
    } else {
      isNavOpen.value = false;
    }
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      pageNo += 1;
      fetchJobVacancies();
    }
  }

  @override
  void dispose() {
    super.dispose();
    searchKey.dispose();
    scrollController.removeListener(() {});
  }

  Future<void> pullRefresher() async {
    pageNo = 0;
    vacancyList = [];
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
          "state": selectedState,
          "distanceRange": selectedDistanceRange,
          "roleId": userData['roleId'],
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
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _hero(context),
                height10,
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: pullRefresher,
                    child: vacancyList.length == 0
                        ? Center(
                            child: Image.asset("assets/images/no-data.jpg"))
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: vacancyList.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return JobCard(data: vacancyList[index]);
                            },
                          ),
                  ),
                ),
                kHeight(20)
              ],
            ),
            isLoading ? fullScreenLoading(context) : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _hero(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isNavOpen,
        builder: (context, isOpen, _) {
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
                      AnimatedContainer(
                        height: isOpen ? 40 : 0,
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          'Find a job',
                          style: kTitleStyle(context, color: Colors.black),
                        ),
                      ),
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
                        homePill(
                            label:
                                (city.text.isEmpty ? 'Anywhere' : city.text) +
                                    ', ' +
                                    selectedState),
                        selectedDistanceRange == ''
                            ? SizedBox.shrink()
                            : homePill(label: selectedDistanceRange + ' km'),
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
        });
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
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search job profiles...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: sdp(context, 10),
                ),
              ),
              onSubmitted: (value) {
                fetchJobVacancies();
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
    Widget subHeading(text) => Text(
          text,
          style: TextStyle(
            fontSize: sdp(context, 12),
            fontWeight: FontWeight.w500,
          ),
        );
    return StatefulBuilder(
      builder: (context, setState) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      searchKey.clear();
                      selectedDistanceRange = '';
                      city.clear();
                      selectedState = 'Pan India';
                    });
                  },
                  child: Text('Clear filters'),
                ),
                Row(
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
                        fetchJobVacancies();
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
                height10,
                subHeading('Distance (in kms)'),
                height10,
                SingleChildScrollView(
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
                Row(
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
                              items: List.generate(statesList.length, (index) {
                                return DropdownMenuItem(
                                  value:
                                      statesList[index]['stateName'].toString(),
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
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
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
