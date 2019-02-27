import 'dart:async';

import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/restify.dart';
import '../consts.dart';

class ApiService<T extends ModelRestify> {
  ApiService(this.modelInstance, this.client, this._secureStorage);

  final T modelInstance;
  final Client client;
  final FlutterSecureStorage _secureStorage;

  Future<String> get fullUrl async => """${await _secureStorage.read(key: kBaseUrl)}${modelInstance.restifyResourceUrl}""";

  Future<String> get _userToken async =>
//    "Bearer ${await _secureStorage.read(key: kSecureStorageUserToken)}";
    "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsImlzcyI6IlBST0dFVEUiLCJhdWQiOiJwcm9nZXRlLmNvbS5iciIsImV4cCI6MTU1OTU3MzIxOCwic3luYyI6MjQsIm5hbWUiOiJQcm9QZWRpZG9zIiwiYWRtaW4iOmZhbHNlfQ.IFtstUCUZiSAX18w7Ur4UeELqGB4a6QObOZbrykccsM";

  Future<Map<String, String>> get headers async => {
    "Authorization": await _userToken, 'Connection': 'close'};

  Future<List<Map<String, dynamic>>> fetchAll() async {
    final httpResponse = await client.get(
      await fullUrl,
      headers: await headers
    );
    if (httpResponse.statusCode != 200) {
      throw UnauthorizedError('Token invalido ou API desativadda');
    }
    final parsedJson = json.decode(httpResponse.body);
    return (parsedJson as List).cast<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>> fetch(int id) async {
    final httpResponse = await client.get(
      "${await fullUrl}/$id",
      headers: await headers
    );
    if (httpResponse.statusCode != 200) {
      throw UnauthorizedError('Token invalido ou API desativadda');
    }
    final parsedJson = json.decode(httpResponse.body);
    return (parsedJson as Map<String, dynamic>);
  }
}

class UnauthorizedError implements Exception {
  final String cause;
  UnauthorizedError(this.cause);
}