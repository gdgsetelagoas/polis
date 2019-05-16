import 'dart:convert';

import 'package:http/http.dart';
import 'package:res_publica/model/request_response.dart';
import 'package:res_publica/ui/utils/patterns.dart';

RequestResponse error<T>(Response response) {
  if (response.statusCode >= 500)
    return RequestResponse<T>.fail("${response.statusCode}", ['Server error']);
  final json = jsonDecode(response.body);
  return RequestResponse<T>.fail(
      "${response.statusCode}",
      json['errors'] is String
          ? [json['errors']]
          : json['errors'].cast<String>());
}

RequestResponse errorFirebase<T>(Exception e, code) {
  return RequestResponse<T>.fail(
      code.toString(), [firebaseAuthError.firstMatch(e.toString())?.group(1)]);
}
