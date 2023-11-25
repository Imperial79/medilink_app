import 'package:flutter/material.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/sdp.dart';

class EditProfileUI extends StatefulWidget {
  const EditProfileUI({super.key});

  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(
        context,
        title: 'Edit Profile',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15),
        child: SafeArea(
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                kTextField(
                  context,
                  label: 'Fullname',
                  hintText: 'Enter your fullname',
                  keyboardType: TextInputType.text,
                ),
                height20,
                kTextField(
                  context,
                  label: 'Github Link',
                  hintText: '(Optional)',
                  keyboardType: TextInputType.text,
                ),
                height20,
                kTextField(
                  context,
                  label: 'Linkedin Link',
                  hintText: '(Optional)',
                  keyboardType: TextInputType.text,
                ),
                height20,
                kTextField(
                  context,
                  label: 'Bio',
                  hintText:
                      'Write an effective bio to attarct more clients ...',
                  keyboardType: TextInputType.multiline,
                  minLines: 3,
                  maxLines: 5,
                ),
                kHeight(sdp(context, 70)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: ElevatedButton(
            onPressed: () {},
            child: Text('Update'),
          ),
        ),
      ),
    );
  }
}
