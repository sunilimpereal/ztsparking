import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:ztsparking/authentication/login/bloc/login_stream.dart';
import '../main.dart';

class API {
  static Map<String, String>? headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${sharedPref.token}',
  };
  static Map<String, String>? postheaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${sharedPref.token}',
  };

  static Future<Response> get(
      {required BuildContext context,
      required String url,
      String? apiRoot,
      Map<String, String>? headers1}) async {
    try {
      log('url: ${apiRoot ?? config.API_ROOT}${url} ');
      var response = await http.get(Uri.parse("${apiRoot ?? config.API_ROOT}$url"),
          headers: headers1 ?? headers);
      log('respose: ${response.statusCode}');
      log('respose: ${response.body}');
      log('tocken: ${sharedPref.token}');
      if (response.statusCode == 401) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        CheckLoginProvider.of(context)?.logout();
      }
      return response;
    } finally {
      //TODO : Dialog box
    }
  }

  static Future<Response> post({
    required String url,
    required Object body,
    required BuildContext context,
    Map<String, String>? headers,
    String? apiRoot,
    bool? logs,
  }) async {
    try {
      log('url: ${apiRoot ?? config.API_ROOT}${url} ');
      log('body: $body');
      var response = await http.post(Uri.parse("${apiRoot ?? config.API_ROOT}$url"),
          body: body, headers: headers ?? postheaders);
      log('respose: ${response.statusCode}');
      log('respose: ${response.body}');
      log('tocken: ${sharedPref.token}');

      return response;
    } finally {
      //TODO : Dialog box
    }
  }

  static Future<Response> patch({
    required String url,
    required Object body,
    required BuildContext context,
    Map<String, String>? headers,
    String? apiRoot,
  }) async {
    try {
      log('url: ${apiRoot ?? config.API_ROOT}${url} ');
      log('body: $body');
      var response = await http.patch(Uri.parse("${apiRoot ?? config.API_ROOT}$url"),
          body: body, headers: headers ?? postheaders);
      log('respose: ${response.statusCode}');
      log('respose: ${response.body}');
      log('tocken: ${sharedPref.token}');

      return response;
    } finally {}
  }
}
