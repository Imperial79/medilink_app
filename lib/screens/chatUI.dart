import 'package:flutter/material.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/sdp.dart';

class ChatUI extends StatefulWidget {
  const ChatUI({super.key});

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: kPageHeader(
                context,
                title: 'Chat',
                subtitle: 'Recent chats with recruiters are shown here',
              ),
            ),
            kHeight(10),
            Expanded(
              child: ListView.separated(
                itemCount: 10,
                padding: EdgeInsets.only(top: 10),
                itemBuilder: (context, index) {
                  return chatTile();
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey.shade200,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chatTile() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 7, horizontal: 15),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1583864697784-a0efc8379f70?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8bWFsZSUyMHByb2ZpbGV8ZW58MHx8MHx8fDA%3D&w=1000&q=80',
              ),
            ),
            width10,
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vivek Verma',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: sdp(context, 12),
                          ),
                        ),
                        // height5,
                        Text(
                          'I\'ve submitted my Resume',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                            fontSize: sdp(context, 10),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '12:00 AM',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w600,
                      fontSize: sdp(context, 8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryTile(int index) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: index % 3 == 0
                ? kPrimaryColor.withOpacity(0.7)
                : index % 2 == 0
                    ? kPillButtonColor.withOpacity(0.7)
                    : kPrimaryColorAccent.withOpacity(0.7),
          ),
          color: index % 3 == 0
              ? kPrimaryColor.withOpacity(0.2)
              : index % 2 == 0
                  ? kPillButtonColor.withOpacity(0.2)
                  : kPrimaryColorAccent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/ui-design.png',
              height: sdp(context, 100),
            ),
            Text("UI Design"),
          ],
        ),
      ),
    );
  }
}
