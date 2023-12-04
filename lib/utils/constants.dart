import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

// ------------->
const String appVersion = '1.0.6';
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

// -------------------------------->
