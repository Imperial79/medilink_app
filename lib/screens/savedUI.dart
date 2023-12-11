import 'package:flutter/material.dart';
import 'package:medilink/Job%20detail%20screen/jobCard.dart';
// import 'package:medilink/Job%20Card/jobCard.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';

class SavedUI extends StatefulWidget {
  const SavedUI({super.key});

  @override
  State<SavedUI> createState() => _SavedUIState();
}

class _SavedUIState extends State<SavedUI> {
  bool isLoading = false;
  int pageNo = 0;
  final scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    bookmarkedVacancies = [];
    fetchBookmarkedVacancies();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("At bottom");
      pageNo += 1;
      fetchBookmarkedVacancies();
    }
  }

  Future<void> pullRefresher() async {
    pageNo = 0;
    bookmarkedVacancies = [];
    await fetchBookmarkedVacancies();
  }

  Future<void> fetchBookmarkedVacancies() async {
    try {
      setState(() => isLoading = true);

      var dataResult = await apiCallBack(
        method: "POST",
        path: "/vacancy/fetch-bookmarked-vacancies.php",
        body: {
          "pageNo": pageNo,
        },
      );
      if (!dataResult['error']) {
        bookmarkedVacancies.addAll(dataResult['response']);
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: sdp(context, 45),
        automaticallyImplyLeading: false,
        title: kPageHeader(
          context,
          title: 'Saved',
          subtitle: 'Find your saved or bookmarked job profiles here',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: pullRefresher,
        child: SingleChildScrollView(
          controller: scrollController,
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height20,
              bookmarkedVacancies.length == 0
                  ? Center(child: Image.asset("assets/images/no-data.jpg"))
                  : ListView.builder(
                      itemCount: bookmarkedVacancies.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return JobCard(data: bookmarkedVacancies[index]);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
