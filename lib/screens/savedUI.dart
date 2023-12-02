import 'package:flutter/material.dart';
import 'package:medilink/Job%20detail%20screen/jobCard.dart';
// import 'package:medilink/Job%20Card/jobCard.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';

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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              kPageHeader(
                context,
                title: 'Saved',
                subtitle: 'Find your saved or bookmarked job profiles here',
              ),
              height20,
              Expanded(
                child: RefreshIndicator(
                  onRefresh: pullRefresher,
                  child: bookmarkedVacancies.length == 0
                      ? Center(child: Image.asset("assets/images/no-data.jpg"))
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: bookmarkedVacancies.length,
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return JobCard(data: bookmarkedVacancies[index]);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
