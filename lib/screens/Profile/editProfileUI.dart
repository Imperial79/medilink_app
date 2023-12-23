import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class EditProfileUI extends StatefulWidget {
  const EditProfileUI({super.key});

  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  bool isLoading = false;
  XFile? _image;
  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final subRole = TextEditingController();
  final city = TextEditingController();
  final address = TextEditingController();
  final dob = TextEditingController();
  final role = TextEditingController();
  final bio = TextEditingController();
  final graduationDate = TextEditingController();
  String _selectedGender = userData['gender'];
  String _selectedState = userData['state'];
  String selectedExperience = userData['experience'];
  int _selectedRole = 0;
  List selectedPosts = json.decode(userData['post']);
  List selectedEmploymentType = json.decode(userData['employmentType']);
  List selectedWorkSetting = json.decode(userData['workSetting']);
  List selectedSpecialization = json.decode(userData['specialization']);
  List selectedGraduationType = json.decode(userData['graduationType']);

  @override
  void initState() {
    super.initState();
    _selectedRole = int.parse(userData['roleId']);
    firstName.text = userData['firstName'];
    lastName.text = userData['lastName'];
    phone.text = userData['phone'];
    email.text = userData['email'];
    subRole.text = userData['subRole'];
    city.text = userData['city'];
    address.text = userData['address'];
    role.text = userData['roleTitle'];
    dob.text = userData['dob'];
    bio.text = userData['bio'];
    graduationDate.text = userData['graduationDate'];
  }

  @override
  void dispose() {
    super.dispose();
    firstName.dispose();
    lastName.dispose();
    phone.dispose();
    email.dispose();
    subRole.dispose();
    city.dispose();
    address.dispose();
    role.dispose();
    bio.dispose();
    graduationDate.dispose();
    dob.dispose();
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

  Future<void> updateProfile() async {
    FocusScope.of(context).unfocus();
    try {
      setState(() => isLoading = true);
      var dataResult = await apiCallBack(
        method: "POST",
        path: "/users/update-profile.php",
        body: {
          "firstName": firstName.text,
          "lastName": lastName.text,
          "dob": dob.text,
          "experience": selectedExperience,
          "gender": _selectedGender,
          "subRole": subRole.text,
          "specialization": json.encode(selectedSpecialization),
          "post": json.encode(selectedPosts),
          "bio": bio.text,
          "employmentType": json.encode(selectedEmploymentType),
          "workSetting": json.encode(selectedWorkSetting),
          "graduationType": json.encode(selectedGraduationType),
          "graduationDate": graduationDate.text,
          "address": address.text,
          "city": city.text,
          "state": _selectedState,
        },
      );

      if (!dataResult['error']) {
        userData["firstName"] = firstName.text;
        userData["lastName"] = lastName.text;
        userData["dob"] = dob.text;
        userData["gender"] = _selectedGender;
        userData["specialization"] = subRole.text;
        userData["address"] = address.text;
        userData["bio"] = bio.text;
        userData["city"] = city.text;
        userData["state"] = _selectedState;
      }
      kSnackBar(context,
          content: dataResult['message'], isDanger: dataResult['error']);

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Widget _showMultiSelect({
    required BuildContext context,
    required String arrayName,
    required String header,
  }) {
    List itemArray = jsonDecode(rolesList[_selectedRole][arrayName]);
    return StatefulBuilder(
      builder: (context, setState) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      header,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      textColor: kPrimaryColor,
                      child: Text("Apply"),
                    ),
                  ],
                ),
                MultiSelectChipField(
                  items: List.generate(itemArray.length, (index) {
                    return MultiSelectItem(itemArray[index], itemArray[index]);
                  }),
                  initialValue: arrayName == "posts"
                      ? selectedPosts
                      : arrayName == "employmentType"
                          ? selectedEmploymentType
                          : arrayName == "workSetting"
                              ? selectedWorkSetting
                              : arrayName == "specialization"
                                  ? selectedSpecialization
                                  : selectedGraduationType,
                  title: Text(header),
                  showHeader: false,
                  decoration: BoxDecoration(),
                  headerColor: Colors.transparent,
                  chipShape: RoundedRectangleBorder(borderRadius: kRadius(100)),
                  scroll: false,
                  selectedChipColor: kPrimaryColorAccentLighter,
                  selectedTextStyle: TextStyle(color: kPrimaryColor),
                  onTap: (values) {
                    if (arrayName == "posts") {
                      selectedPosts = values;
                    } else if (arrayName == "employmentType") {
                      selectedEmploymentType = values;
                    } else if (arrayName == "workSetting") {
                      selectedWorkSetting = values;
                    } else if (arrayName == "specialization") {
                      selectedSpecialization = values;
                    } else if (arrayName == "graduationType") {
                      selectedGraduationType = values;
                    }
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kAppBar(
        context,
        title: 'Edit Profile',
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
                      GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: Center(
                          child: _image != null
                              ? Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.purple.shade100,
                                  ),
                                  padding: EdgeInsets.all(5),
                                  child: CircleAvatar(
                                    radius: 50,
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
                                    radius: 50,
                                    backgroundImage: NetworkImage(
                                      userData['image'],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      height20,
                      kTextField(
                        context,
                        controller: bio,
                        bgColor: Colors.white,
                        hintText: 'About me',
                        minLines: 1,
                        maxLines: 5,
                        label: "Bio",
                        keyboardType: TextInputType.multiline,
                        textCapitalization: TextCapitalization.sentences,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required!';
                          }
                          return null;
                        },
                      ),
                      height10,
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
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () async {
                                print('ddd');
                                await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.parse(userData['dob']),
                                  firstDate: DateTime(1970),
                                  lastDate: DateTime(DateTime.now().year - 18),
                                ).then((value) {
                                  setState(() {
                                    if (value != null) {
                                      dob.text = DateFormat('yyyy-MM-dd')
                                          .format(value)
                                          .toString();
                                    }
                                  });
                                });
                              },
                              child: kTextField(
                                context,
                                controller: dob,
                                readOnly: true,
                                bgColor: Colors.white,
                                hintText: '1998-06-29',
                                label: "DOB",
                                keyboardType: TextInputType.datetime,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This field is required!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          width10,
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Gender',
                                  style: TextStyle(fontSize: sdp(context, 9)),
                                ),
                                kHeight(7),
                                Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    borderRadius: kRadius(10),
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                  ),
                                  child: DropdownButton(
                                    value: _selectedGender,
                                    underline: SizedBox.shrink(),
                                    isDense: true,
                                    isExpanded: true,
                                    dropdownColor: Colors.white,
                                    borderRadius: kRadius(10),
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    elevation: 24,
                                    padding: EdgeInsets.all(8),
                                    icon:
                                        Icon(Icons.keyboard_arrow_down_rounded),
                                    iconSize: 20,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                        value: 'M',
                                        child: Text('Male'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'F',
                                        child: Text('Female'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'O',
                                        child: Text('Others'),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      height10,
                      kTextField(
                        context,
                        controller: role,
                        bgColor: Colors.white,
                        hintText: 'Audiologist, Surgeon ...',
                        label: "Roles",
                        readOnly: true,
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
                      rolesList[_selectedRole]['subRoles'] == "NULL"
                          ? SizedBox.shrink()
                          : kTextField(
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
                      rolesList[_selectedRole]['posts'] == "NULL"
                          ? SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height10,
                                Text(
                                  'Post',
                                  style: TextStyle(fontSize: sdp(context, 9)),
                                ),
                                kHeight(7),
                                selectedPosts.length == 0
                                    ? _multiSelectButton(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return _showMultiSelect(
                                                context: context,
                                                arrayName: 'posts',
                                                header: "Select Posts",
                                              );
                                            },
                                          ).then((value) => setState(() {}));
                                        },
                                        label: 'Select Post')
                                    : _multiSelectedContent(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return _showMultiSelect(
                                                context: context,
                                                arrayName: 'posts',
                                                header: "Select Posts",
                                              );
                                            },
                                          ).then((value) => setState(() {}));
                                        },
                                        children: List.generate(
                                          selectedPosts.length,
                                          (index) {
                                            return _multiSelectPill(
                                                selectedPosts[index]);
                                          },
                                        ),
                                      ),
                              ],
                            ),
                      rolesList[_selectedRole]['employmentType'] == "NULL"
                          ? SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height10,
                                Text(
                                  'Employment Type',
                                  style: TextStyle(fontSize: sdp(context, 9)),
                                ),
                                kHeight(7),
                                selectedEmploymentType.length == 0
                                    ? _multiSelectButton(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return _showMultiSelect(
                                                context: context,
                                                arrayName: 'employmentType',
                                                header:
                                                    "Select Employment Type",
                                              );
                                            },
                                          ).then((value) => setState(() {}));
                                        },
                                        label: 'Select Employment Type',
                                      )
                                    : _multiSelectedContent(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return _showMultiSelect(
                                                context: context,
                                                arrayName: 'employmentType',
                                                header:
                                                    "Select Employment Type",
                                              );
                                            },
                                          ).then((value) => setState(() {}));
                                        },
                                        children: List.generate(
                                          selectedEmploymentType.length,
                                          (index) {
                                            return _multiSelectPill(
                                                selectedEmploymentType[index]);
                                          },
                                        ),
                                      )
                              ],
                            ),
                      rolesList[_selectedRole]['specialization'] == "NULL"
                          ? SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height10,
                                Text(
                                  'Specialization',
                                  style: TextStyle(fontSize: sdp(context, 9)),
                                ),
                                kHeight(7),
                                selectedSpecialization.length == 0
                                    ? _multiSelectButton(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return _showMultiSelect(
                                                context: context,
                                                arrayName: 'specialization',
                                                header: "Select Specialization",
                                              );
                                            },
                                          ).then((value) => setState(() {}));
                                        },
                                        label: 'Select Specialization')
                                    : _multiSelectedContent(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return _showMultiSelect(
                                                context: context,
                                                arrayName: 'specialization',
                                                header: "Select Specialization",
                                              );
                                            },
                                          ).then((value) => setState(() {}));
                                        },
                                        children: List.generate(
                                          selectedEmploymentType.length,
                                          (index) {
                                            return _multiSelectPill(
                                                selectedEmploymentType[index]);
                                          },
                                        ),
                                      )
                              ],
                            ),
                      rolesList[_selectedRole]['workSetting'] == "NULL"
                          ? SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height10,
                                Text(
                                  'Work Setting',
                                  style: TextStyle(fontSize: sdp(context, 9)),
                                ),
                                kHeight(7),
                                selectedWorkSetting.length == 0
                                    ? _multiSelectButton(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return _showMultiSelect(
                                                context: context,
                                                arrayName: 'workSetting',
                                                header: "Select Work Setting",
                                              );
                                            },
                                          ).then((value) => setState(() {}));
                                        },
                                        label: 'Select Work Setting',
                                      )
                                    : _multiSelectedContent(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return _showMultiSelect(
                                                context: context,
                                                arrayName: 'workSetting',
                                                header: "Select Work Setting",
                                              );
                                            },
                                          ).then((value) => setState(() {}));
                                        },
                                        children: List.generate(
                                          selectedWorkSetting.length,
                                          (index) {
                                            return _multiSelectPill(
                                                selectedWorkSetting[index]);
                                          },
                                        ),
                                      )
                              ],
                            ),
                      rolesList[_selectedRole]['graduationType'] == "NULL"
                          ? SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                height10,
                                Text(
                                  'Graduation',
                                  style: TextStyle(fontSize: sdp(context, 9)),
                                ),
                                kHeight(7),
                                selectedGraduationType.length == 0
                                    ? _multiSelectButton(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return _showMultiSelect(
                                                context: context,
                                                arrayName: 'graduationType',
                                                header: "Select Graduation",
                                              );
                                            },
                                          ).then((value) => setState(() {}));
                                        },
                                        label: 'Select Graduation',
                                      )
                                    : _multiSelectedContent(
                                        onTap: () {
                                          showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (context) {
                                              return _showMultiSelect(
                                                context: context,
                                                arrayName: 'graduationType',
                                                header: "Select Graduation",
                                              );
                                            },
                                          ).then((value) => setState(() {}));
                                        },
                                        children: List.generate(
                                          selectedGraduationType.length,
                                          (index) {
                                            return _multiSelectPill(
                                                selectedGraduationType[index]);
                                          },
                                        ),
                                      ),
                                height10,
                              ],
                            ),
                      rolesList[_selectedRole]['title'] != "Student"
                          ? SizedBox.shrink()
                          : kTextField(
                              context,
                              controller: graduationDate,
                              bgColor: Colors.white,
                              hintText: '2000-2005',
                              label: "Graduation Year",
                              keyboardType: TextInputType.number,
                              textCapitalization: TextCapitalization.characters,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This field is required!';
                                }
                                return null;
                              },
                            ),
                      height10,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          height10,
                          Text(
                            'Experience',
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
                              value: selectedExperience,
                              underline: SizedBox.shrink(),
                              isDense: true,
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              borderRadius: kRadius(10),
                              menuMaxHeight:
                                  MediaQuery.of(context).size.height * .5,
                              alignment: AlignmentDirectional.bottomCenter,
                              elevation: 24,
                              padding: EdgeInsets.all(8),
                              icon: Icon(Icons.keyboard_arrow_down_rounded),
                              iconSize: 20,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                              items: List.generate(experience.length, (index) {
                                return DropdownMenuItem(
                                  value: experience[index].toString(),
                                  child: Text(experience[index]),
                                );
                              }),
                              onChanged: (value) {
                                setState(
                                  () {
                                    selectedExperience = value!;
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      height10,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  return 'This field is required!';
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
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                  ),
                                  child: DropdownButton(
                                    value: _selectedState,
                                    underline: SizedBox.shrink(),
                                    isDense: true,
                                    isExpanded: true,
                                    dropdownColor: Colors.white,
                                    borderRadius: kRadius(10),
                                    menuMaxHeight:
                                        MediaQuery.of(context).size.height * .5,
                                    alignment:
                                        AlignmentDirectional.bottomCenter,
                                    elevation: 24,
                                    padding: EdgeInsets.all(8),
                                    icon:
                                        Icon(Icons.keyboard_arrow_down_rounded),
                                    iconSize: 20,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                    ),
                                    items: List.generate(statesList.length,
                                        (index) {
                                      return DropdownMenuItem(
                                        value: statesList[index]['stateName']
                                            .toString(),
                                        child: Text(
                                            statesList[index]['stateName']),
                                      );
                                    }),
                                    onChanged: (value) {
                                      setState(
                                        () {
                                          _selectedState = value!;
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
                updateProfile();
              }
            },
            child: Text('Update'),
          ),
        ),
      ),
    );
  }

  Widget _multiSelectButton({void Function()? onTap, required String label}) {
    return kTextButton(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: kPrimaryColor,
        ),
      ),
    );
  }

  Widget _multiSelectedContent({
    void Function()? onTap,
    List<Widget> children = const <Widget>[],
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: kRadius(10),
          color: Colors.grey.shade100,
        ),
        child: Wrap(
          runSpacing: 5,
          spacing: 5,
          children: children,
        ),
      ),
    );
  }

  Widget _multiSelectPill(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: kRadius(100),
        color: Colors.grey.shade700,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: sdp(context, 10),
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }
}
