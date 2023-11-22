import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

String baseUrl = 'https://app-api.shapon.tech';

BorderRadius kRadius(double radius) => BorderRadius.circular(radius);

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
