import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';
import 'package:image_picker/image_picker.dart';

class ResumeBuilderUI extends StatefulWidget {
  const ResumeBuilderUI({super.key});

  @override
  State<ResumeBuilderUI> createState() => _ResumeBuilderUIState();
}

class _ResumeBuilderUIState extends State<ResumeBuilderUI> {
  bool isLoading = false;
  XFile? _image;
  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final profileLink = TextEditingController();
  final subRole = TextEditingController();
  final address = TextEditingController();
  final objective = TextEditingController();
  List<TextEditingController> expertise = [];
  List<Map<dynamic, dynamic>> education = [];
  List<Map<dynamic, dynamic>> work = [];

  Map<dynamic, dynamic> medilinkResume = userData;

  @override
  void initState() {
    super.initState();
    populateData();
    fetchMedilinkResume();
  }

  @override
  void dispose() {
    super.dispose();
    firstName.dispose();
    lastName.dispose();
    phone.dispose();
    email.dispose();
    profileLink.dispose();
    subRole.dispose();
    address.dispose();
    objective.dispose();
  }

  Future<void> fetchMedilinkResume() async {
    try {
      setState(() => isLoading = true);
      var dataResult = await apiCallBack(
        method: "GET",
        path: "/resume/fetch-medilink-resume.php",
        body: {},
      );

      if (!dataResult['error']) {
        medilinkResume = dataResult['response'];
      }

      populateData();

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  populateData() {
    firstName.text = medilinkResume['firstName'];
    lastName.text = medilinkResume['lastName'];
    phone.text = medilinkResume['phone'];
    email.text = medilinkResume['email'];
    profileLink.text = medilinkResume['profileLink'];
    subRole.text = medilinkResume['subRole'];
    address.text = medilinkResume['address'];
    objective.text = medilinkResume['bio'];

    List expertiseList = jsonDecode(medilinkResume['expertiseDescription'] == ''
        ? '[""]'
        : medilinkResume['expertiseDescription']);
    expertise = [];
    expertiseList.forEach((element) {
      expertise.add(TextEditingController(text: element));
    });

    List educationList = jsonDecode(medilinkResume['educationDescription'] == ''
        ? '[{"courseName":"","year":"","courseDescription":""}]'
        : medilinkResume['educationDescription']);
    education = [];
    educationList.forEach((element) {
      education.add(
        {
          'courseName': TextEditingController(text: element['courseName']),
          'year': TextEditingController(text: element['year']),
          'courseDescription':
              TextEditingController(text: element['courseDescription']),
        },
      );
    });

    List workList = jsonDecode(medilinkResume['workDescription'] == ''
        ? '[{"companyName":"","designation":"","year":"","workDescription":""}]'
        : medilinkResume['workDescription']);
    work = [];
    workList.forEach((element) {
      work.add(
        {
          'companyName': TextEditingController(text: element['companyName']),
          'designation': TextEditingController(text: element['designation']),
          'year': TextEditingController(text: element['year']),
          'workDescription':
              TextEditingController(text: element['workDescription']),
        },
      );
    });
  }

  _pickImage() async {
    final ImagePicker picker = ImagePicker();
    _image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
    uploadDp();
  }

  uploadDp() async {
    if (_image != null) {
      try {
        setState(() => isLoading = true);
        var dataResult = await apiCallBackMedia(
          method: 'POST',
          path: '/users/update-dp.php',
          body: {
            "mediaFile": await MultipartFile.fromFile(
              _image!.path,
              filename: "image.jpg",
            ),
          },
        );

        kSnackBar(context,
            content: dataResult['message'], isDanger: dataResult['error']);
        setState(() => isLoading = false);
      } catch (e) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> buildResume() async {
    FocusScope.of(context).unfocus();
    try {
      setState(() => isLoading = true);

      List expertiseValueList = [];
      expertise.forEach((element) {
        expertiseValueList.add(element.text);
      });

      List educationValueList = [];
      education.forEach((element) {
        educationValueList.add(
          {
            'courseName': element['courseName'].text,
            'year': element['year'].text,
            'courseDescription': element['courseDescription'].text,
          },
        );
      });

      List workValueList = [];
      work.forEach((element) {
        workValueList.add(
          {
            'companyName': element['companyName'].text,
            'designation': element['designation'].text,
            'year': element['year'].text,
            'workDescription': element['workDescription'].text,
          },
        );
      });

      var dataResult = await apiCallBack(
        method: "POST",
        path: "/resume/build-resume.php",
        body: {
          "firstName": firstName.text,
          "lastName": lastName.text,
          "profileLink": profileLink.text,
          "bio": objective.text,
          "educationDescription": json.encode(educationValueList),
          "expertiseDescription": json.encode(expertiseValueList),
          "workDescription": json.encode(workValueList),
          "subRole": subRole.text,
        },
      );

      // print(dataResult);
      if (!dataResult['error']) {}
      kSnackBar(context,
          content: dataResult['message'], isDanger: dataResult['error']);

      setState(() => isLoading = false);
    } catch (e) {
      print(e);
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(
        context,
        title: 'Medilink Resume Builder',
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 100, top: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal Details',
                        style: kSubtitleStyle(context),
                      ),
                      height10,
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: _image != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.purple.shade100,
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: FileImage(
                                        File(_image!.path),
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.purple.shade100,
                                    ),
                                    padding: EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        medilinkResume['image'],
                                      ),
                                    ),
                                  ),
                          ),
                          width10,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Upload photo",
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontSize: sdp(context, 10),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Allowed file formats: jpg, jpeg, png",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                    fontSize: sdp(context, 9)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      height20,
                      Row(
                        children: [
                          Flexible(
                            child: kTextField(
                              context,
                              controller: firstName,
                              bgColor: Colors.white,
                              hintText: 'John',
                              label: 'First Name',
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required!';
                                }
                                return null;
                              },
                            ),
                          ),
                          width10,
                          Flexible(
                            child: kTextField(
                              context,
                              controller: lastName,
                              bgColor: Colors.white,
                              hintText: 'Smith',
                              label: 'Last Name',
                              keyboardType: TextInputType.name,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required!';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      height10,
                      kTextField(
                        context,
                        controller: email,
                        readOnly: true,
                        bgColor: Colors.white,
                        hintText: 'someone@example.com',
                        label: "Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required!';
                          }
                          return null;
                        },
                      ),
                      height10,
                      kTextField(
                        context,
                        controller: phone,
                        prefixText: "+91 ",
                        readOnly: true,
                        bgColor: Colors.white,
                        hintText: '9XXXXXXX556',
                        label: "Phone",
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required!';
                          }
                          return null;
                        },
                      ),
                      height10,
                      kTextField(
                        context,
                        controller: address,
                        bgColor: Colors.white,
                        hintText: 'Street',
                        label: "Address",
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required!';
                          }
                          return null;
                        },
                      ),
                      height10,
                      kTextField(
                        context,
                        controller: profileLink,
                        bgColor: Colors.white,
                        hintText: 'LinkedIn',
                        label: "Profile Link",
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required!';
                          }
                          return null;
                        },
                      ),
                      height20,
                      Text(
                        'Profile Snapshot',
                        style: kSubtitleStyle(context),
                      ),
                      height10,
                      kTextField(
                        context,
                        controller: subRole,
                        bgColor: Colors.white,
                        hintText: 'Sub Role',
                        label: "Sub Role",
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required!';
                          }
                          return null;
                        },
                      ),
                      height10,
                      kTextField(
                        context,
                        controller: objective,
                        bgColor: Colors.white,
                        hintText: 'Objective',
                        minLines: 1,
                        maxLines: 5,
                        label: "Objective",
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required!';
                          }
                          return null;
                        },
                      ),
                      height20,
                      Text(
                        'Expertise',
                        style: kSubtitleStyle(context),
                      ),
                      height10,
                      Column(
                        children: List.generate(
                          expertise.length,
                          (index) => Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: kTextField(
                                      context,
                                      controller: expertise[index],
                                      bgColor: Colors.white,
                                      hintText: 'My expertise',
                                      label: "Skill " + (index + 1).toString(),
                                      keyboardType: TextInputType.text,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'This field is required!';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  index != 0
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              expertise.removeAt(index);
                                            });
                                          },
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                      : SizedBox.shrink()
                                ],
                              ),
                              height10,
                            ],
                          ),
                        ),
                      ),
                      height5,
                      OutlinedButton(
                          onPressed: () {
                            setState(() {
                              expertise.add(TextEditingController());
                            });
                          },
                          child: Text("Add Expertise")),
                      height20,
                      Text(
                        'Education',
                        style: kSubtitleStyle(context),
                      ),
                      height10,
                      Column(
                        children: List.generate(
                          education.length,
                          (index) => educationForm(index),
                        ),
                      ),
                      height5,
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            education.add(
                              {
                                'courseName': TextEditingController(),
                                'year': TextEditingController(),
                                'courseDescription': TextEditingController(),
                              },
                            );
                          });
                        },
                        child: Text("Add Education"),
                      ),
                      height20,
                      Text(
                        'Work Experience',
                        style: kSubtitleStyle(context),
                      ),
                      height10,
                      Column(
                        children: List.generate(
                          work.length,
                          (index) => workForm(index),
                        ),
                      ),
                      height5,
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            work.add(
                              {
                                'companyName': TextEditingController(),
                                'designation': TextEditingController(),
                                'year': TextEditingController(),
                                'workDescription': TextEditingController(),
                              },
                            );
                          });
                        },
                        child: Text("Add Work"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          isLoading ? fullScreenLoading(context) : SizedBox()
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                buildResume();
              }
            },
            child: Text('Create Resume'),
          ),
        ),
      ),
    );
  }

  Widget educationForm(index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: kRadius(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "# " + (index + 1).toString(),
                style: TextStyle(
                  fontSize: sdp(context, 15),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              index != 0
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          education.removeAt(index);
                        });
                      },
                      icon: Text(
                        "Remove",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w600),
                      ))
                  : SizedBox.shrink(),
            ],
          ),
          kHeight(3),
          Row(
            children: [
              Flexible(
                child: kTextField(
                  context,
                  controller: education[index]['courseName'],
                  bgColor: Colors.white,
                  hintText: 'Course Name',
                  label: "Course Name",
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required!';
                    }
                    return null;
                  },
                ),
              ),
              width10,
              Flexible(
                child: kTextField(
                  context,
                  controller: education[index]['year'],
                  bgColor: Colors.white,
                  hintText: 'From - To',
                  label: "Year",
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required!';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          height10,
          kTextField(
            context,
            controller: education[index]['courseDescription'],
            bgColor: Colors.white,
            hintText: 'Describe your course',
            minLines: 1,
            maxLines: 3,
            label: "Course Description",
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required!';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget workForm(index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 7),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: kRadius(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "# " + (index + 1).toString(),
                style: TextStyle(
                  fontSize: sdp(context, 15),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              index != 0
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          work.removeAt(index);
                        });
                      },
                      icon: Text(
                        "Remove",
                        style: TextStyle(
                            color: Colors.red, fontWeight: FontWeight.w600),
                      ))
                  : SizedBox.shrink(),
            ],
          ),
          kHeight(3),
          Row(
            children: [
              Flexible(
                child: kTextField(
                  context,
                  controller: work[index]['companyName'],
                  bgColor: Colors.white,
                  hintText: 'Company Name',
                  label: "Company Name",
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required!';
                    }
                    return null;
                  },
                ),
              ),
              width10,
              Flexible(
                child: kTextField(
                  context,
                  controller: work[index]['designation'],
                  bgColor: Colors.white,
                  hintText: 'Position/Role',
                  label: "Designation",
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required!';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          height10,
          kTextField(
            context,
            controller: work[index]['year'],
            bgColor: Colors.white,
            hintText: 'From - To',
            label: "Year",
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required!';
              }
              return null;
            },
          ),
          height10,
          kTextField(
            context,
            controller: work[index]['workDescription'],
            bgColor: Colors.white,
            hintText: 'Describe your work',
            minLines: 1,
            maxLines: 3,
            label: "Work Description",
            keyboardType: TextInputType.multiline,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required!';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
