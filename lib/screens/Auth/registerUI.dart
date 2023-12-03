import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medilink/dashboardUI.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class RegisterUI extends StatefulWidget {
  final type;
  final phone;
  final otp;
  final email;
  final guid;
  const RegisterUI(
      {super.key,
      required this.type,
      required this.phone,
      required this.otp,
      required this.email,
      required this.guid});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final specialization = TextEditingController();
  final city = TextEditingController();
  final address = TextEditingController();
  final dob = TextEditingController();
  String _selectedGender = 'M';
  int _selectedRole = 0;
  String _selectedState = statesList[0]['stateName'];
  List subRolesArr = ['Select'];
  int selectedSubRole = 0;
  List selectedPosts = [];
  List selectedEmploymentType = [];
  List selectedWorkSetting = [];
  List selectedSpecialization = [];

  @override
  void initState() {
    super.initState();
    rolesList = [
      {"id": "0", "title": "Choose Role"}
    ];

    if (widget.type == "Phone") {
      phone.text = widget.phone;
    } else {
      email.text = widget.email;
    }
    fetchRoles();
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
  }

  Future<void> fetchRoles() async {
    var dataResult = await apiCallBack(
      method: "GET",
      path: "/role/fetch-roles.php",
    );
    if (!dataResult['error']) {
      setState(() {
        rolesList = dataResult['response'];
        _selectedRole = 0;
      });
    }
  }

  Future<void> registerUsingPhone() async {
    setState(() => isLoading = true);
    Map<String, dynamic> body = {};
    try {
      await OneSignal.shared.getDeviceState().then((value) async {
        var fcmToken = value!.userId!;
        body = {
          "firstName": firstName.text,
          "lastName": lastName.text,
          "dob": dob.text,
          "gender": _selectedGender,
          "phone": widget.phone,
          "email": email.text,
          "otp": widget.otp,
          "specialization": specialization.text,
          "address": address.text,
          "city": city.text,
          "state": _selectedState,
          "roleId": _selectedRole,
          "fcmToken": fcmToken.toString(),
        };
      });
    } catch (e) {
      body = {
        "firstName": firstName.text,
        "lastName": lastName.text,
        "dob": dob.text,
        "gender": _selectedGender,
        "phone": widget.phone,
        "email": email.text,
        "otp": widget.otp,
        "specialization": specialization.text,
        "address": address.text,
        "city": city.text,
        "state": _selectedState,
        "roleId": _selectedRole,
        "fcmToken": "",
      };
    }
    var dataResult = await apiCallBack(
      method: "POST",
      path: "/users/register-with-phone.php",
      body: body,
    );

    if (!dataResult['error']) {
      setState(() => isLoading = false);
      userData = dataResult['response'];
      navPopUntilPush(context, const DashboardUI());
    } else {
      setState(() => isLoading = false);
      Navigator.pop(context);
    }
    kSnackBar(context,
        content: dataResult['message'], isDanger: dataResult['error']);
  }

  Future<void> registerUsingEmail() async {
    setState(() => isLoading = true);
    Map<String, dynamic> body = {};
    try {
      await OneSignal.shared.getDeviceState().then((value) async {
        var fcmToken = value!.userId!;
        body = {
          "firstName": firstName.text,
          "lastName": lastName.text,
          "dob": dob.text,
          "gender": _selectedGender,
          "phone": phone.text,
          "email": widget.email,
          "guid": widget.guid,
          "specialization": specialization.text,
          "address": address.text,
          "city": city.text,
          "state": _selectedState,
          "roleId": _selectedRole,
          "fcmToken": fcmToken.toString(),
        };
      });
    } catch (e) {
      body = {
        "firstName": firstName.text,
        "lastName": lastName.text,
        "dob": dob.text,
        "gender": _selectedGender,
        "phone": phone.text,
        "email": widget.email,
        "guid": widget.guid,
        "specialization": specialization.text,
        "address": address.text,
        "city": city.text,
        "state": _selectedState,
        "roleId": _selectedRole,
        "fcmToken": "",
      };
    }
    var dataResult = await apiCallBack(
      method: "POST",
      path: "/users/register-with-google.php",
      body: body,
    );

    if (!dataResult['error']) {
      setState(() => isLoading = false);
      userData = dataResult['response'];
      navPopUntilPush(context, const DashboardUI());
    } else {
      setState(() => isLoading = false);
    }
    kSnackBar(context,
        content: dataResult['message'], isDanger: dataResult['error']);
  }

  void _showMultiSelect(
      {required BuildContext context,
      required String arrayName,
      required String header,
      required String resultArray}) async {
    List itemArray = jsonDecode(rolesList[_selectedRole][arrayName]);
    showModalBottomSheet(
      context: context,
      backgroundColor: kScaffoldColor,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Done"),
                    ),
                    MultiSelectChipField(
                      items: List.generate(itemArray.length, (index) {
                        return MultiSelectItem(
                            itemArray[index], itemArray[index]);
                      }),
                      initialValue: [],
                      title: Text(header),
                      // headerColor: Colors.blue.withOpacity(0.5),
                      scroll: false,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Colors.blue.shade700, width: 1.8),
                      ),
                      selectedChipColor: Colors.blue.withOpacity(0.5),
                      selectedTextStyle: TextStyle(color: Colors.blue[800]),
                      onTap: (values) {
                        if (resultArray == "Posts") {
                          selectedPosts = values;
                        } else if (resultArray == "EmploymentType") {
                          selectedEmploymentType = values;
                        } else if (resultArray == "WorkSetting") {
                          selectedWorkSetting = values;
                        } else if (resultArray == "Specialization") {
                          selectedSpecialization = values;
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: kTitleStyle(
                            context,
                            fontSize: sdp(context, 20),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Register as a Job Finder',
                          style: kTitleStyle(
                            context,
                            fontSize: sdp(context, 13),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    height10,
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 100, top: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
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
                                  width10,
                                  Flexible(
                                    child: kTextField(
                                      context,
                                      controller: lastName,
                                      bgColor: Colors.white,
                                      hintText: 'Smith',
                                      label: 'Last Name',
                                      keyboardType: TextInputType.name,
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
                                          initialDate: DateTime(2000),
                                          firstDate: DateTime(1970),
                                          lastDate: DateTime(
                                              DateTime.now().year - 18),
                                        ).then((value) {
                                          setState(() {
                                            if (value != null) {
                                              dob.text =
                                                  DateFormat('yyyy-MM-dd')
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Gender',
                                          style: TextStyle(
                                              fontSize: sdp(context, 9)),
                                        ),
                                        kHeight(7),
                                        Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius: kRadius(10),
                                            border: Border.all(
                                                color: Colors.grey.shade400),
                                          ),
                                          child: DropdownButton(
                                            value: _selectedGender,
                                            underline: SizedBox.shrink(),
                                            isDense: true,
                                            isExpanded: true,
                                            dropdownColor: Colors.white,
                                            borderRadius: kRadius(10),
                                            alignment: AlignmentDirectional
                                                .bottomCenter,
                                            elevation: 24,
                                            padding: EdgeInsets.all(8),
                                            icon: Icon(Icons
                                                .keyboard_arrow_down_rounded),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Role',
                                    style: TextStyle(fontSize: sdp(context, 9)),
                                  ),
                                  kHeight(7),
                                  Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: kRadius(10),
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                    ),
                                    child: DropdownButton(
                                      value: _selectedRole,
                                      underline: SizedBox.shrink(),
                                      isDense: true,
                                      isExpanded: true,
                                      dropdownColor: Colors.white,
                                      borderRadius: kRadius(10),
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      elevation: 24,
                                      padding: EdgeInsets.all(8),
                                      icon: Icon(
                                          Icons.keyboard_arrow_down_rounded),
                                      iconSize: 20,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Poppins',
                                      ),
                                      items: List.generate(rolesList.length,
                                          (index) {
                                        return DropdownMenuItem(
                                          value: index,
                                          child:
                                              Text(rolesList[index]['title']),
                                        );
                                      }),
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            selectedPosts = [];
                                            selectedEmploymentType = [];
                                            selectedWorkSetting = [];
                                            selectedSpecialization = [];
                                            _selectedRole = value!;
                                            selectedSubRole = 0;
                                            subRolesArr =
                                                rolesList[_selectedRole]
                                                            ['subRoles'] !=
                                                        'NULL'
                                                    ? jsonDecode(
                                                        rolesList[_selectedRole]
                                                            ['subRoles'])
                                                    : [];
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              height10,
                              rolesList[_selectedRole]['subRoles'] == "NULL"
                                  ? SizedBox.shrink()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Sub Role',
                                          style: TextStyle(
                                              fontSize: sdp(context, 9)),
                                        ),
                                        kHeight(7),
                                        Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius: kRadius(10),
                                            border: Border.all(
                                                color: Colors.grey.shade400),
                                          ),
                                          child: DropdownButton(
                                            value: selectedSubRole,
                                            underline: SizedBox.shrink(),
                                            isDense: true,
                                            isExpanded: true,
                                            dropdownColor: Colors.white,
                                            borderRadius: kRadius(10),
                                            alignment: AlignmentDirectional
                                                .bottomCenter,
                                            elevation: 24,
                                            padding: EdgeInsets.all(8),
                                            icon: Icon(Icons
                                                .keyboard_arrow_down_rounded),
                                            iconSize: 20,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                            ),
                                            items: List.generate(
                                                subRolesArr.length, (index) {
                                              return DropdownMenuItem(
                                                value: index,
                                                child: Text(subRolesArr[index]),
                                              );
                                            }),
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  selectedSubRole = value!;
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                              height10,
                              rolesList[_selectedRole]['posts'] == "NULL"
                                  ? SizedBox.shrink()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Post',
                                          style: TextStyle(
                                              fontSize: sdp(context, 9)),
                                        ),
                                        kHeight(7),
                                        selectedPosts.length == 0
                                            ? OutlinedButton(
                                                onPressed: () {
                                                  _showMultiSelect(
                                                    context: context,
                                                    arrayName: 'posts',
                                                    header: "Select Posts",
                                                    resultArray: "Posts",
                                                  );
                                                },
                                                child: Text('Select Posts'),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  _showMultiSelect(
                                                    context: context,
                                                    arrayName: 'posts',
                                                    header: "Select Posts",
                                                    resultArray: "Posts",
                                                  );
                                                },
                                                child: Wrap(
                                                  runSpacing: 5,
                                                  spacing: 5,
                                                  children: List.generate(
                                                    selectedPosts.length,
                                                    (index) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                kPrimaryColorAccentLighter),
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Text(
                                                            selectedPosts[
                                                                index]),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                              height10,
                              rolesList[_selectedRole]['employmentType'] ==
                                      "NULL"
                                  ? SizedBox.shrink()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Employment Type',
                                          style: TextStyle(
                                              fontSize: sdp(context, 9)),
                                        ),
                                        kHeight(7),
                                        selectedPosts.length == 0
                                            ? OutlinedButton(
                                                onPressed: () {
                                                  _showMultiSelect(
                                                    context: context,
                                                    arrayName: 'employmentType',
                                                    header:
                                                        "Select Employment Type",
                                                    resultArray:
                                                        "EmploymentType",
                                                  );
                                                },
                                                child: Text(
                                                    'Select Employment Type'),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  _showMultiSelect(
                                                    context: context,
                                                    arrayName: 'employmentType',
                                                    header:
                                                        "Select Employment Type",
                                                    resultArray:
                                                        "EmploymentType",
                                                  );
                                                },
                                                child: Wrap(
                                                  runSpacing: 5,
                                                  spacing: 5,
                                                  children: List.generate(
                                                    selectedEmploymentType
                                                        .length,
                                                    (index) {
                                                      return Container(
                                                        decoration: BoxDecoration(
                                                            color:
                                                                kPrimaryColorAccentLighter),
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Text(
                                                          selectedEmploymentType[
                                                              index],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                              height10,
                              rolesList[_selectedRole]['workSetting'] == "NULL"
                                  ? SizedBox.shrink()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Work Setting',
                                          style: TextStyle(
                                              fontSize: sdp(context, 9)),
                                        ),
                                        kHeight(7),
                                        selectedPosts.length == 0
                                            ? OutlinedButton(
                                                onPressed: () {
                                                  _showMultiSelect(
                                                    context: context,
                                                    arrayName: 'workSetting',
                                                    header:
                                                        "Select Work Setting",
                                                    resultArray: "WorkSetting",
                                                  );
                                                },
                                                child:
                                                    Text('Select Work Setting'),
                                              )
                                            : GestureDetector(
                                                onTap: () {
                                                  _showMultiSelect(
                                                    context: context,
                                                    arrayName: 'workSetting',
                                                    header:
                                                        "Select Work Setting",
                                                    resultArray: "WorkSetting",
                                                  );
                                                },
                                                child: Wrap(
                                                  runSpacing: 5,
                                                  spacing: 5,
                                                  children: List.generate(
                                                    selectedWorkSetting.length,
                                                    (index) {
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              kPrimaryColorAccentLighter,
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        child: Text(
                                                          selectedWorkSetting[
                                                              index],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              )
                                      ],
                                    ),
                              kTextField(
                                context,
                                controller: specialization,
                                bgColor: Colors.white,
                                hintText: 'MBBS, MD ...',
                                label: "Specialization",
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.characters,
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
                                  width10,
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'State',
                                          style: TextStyle(
                                              fontSize: sdp(context, 9)),
                                        ),
                                        kHeight(7),
                                        Container(
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            borderRadius: kRadius(10),
                                            border: Border.all(
                                                color: Colors.grey.shade400),
                                          ),
                                          child: DropdownButton(
                                            value: _selectedState,
                                            underline: SizedBox.shrink(),
                                            isDense: true,
                                            isExpanded: true,
                                            dropdownColor: Colors.white,
                                            borderRadius: kRadius(10),
                                            menuMaxHeight:
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .5,
                                            alignment: AlignmentDirectional
                                                .bottomCenter,
                                            elevation: 24,
                                            padding: EdgeInsets.all(8),
                                            icon: Icon(Icons
                                                .keyboard_arrow_down_rounded),
                                            iconSize: 20,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                            ),
                                            items: List.generate(
                                                statesList.length, (index) {
                                              return DropdownMenuItem(
                                                value: statesList[index]
                                                        ['stateName']
                                                    .toString(),
                                                child: Text(statesList[index]
                                                    ['stateName']),
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
                                readOnly: widget.type == "Email",
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
                                readOnly: widget.type == "Phone",
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
                  ],
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
          padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (widget.type == "Phone") {
                  registerUsingPhone();
                } else {
                  registerUsingEmail();
                }
              }
            },
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'REGISTER',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
