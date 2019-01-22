import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';
import 'package:flutter_bootstrap/consts.dart';
import 'package:flutter_bootstrap/models/restify.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_bootstrap/services/resource_service.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}


class User extends ModelRestify {
  @override
  String get restifyResourceUrl => '/somepath';
}

void main() {
  setUpAll(() {
    final injector = Injector.getInjector();

    MockFlutterSecureStorage fss = MockFlutterSecureStorage();
    when(fss.read(key: kBaseUrl)).thenAnswer((_) => Future.value('http://www.google.com'));
    when(fss.read(key: kSecureStorageUserToken)).thenAnswer((_) => Future.value('token'));

    Client client = MockClient((request) async {
      return Response(json.encode([{"key": "value"}]), 200);
    });

    injector.map<Client>((i) => client);
    injector.map<FlutterSecureStorage>((i) => fss);
  });

  test('adds one to input values', () {
    final calculator = Calculator();
    expect(calculator.addOne(2), 3);
    expect(calculator.addOne(-7), -6);
    expect(calculator.addOne(0), 1);
    expect(() => calculator.addOne(null), throwsNoSuchMethodError);
  });

  group('Service layer', () {
    test("fetchAll", () async {
      final subject = await ResourceService<User>(User()).fetchAll();
      expect(subject, [{"key": "value"}]);
    });

    test("fetch", () async {
      final subject = await ResourceService<User>(User()).fetchAll();
      expect(subject, [{"key": "value"}]);
    });
  });
}
