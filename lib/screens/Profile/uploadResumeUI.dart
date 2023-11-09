import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';
import 'package:open_filex/open_filex.dart';

class UploadResumeUI extends StatefulWidget {
  const UploadResumeUI({super.key});

  @override
  State<UploadResumeUI> createState() => _UploadResumeUIState();
}

class _UploadResumeUIState extends State<UploadResumeUI> {
  File? _pickedFile;
  final _fileName = TextEditingController();

  _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf', 'docx', 'doc']);

    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
        _fileName.text = _pickedFile!.path.split('/').last.split('.').first;
        // _resumeList.add(_pickedFile!);
      });
    } else {
      // User canceled the picker
    }
  }

  _openPdf(String path) async {
    await OpenFilex.open(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(context, title: 'Saved Resume'),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: _noResumes(context),
              ),
            ),
            height10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                onPressed: () async {
                  await _selectFile();
                  showModalBottomSheet(
                    context: context,
                    showDragHandle: true,
                    elevation: 0,
                    isScrollControlled: true,
                    builder: (context) {
                      return _selectedResumeModal();
                    },
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add),
                      width10,
                      Text('Upload a resume'),
                    ],
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

  // Widget _changeNameAlert() {
  //   return Dialog(
  //     insetPadding: EdgeInsets.all(20),
  //     elevation: 0,
  //     insetAnimationCurve: Curves.ease,
  //     shape: RoundedRectangleBorder(borderRadius: kRadius(15)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(15),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             'Choose a name',
  //             style: TextStyle(
  //               fontWeight: FontWeight.w600,
  //               fontSize: sdp(context, 15),
  //             ),
  //           ),
  //           height20,
  //           kTextField(
  //             context,
  //             controller: _fileName,
  //             label: 'Create a name',
  //             hintText: 'File name',
  //           ),
  //           height20,
  //           Align(
  //             alignment: Alignment.topRight,
  //             child: MaterialButton(
  //               onPressed: () {},
  //               textColor: kPrimaryColor,
  //               child: Text('Update'),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _selectedResumeModal() {
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              kTextField(
                context,
                controller: _fileName,
                label: 'Create a name',
                hintText: 'File name',
                onChanged: (_) {
                  setState(() {});
                },
              ),
              height20,
              CircleAvatar(
                radius: 50,
                child: SvgPicture.asset(
                  'assets/icons/resume.svg',
                  height: sdp(context, 28),
                  colorFilter: kSvgColor(kPrimaryColor),
                ),
              ),
              height20,
              Text(
                _fileName.text,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              height20,
              ElevatedButton(
                onPressed: () {},
                child: Text('Upload'),
              ),
              kHeight(MediaQuery.of(context).viewInsets.bottom)
            ],
          ),
        );
      },
    );
  }

  Widget _resumeTile(File data) {
    String _fileName = data.path.split('/').last;
    return GestureDetector(
      onTap: () {
        _openPdf(data.path);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: kRadius(15),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/resume.svg',
              height: sdp(context, 20),
            ),
            width10,
            Expanded(
              child: Text(
                _fileName,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.file_download_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noResumes(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/upload-resume.svg',
            height: sdp(context, 100),
          ),
          height10,
          Text(
            'No resumes saved yet!',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
              fontSize: sdp(context, 15),
            ),
          ),
        ],
      ),
    );
  }
}
