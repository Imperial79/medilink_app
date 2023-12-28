import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/Job%20detail%20screen/vacancyDetailsUI.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';

class MyApplicationsUI extends StatefulWidget {
  const MyApplicationsUI({super.key});

  @override
  State<MyApplicationsUI> createState() => _MyApplicationsUIState();
}

class _MyApplicationsUIState extends State<MyApplicationsUI> {
  bool isLoading = false;
  int pageNo = 0;
  final scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    appliedVacancies = [];
    fetchAppliedVacancies();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      pageNo += 1;
      fetchAppliedVacancies();
    }
  }

  Future<void> pullRefresher() async {
    pageNo = 0;
    appliedVacancies = [];
    await fetchAppliedVacancies();
  }

  Future<void> fetchAppliedVacancies() async {
    try {
      setState(() => isLoading = true);

      var dataResult = await apiCallBack(
        method: "POST",
        path: "/application/fetch-applied-applications.php",
        body: {
          "pageNo": pageNo,
        },
      );
      if (!dataResult['error']) {
        appliedVacancies.addAll(dataResult['response']);
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(context, title: 'Applied Jobs'),
      body: SafeArea(
        child: Stack(
          children: [
            RefreshIndicator(
              onRefresh: pullRefresher,
              child: appliedVacancies.length == 0
                  ? Center(child: Image.asset("assets/images/no-data.jpg"))
                  : ListView.builder(
                      controller: scrollController,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: appliedVacancies.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return _appliedJobsCard(appliedVacancies[index]);
                      },
                    ),
            ),
            isLoading ? fullScreenLoading(context) : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _appliedJobsCard(var data) {
    Color statusBgColor = Colors.red.shade300;
    if (data['status'] == 'Applied') {
      statusBgColor = Colors.yellow.shade300;
    } else if (data['status'] == 'In-Review') {
      statusBgColor = Colors.purple.shade300;
    } else if (data['status'] == 'Selected') {
      statusBgColor = Colors.green.shade300;
    }

    return GestureDetector(
      onTap: () {
        navPush(
          context,
          VacancyDetailUI(
            vacancyId: data['vacancyId'],
          ),
        );
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
                    data['companyImage'],
                    fit: BoxFit.contain,
                  ),
                ),
                width10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['roleTitle'] + ' | ' + data['companyName'],
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: sdp(context, 9)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      height10,
                      Text(
                        data['requirements'],
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
                  content: data['salary'],
                ),
                width5,
                statsCard(
                  context,
                  label: 'Position',
                  content: data['roleTitle'],
                ),
                width5,
                statsCard(
                  context,
                  label: 'Experience',
                  content: data['experience'],
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
                Expanded(
                  child: Text(
                    data['optedResumeBuilder'] == 'true'
                        ? 'Medilink Resume'
                        : data['resumeName'],
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                      fontSize: sdp(context, 9),
                    ),
                  ),
                ),
              ],
            ),
            height10,
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  data['status'],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
