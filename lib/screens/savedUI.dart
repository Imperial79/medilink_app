import 'package:flutter/material.dart';
import 'package:medilink/Job%20Card/jobCard.dart';
import 'package:medilink/utils/components.dart';

class SavedUI extends StatefulWidget {
  const SavedUI({super.key});

  @override
  State<SavedUI> createState() => _SavedUIState();
}

class _SavedUIState extends State<SavedUI> {
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
              // height20,
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: 5,
              //     shrinkWrap: true,
              //     itemBuilder: (context, index) {
              //       return JobCard();
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
