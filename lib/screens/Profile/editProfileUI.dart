import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';
import 'package:image_picker/image_picker.dart';

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
  final specialization = TextEditingController();
  final city = TextEditingController();
  final address = TextEditingController();
  final dob = TextEditingController();
  final role = TextEditingController();

  String _selectedGender = userData['gender'];
  String _selectedState = userData['state'];

  @override
  void initState() {
    super.initState();

    firstName.text = userData['firstName'];
    lastName.text = userData['lastName'];
    phone.text = userData['phone'];
    email.text = userData['email'];
    specialization.text = userData['specialization'];
    city.text = userData['city'];
    address.text = userData['address'];
    role.text = userData['roleTitle'];
    dob.text = userData['dob'];
    // fetchRoles();
  }

  @override
  void dispose() {
    super.dispose();
    firstName.dispose();
    lastName.dispose();
    phone.dispose();
    email.dispose();
    specialization.dispose();
    city.dispose();
    address.dispose();
    role.dispose();
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
    try {
      setState(() => isLoading = true);
      var dataResult = await apiCallBack(
        method: "POST",
        path: "/users/update-profile.php",
        body: {
          "firstName": firstName.text,
          "lastName": lastName.text,
          "dob": dob.text,
          "gender": _selectedGender,
          "specialization": specialization.text,
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
        userData["specialization"] = specialization.text;
        userData["address"] = address.text;
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
                            child: kTextField(
                              context,
                              controller: dob,
                              readOnly: true,
                              onFieldTap: () async {
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
                        textCapitalization: TextCapitalization.characters,
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
                        controller: specialization,
                        bgColor: Colors.white,
                        hintText: 'MBBS, MD ...',
                        label: "Specialization",
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required!';
                          }
                          return null;
                        },
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
}
