import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

// ------------->
const String appVersion = '1.0.9';
// ------------->

Map userData = {};

// /------------------------------------------>

String baseUrl = 'https://app-api.shapon.tech';

Future<Map<dynamic, dynamic>> apiCallBack({
  required String method,
  required String path,
  Map<String, dynamic> body = const {},
}) async {
  final dio = Dio();
  Response response;
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String appDocPath = appDocDir.path;
  final jar = PersistCookieJar(
    ignoreExpires: true,
    storage: FileStorage("$appDocPath/.cookies/"),
  );
  dio.interceptors.add(CookieManager(jar));

  final formData = FormData.fromMap(body);

  if (method == 'POST') {
    response = await dio.post(
      baseUrl + path,
      data: formData,
    );
  } else {
    response = await dio.get(baseUrl + path);
  }
  return jsonDecode(response.data);
}

Future<Map<dynamic, dynamic>> apiCallBackMedia({
  required String method,
  required String path,
  required Map<String, dynamic> body,
}) async {
  final dio = Dio();
  Response response;

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String appDocPath = appDocDir.path;
  final jar = PersistCookieJar(
    ignoreExpires: true,
    storage: FileStorage("$appDocPath/.cookies/"),
  );
  dio.interceptors.add(CookieManager(jar));

  final formData = FormData.fromMap(body);

  if (method == 'POST') {
    response = await dio.post(
      baseUrl + path,
      data: formData,
    );
  } else {
    response = await dio.get(baseUrl + path);
  }
  return jsonDecode(response.data);
}

// --------------------------------->

followUnfollowUser({context, setState, followingUserId}) async {
  var dataResult = await apiCallBack(
    method: 'POST',
    path: '/follow/toggle-follow-user.php',
    body: {
      'followingUserId': followingUserId,
    },
  );
  return dataResult;
}

// GLOBAL VARIABLES

List<dynamic> vacancyList = [];
List<dynamic> rolesList = [
  {"id": "0", "title": "Choose Role"}
];
List<dynamic> statesList = [
  {"id": "0", "stateName": "Choose State", "abbr": "CS"}
];
List<dynamic> resumeList = [];
List<dynamic> recruitersList = [];
List<dynamic> appliedVacancies = [];
List<dynamic> bookmarkedVacancies = [];

List experience = [
  "Fresher",
  "1 years",
  "2 years",
  "3 years",
  "4 years",
  "5 years",
  "6 years",
  "7 years",
  "8 years",
  "9 years",
  "10 years",
  "11 years",
  "12 years",
  "13 years",
  "14 years",
  "15 years",
  "16 years",
  "17 years",
  "18 years",
  "19 years",
  "20 years",
  "21 years",
  "22 years",
  "23 years",
  "24 years",
  "25 years",
  "26 years",
  "27 years",
  "28 years",
  "29 years",
  "30 years",
  "31 years",
  "32 years",
  "33 years",
  "34 years",
  "35 years",
  "36 years",
  "37 years",
  "38 years",
  "39 years",
  "40 years",
  "41 years",
  "42 years",
  "43 years",
  "44 years",
  "45 years",
  "46 years",
  "47 years",
  "48 years",
  "49 years",
  "50 years",
  "51 years",
  "52 years",
  "53 years",
  "54 years",
  "55 years",
  "56 years",
  "57 years",
  "58 years",
  "59 years",
  "60 years",
  "61 years",
  "62 years",
  "63 years",
  "64 years",
  "65 years",
  "66 years",
  "67 years",
  "68 years",
  "69 years",
  "70 years",
  "71 years",
  "72 years",
  "73 years",
  "74 years",
  "75 years",
  "76 years",
  "77 years",
  "78 years",
  "79 years",
  "80 years",
  "81 years",
  "82 years",
  "83 years",
  "84 years",
  "85 years",
  "86 years",
  "87 years",
  "88 years",
  "89 years",
  "90 years",
  "91 years",
  "92 years",
  "93 years",
  "94 years",
  "95 years",
  "96 years",
  "97 years",
  "98 years",
  "99 years",
  "100 years"
];


// -------------------------------->
