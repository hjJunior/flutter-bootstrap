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
    "Bearer ${await _secureStorage.read(key: kSecureStorageUserToken)}";

  Future<Map<String, String>> get headers async => {
    "Authorization": await _userToken, 'Connection': 'close'};

  Future<List<Map<String, dynamic>>> fetchAll() async {
    final httpResponse = await client.get(
      await fullUrl,
      headers: await headers
    );	
    final parsedJson = json.decode(httpResponse.body);

    return (parsedJson as List).cast<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>> fetch(int id) async {
    final httpResponse = await client.get(
      "${await fullUrl}/$id",
      headers: await headers
    );
    final parsedJson = json.decode(httpResponse.body);
    return (parsedJson as Map<String, dynamic>);
  }
}
