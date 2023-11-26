import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medilink/dashboardUI.dart';
import 'package:medilink/utils/colors.dart';
import 'package:medilink/utils/components.dart';
import 'package:medilink/utils/constants.dart';
import 'package:medilink/utils/sdp.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

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
  String _selectedRole = '0';
  String _selectedState = statesList[0]['stateName'];

  @override
  void initState() {
    super.initState();
    rolesList = [
      {"id": "0", "title": "Choose Role"}
    ];
    statesList = [
      {"id": "0", "stateName": "Choose State", "abbr": "CS"}
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
        _selectedRole = rolesList[0]['id'];
      });
    }
  }

  Future<void> registerUsingPhone() async {
    setState(() => isLoading = true);
    Map<String, dynamic> body = {};
    try {
      await OneSignal.shared.getDeviceState().then((value) async {
        var fcmToken = value!.userId!;
        // print("FCM" + fcmToken.toString());
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
        "dob": dob,
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
      navPushReplacement(context, const DashboardUI());
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
        // print("FCM" + fcmToken.toString());
        body = {
          "firstName": firstName.text,
          "lastName": lastName.text,
          "dob": dob,
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
        "dob": dob,
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

    print(dataResult);

    if (!dataResult['error']) {
      setState(() => isLoading = false);
      userData = dataResult['response'];
      // navPushReplacement(context, const DashboardUI());
    } else {
      setState(() => isLoading = false);
      Navigator.pop(context);
      kSnackBar(context, content: dataResult['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
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
                      height20,
                      Form(
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
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This is empty!';
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
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This is empty!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            height10,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                                        lastDate:
                                            DateTime(DateTime.now().year - 18),
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
                                        return 'This is empty!';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                width10,
                                Flexible(
                                  child: Container(
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
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      elevation: 24,
                                      padding: EdgeInsets.all(8),
                                      icon: Icon(
                                          Icons.keyboard_arrow_down_rounded),
                                      iconSize: 20,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat',
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
                                ),
                              ],
                            ),
                            height10,
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: kRadius(10),
                                border: Border.all(color: Colors.grey.shade400),
                              ),
                              child: DropdownButton(
                                value: _selectedRole,
                                underline: SizedBox.shrink(),
                                isDense: true,
                                isExpanded: true,
                                dropdownColor: Colors.white,
                                borderRadius: kRadius(10),
                                alignment: AlignmentDirectional.bottomCenter,
                                elevation: 24,
                                padding: EdgeInsets.all(8),
                                icon: Icon(Icons.keyboard_arrow_down_rounded),
                                iconSize: 20,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                ),
                                items: List.generate(rolesList.length, (index) {
                                  return DropdownMenuItem(
                                    value: rolesList[index]['id'].toString(),
                                    child: Text(rolesList[index]['title']),
                                  );
                                }),
                                onChanged: (value) {
                                  setState(() {
                                    print(value);
                                    _selectedRole = value!;
                                  });
                                },
                              ),
                            ),
                            height10,
                            kTextField(
                              context,
                              controller: specialization,
                              bgColor: Colors.white,
                              hintText: 'MBBS, MD ...',
                              label: "Specialization",
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'This is empty!';
                                }
                                return null;
                              },
                            ),
                            height10,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
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
                                        return 'This is empty!';
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
                                          menuMaxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .5,
                                          alignment:
                                              AlignmentDirectional.bottomCenter,
                                          elevation: 24,
                                          padding: EdgeInsets.all(8),
                                          icon: Icon(Icons
                                              .keyboard_arrow_down_rounded),
                                          iconSize: 20,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Montserrat',
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
                                                print(value);
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
                                  return 'This is empty!';
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
                                  return 'This is empty!';
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
                                  return 'This is empty!';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 100,
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
          padding: EdgeInsets.all(15.0),
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

  Row kTextFieldThis(
    BuildContext context, {
    TextEditingController? controller,
    Widget? prefix,
    required String hintText,
    bool obscureText = false,
    Widget? suffix,
  }) {
    return Row(
      children: [
        prefix != null
            ? Padding(
                padding: EdgeInsets.only(right: 20),
                child: CircleAvatar(
                  radius: 25,
                  backgroundColor: kPrimaryColorAccent,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: FittedBox(child: prefix),
                  ),
                ),
              )
            : SizedBox(),
        Flexible(
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(
                color: Colors.white,
                fontSize: sdp(context, 20),
                fontWeight: FontWeight.w600),
            cursorColor: Colors.white,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              suffix: suffix,
              hintText: hintText,
              hintStyle: TextStyle(
                color: kPrimaryColorAccent,
                fontSize: sdp(context, 20),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
