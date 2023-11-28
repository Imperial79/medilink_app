import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadResumeUI extends StatefulWidget {
  const UploadResumeUI({super.key});

  @override
  State<UploadResumeUI> createState() => _UploadResumeUIState();
}

class _UploadResumeUIState extends State<UploadResumeUI> {
  bool isLoading = false;
  File? _pickedFile;
  final _fileName = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchResumes();
  }

  Future<void> pullRefresher() async {
    resumeList = [];
    await fetchResumes();
  }

  _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['pdf', 'docx', 'doc']);

    if (result != null) {
      setState(() {
        _pickedFile = File(result.files.single.path!);
        _fileName.text = _pickedFile!.path.split('/').last.split('.').first;
      });
    } else {}
  }

  uploadResume() async {
    if (_pickedFile != null) {
      Navigator.pop(context);
      setState(() => isLoading = true);
      var dataResult = await apiCallBackMedia(
        method: 'POST',
        path: '/resume/upload-resume.php',
        body: {
          "mediaFile": await MultipartFile.fromFile(
            _pickedFile!.path,
            filename: _pickedFile!.path.split('/').last,
          ),
          "resumeName": _fileName.text,
        },
      );
      if (!dataResult['error']) {
        fetchResumes();
      }
      setState(() => isLoading = false);
      kSnackBar(context,
          content: dataResult['message'], isDanger: dataResult['error']);
    } else {
      kSnackBar(context, content: "Please choose a document!", isDanger: true);
    }
  }

  Future<void> fetchResumes() async {
    setState(() => isLoading = true);
    var dataResult = await apiCallBack(
      method: "POST",
      path: "/resume/fetch-my-resumes.php",
      body: {},
    );
    if (!dataResult['error']) {
      resumeList = dataResult['response'];
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(context, title: 'Saved Resume'),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: resumeList.length == 0
                      ? _noResumes(context)
                      : RefreshIndicator(
                          onRefresh: pullRefresher,
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: resumeList.length,
                            itemBuilder: (context, index) {
                              return _resumeTile(resumeList[index]);
                            },
                          ),
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
            isLoading ? fullScreenLoading(context) : SizedBox()
          ],
        ),
      ),
    );
  }

  Widget _selectedResumeModal() {
    return StatefulBuilder(
      builder: (context, setState) {
        return SafeArea(
          child: SingleChildScrollView(
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
                  textCapitalization: TextCapitalization.words,
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
                  onPressed: () {
                    uploadResume();
                  },
                  child: Text('Upload Resume'),
                ),
                kHeight(MediaQuery.of(context).viewInsets.bottom)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _resumeTile(var data) {
    // String _fileName = data.path.split('/').last;
    return Container(
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
            colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
            height: sdp(context, 20),
          ),
          width10,
          Expanded(
            child: Text(
              data['resumeName'],
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              if (!await launchUrl(Uri.parse(data['resume']))) {
                throw Exception('Could not launch');
              }
            },
            icon: Icon(Icons.file_download_outlined),
          ),
        ],
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
