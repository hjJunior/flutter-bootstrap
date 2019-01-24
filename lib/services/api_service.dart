import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/restify.dart';
import '../consts.dart';

class ApiService<T extends ModelRestify> {
  ApiService(this.modelInstance, this._client, this._secureStorage);

  final T modelInstance;
  final Client _client;
  final FlutterSecureStorage _secureStorage;

  Future<String> get _fullUrl async => """${await _secureStorage.read(key: kBaseUrl)}${modelInstance.restifyResourceUrl}""";

  Future<String> get _userToken async =>
    "Bearer ${await _secureStorage.read(key: kSecureStorageUserToken)}";

  Future<List<Map<String, dynamic>>> fetchAll() async {
    final httpResponse = await _client.get(
      await _fullUrl,
      headers: {"Authorization": await _userToken}
    );	
    final parsedJson = json.decode(httpResponse.body);

    return (parsedJson as List).cast<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>> fetch(int id) async {
    final httpResponse = await _client.get(
        "${await _fullUrl}/$id",
        headers: {"Authorization": await _userToken}
    );
    final parsedJson = json.decode(httpResponse.body);
    return (parsedJson as Map<String, dynamic>);
  }
}
